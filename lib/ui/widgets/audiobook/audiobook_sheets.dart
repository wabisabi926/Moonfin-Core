import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonfin_design/moonfin_design.dart';

import '../../../l10n/app_localizations.dart';
import '../../../playback/sleep_timer_controller.dart';
import '../../../util/platform_detection.dart';
import '../overlay_sheet.dart';
import 'audiobook_time.dart';

Future<void> showAudiobookSpeedSheet({
  required BuildContext context,
  required double current,
  required ValueChanged<double> onChanged,
}) {
  return _showAdaptiveSheet<void>(
    context,
    (ctx) => _SpeedSheet(current: current, onChanged: onChanged),
  );
}

Future<void> showAudiobookSleepSheet({
  required BuildContext context,
  required SleepTimerController controller,
  required ValueChanged<int> onPickPreset,
  required VoidCallback onPickEndOfChapter,
  required VoidCallback onCancel,
}) {
  return _showAdaptiveSheet<void>(
    context,
    (ctx) => _SleepSheet(
      controller: controller,
      onPickPreset: onPickPreset,
      onPickEndOfChapter: onPickEndOfChapter,
      onCancel: onCancel,
    ),
  );
}

Future<String?> showAudiobookNoteEditor({
  required BuildContext context,
  required String initialText,
  required String positionLabel,
}) {
  return _showAdaptiveSheet<String>(
    context,
    (ctx) => _NoteEditorSheet(
      initialText: initialText,
      positionLabel: positionLabel,
    ),
    scrollControlled: true,
  );
}

Future<T?> _showAdaptiveSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool scrollControlled = false,
}) {
  if (PlatformDetection.isApple) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) => _CupertinoSheetShell(child: builder(ctx)),
    );
  }
  return showFocusRestoringModalBottomSheet<T>(
    context: context,
    isScrollControlled: scrollControlled,
    useSafeArea: scrollControlled,
    backgroundColor: AppColorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: builder,
  );
}

class _CupertinoSheetShell extends StatelessWidget {
  const _CupertinoSheetShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Material(type: MaterialType.transparency, child: child),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _SheetChoice extends StatelessWidget {
  const _SheetChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!PlatformDetection.isApple) {
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      );
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppColorScheme.accent.withValues(alpha: 0.18)
              : AppColorScheme.onSurface.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColorScheme.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColorScheme.accent : AppColorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

Widget _adaptiveSheetSlider({
  required double value,
  required double min,
  required double max,
  required int divisions,
  required ValueChanged<double> onChanged,
  ValueChanged<double>? onChangeEnd,
}) {
  if (PlatformDetection.isApple) {
    return CupertinoSlider(
      value: value.clamp(min, max),
      min: min,
      max: max,
      divisions: divisions,
      activeColor: AppColorScheme.accent,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
    );
  }
  return Slider(
    value: value.clamp(min, max),
    min: min,
    max: max,
    divisions: divisions,
    onChanged: onChanged,
    onChangeEnd: onChangeEnd,
  );
}

class _SpeedSheet extends StatefulWidget {
  const _SpeedSheet({required this.current, required this.onChanged});

  final double current;
  final ValueChanged<double> onChanged;

  @override
  State<_SpeedSheet> createState() => _SpeedSheetState();
}

class _SpeedSheetState extends State<_SpeedSheet> {
  late double _value = widget.current;
  static const _presets = [0.8, 1.0, 1.25, 1.5, 1.75, 2.0, 3.0];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apple = PlatformDetection.isApple;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(l10n.audiobookPlaybackSpeed),
          const SizedBox(height: AppSpacing.spaceMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _presets)
                _SheetChoice(
                  label: '${p}x',
                  selected: (_value - p).abs() < 0.01,
                  onTap: () {
                    setState(() => _value = p);
                    widget.onChanged(p);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              SizedBox(width: 52, child: Text('${_value.toStringAsFixed(2)}x')),
              Expanded(
                child: _adaptiveSheetSlider(
                  value: _value,
                  min: 0.5,
                  max: 3.5,
                  divisions: 30,
                  onChanged: (v) => setState(() => _value = v),
                  onChangeEnd: widget.onChanged,
                ),
              ),
              if (apple)
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {
                    setState(() => _value = 1.0);
                    widget.onChanged(1.0);
                  },
                  child: Text(l10n.audiobookSpeedReset),
                )
              else
                TextButton(
                  onPressed: () {
                    setState(() => _value = 1.0);
                    widget.onChanged(1.0);
                  },
                  child: Text(l10n.audiobookSpeedReset),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SleepSheet extends StatelessWidget {
  const _SleepSheet({
    required this.controller,
    required this.onPickPreset,
    required this.onPickEndOfChapter,
    required this.onCancel,
  });

  final SleepTimerController controller;
  final ValueChanged<int> onPickPreset;
  final VoidCallback onPickEndOfChapter;
  final VoidCallback onCancel;

  static const _presets = [5, 15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(l10n.audiobookSleepTimer),
          const SizedBox(height: AppSpacing.spaceMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SheetChoice(
                label: l10n.audiobookSleepOff,
                selected: controller.mode == SleepTimerMode.off,
                onTap: () {
                  onCancel();
                  Navigator.of(context).maybePop();
                },
              ),
              for (final m in _presets)
                _SheetChoice(
                  label: l10n.audiobookSleepMinutes(m),
                  selected:
                      controller.mode == SleepTimerMode.duration &&
                      (controller.totalRequested.inMinutes - m).abs() < 1,
                  onTap: () {
                    onPickPreset(m);
                    Navigator.of(context).maybePop();
                  },
                ),
              _SheetChoice(
                label: l10n.audiobookSleepEndOfChapter,
                selected: controller.mode == SleepTimerMode.endOfChapter,
                onTap: () {
                  onPickEndOfChapter();
                  Navigator.of(context).maybePop();
                },
              ),
            ],
          ),
          if (controller.isActive) ...[
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              l10n.audiobookSleepRemaining(
                formatAudiobookCountdown(controller.remaining),
              ),
              style: TextStyle(
                color: AppColorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteEditorSheet extends StatefulWidget {
  const _NoteEditorSheet({
    required this.initialText,
    required this.positionLabel,
  });

  final String initialText;
  final String positionLabel;

  @override
  State<_NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<_NoteEditorSheet> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apple = PlatformDetection.isApple;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                apple ? CupertinoIcons.pencil : Icons.edit_note,
                color: AppColorScheme.accent,
              ),
              const SizedBox(width: 8),
              _SheetTitle(l10n.audiobookEditNote),
              const Spacer(),
              Text(
                widget.positionLabel,
                style: TextStyle(
                  color: AppColorScheme.onSurface.withValues(alpha: 0.6),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          if (apple)
            CupertinoTextField(
              controller: _controller,
              autofocus: true,
              maxLines: 5,
              placeholder: l10n.audiobookNoteHint,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColorScheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
            )
          else
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.audiobookNoteHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (apple) ...[
                CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.audiobookCancel),
                ),
                const SizedBox(width: 8),
                CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pop(_controller.text.trim()),
                  child: Text(l10n.audiobookSave),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.audiobookCancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(_controller.text.trim()),
                  child: Text(l10n.audiobookSave),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
