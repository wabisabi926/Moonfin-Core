import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:server_core/server_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../playback/appletv_game_player.dart';
import '../../../util/game_cores.dart';

/// Native (tvOS) game player: the libretro core runs in the Runner and renders
/// into a Flutter texture, so this screen stays plain Flutter. It downloads and
/// extracts the ROM, plays with a Bluetooth controller, and syncs the save
/// state on exit.
class NativeGamePlayerScreen extends StatefulWidget {
  const NativeGamePlayerScreen({
    super.key,
    required this.libraryId,
    required this.gameId,
    required this.core,
    this.startFresh = false,
  });

  final String libraryId;
  final String gameId;
  final String core;
  final bool startFresh;

  @override
  State<NativeGamePlayerScreen> createState() => _NativeGamePlayerScreenState();
}

class _NativeGamePlayerScreenState extends State<NativeGamePlayerScreen> {
  final MediaServerClient _client = GetIt.instance<MediaServerClient>();
  final AppleTvGamePlayer _player = AppleTvGamePlayer();

  String? _error;
  String _status = '';
  double? _progress;
  int? _textureId;
  double _aspect = 4 / 3;
  int _controllers = 1;
  bool _exiting = false;
  StreamSubscription<Map<String, dynamic>>? _events;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _events = AppleTvGamePlayer.events.listen(_onEvent);
    _prepare();
  }

  @override
  void dispose() {
    _events?.cancel();
    WakelockPlus.disable();
    unawaited(_player.stop());
    super.dispose();
  }

  void _onEvent(Map<String, dynamic> event) {
    switch (event['event']) {
      case 'videoGeometry':
        final aspect = (event['aspect'] as num?)?.toDouble();
        if (aspect != null && aspect > 0 && mounted) {
          setState(() => _aspect = aspect);
        }
      case 'controllersChanged':
        final count = (event['count'] as num?)?.toInt() ?? 0;
        if (mounted) setState(() => _controllers = count);
        if (count == 0) {
          _player.pause();
        } else {
          _player.resume();
        }
      case 'menuPressed':
        _exit();
      case 'remotePress':
        if (event['key'] == 'menu') _exit();
      case 'error':
        if (mounted) {
          setState(() => _error = event['message']?.toString() ?? 'Error');
        }
    }
  }

  Future<void> _prepare() async {
    final games = _client.gamesApi;
    if (games == null) {
      setState(() => _error = 'This server does not support games.');
      return;
    }
    final coreId = bundledCoreId(widget.core);
    if (coreId == null) {
      setState(
          () => _error = 'This system is not supported on Apple TV yet.');
      return;
    }

    try {
      final detail = await games.getGame(widget.libraryId, widget.gameId);
      if (detail == null || !mounted) {
        if (mounted) setState(() => _error = 'Game not found.');
        return;
      }

      final cacheRoot = await getApplicationCacheDirectory();
      final gamesRoot = Directory('${cacheRoot.path}/games');
      final systemDir = Directory('${gamesRoot.path}/system');
      final saveDir = Directory('${gamesRoot.path}/saves');
      final cacheDir = Directory(
          '${gamesRoot.path}/cache/${widget.libraryId}/${widget.gameId}');
      for (final dir in [systemDir, saveDir, cacheDir]) {
        await dir.create(recursive: true);
      }

      setState(() => _status = 'Downloading...');
      final romFile = File('${cacheDir.path}/${detail.fileName}');
      if (!await romFile.exists()) {
        await games.downloadRom(
          widget.libraryId,
          widget.gameId,
          romFile.path,
          onProgress: (received, total) {
            if (mounted && total > 0) {
              setState(() => _progress = received / total);
            }
          },
        );
      }

      for (final bios in detail.bios) {
        final biosFile = File('${systemDir.path}/${bios.fileName}');
        if (!await biosFile.exists()) {
          await games.downloadBios(widget.libraryId, bios.id, biosFile.path);
        }
      }
      if (!mounted) return;

      setState(() {
        _status = 'Starting...';
        _progress = null;
      });
      final contentPath = await _extractIfArchive(romFile, cacheDir);
      if (contentPath == null) {
        if (mounted) {
          setState(() => _error = 'This archive format is not supported.');
        }
        return;
      }

      final settingsJson =
          await _loadSettings(games, coreId).catchError((_) => null);
      final info = await _player.load(
        core: coreId,
        romPath: contentPath,
        systemDir: systemDir.path,
        saveDir: saveDir.path,
        gameId: widget.gameId,
        options: settingsJson,
      );
      if (!mounted) {
        await _player.stop();
        return;
      }
      _aspect = info.aspect > 0 ? info.aspect : 4 / 3;
      _controllers = await _player.controllerCount();

      await _player.start();
      if (!widget.startFresh) {
        final save = await games.getSave(widget.gameId);
        if (save != null && save.isNotEmpty) {
          await _player.loadState(Uint8List.fromList(save));
        }
      }
      if (mounted) setState(() => _textureId = info.textureId);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Could not start this game. ($e)');
      }
    }
  }

  /// Returns the playable content path: the file itself, or the ROM extracted
  /// from a .zip next to it. 7z is not readable here yet.
  Future<String?> _extractIfArchive(File file, Directory cacheDir) async {
    final lower = file.path.toLowerCase();
    if (lower.endsWith('.7z')) return null;
    if (!lower.endsWith('.zip')) return file.path;

    final marker = File('${cacheDir.path}/.extracted');
    if (await marker.exists()) {
      final existing = await marker.readAsString();
      if (existing.isNotEmpty && await File(existing).exists()) {
        return existing;
      }
    }

    final input = InputFileStream(file.path);
    try {
      final archive = ZipDecoder().decodeStream(input);
      ArchiveFile? best;
      for (final entry in archive) {
        if (!entry.isFile) continue;
        if (best == null || entry.size > best.size) best = entry;
      }
      if (best == null) return null;
      final outPath = '${cacheDir.path}/${best.name.split('/').last}';
      final output = OutputFileStream(outPath);
      best.writeContent(output);
      await output.close();
      await marker.writeAsString(outPath);
      return outPath;
    } finally {
      await input.close();
    }
  }

  Future<Map<String, String>?> _loadSettings(
      GamesApi games, String coreId) async {
    final blob = await games.getSave('moonfin-native-$coreId', kind: 'settings');
    if (blob == null || blob.isEmpty) return null;
    final text = String.fromCharCodes(blob);
    final map = <String, String>{};
    for (final line in text.split('\n')) {
      final eq = line.indexOf('=');
      if (eq > 0) {
        map[line.substring(0, eq)] = line.substring(eq + 1);
      }
    }
    return map.isEmpty ? null : map;
  }

  Future<void> _exit() async {
    if (_exiting) return;
    _exiting = true;
    final games = _client.gamesApi;
    try {
      if (_textureId != null && games != null) {
        final state = await _player.saveState();
        if (state != null && state.isNotEmpty) {
          await games.putSave(widget.gameId, state);
        }
        final options = await _player.getCurrentOptions();
        if (options.isNotEmpty) {
          final coreId = bundledCoreId(widget.core);
          final blob = options.entries
              .map((e) => '${e.key}=${e.value}')
              .join('\n')
              .codeUnits;
          await games.putSave('moonfin-native-$coreId', blob,
              kind: 'settings');
        }
      }
    } catch (_) {
      // Exit must not be blocked by sync failures.
    }
    await _player.stop();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_textureId != null)
            Center(
              child: AspectRatio(
                aspectRatio: _aspect,
                child: Texture(textureId: _textureId!),
              ),
            ),
          if (_textureId == null && _error == null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _status,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (_progress != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 320,
                      child: LinearProgressIndicator(value: _progress),
                    ),
                  ],
                ],
              ),
            ),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          if (_textureId != null && _controllers == 0)
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: const Text(
                'Connect a Bluetooth game controller to play.',
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
        ],
      ),
    );
  }
}
