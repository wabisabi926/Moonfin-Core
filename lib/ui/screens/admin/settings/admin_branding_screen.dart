import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moonfin_design/moonfin_design.dart';
import 'package:server_core/server_core.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/admin_form_styles.dart';

class AdminBrandingScreen extends StatefulWidget {
  const AdminBrandingScreen({super.key});

  @override
  State<AdminBrandingScreen> createState() => _AdminBrandingScreenState();
}

class _AdminBrandingScreenState extends State<AdminBrandingScreen> {
  late final AdminSystemApi _api;
  Map<String, dynamic>? _config;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = GetIt.instance<MediaServerClient>().adminSystemApi;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final config = await _api.getNamedConfiguration('branding');
      if (!mounted) return;
      setState(() {
        _config = config;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_config == null) return;
    setState(() => _saving = true);
    try {
      await _api.updateNamedConfiguration('branding', _config!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).adminBrandingSaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).adminSettingsSaveFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _config == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.adminBrandingLoadFailed,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error ?? l10n.adminUnknownError,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: _load, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 20, 16, bottomSafe + 40),
      children: [
        adminScreenHeader(
          context,
          title: l10n.adminBrandingTitle,
          icon: Icons.brush_outlined,
        ),
        adminSectionLabel(context, l10n.adminBrandingLoginDisclaimer,
            icon: Icons.gavel_outlined),
        TextFormField(
          initialValue: _config!['LoginDisclaimer']?.toString() ?? '',
          decoration: adminInputDecoration(
            label: l10n.adminBrandingLoginDisclaimer,
            hint: l10n.adminBrandingLoginDisclaimerHint,
          ),
          maxLines: 5,
          onChanged: (v) => _config!['LoginDisclaimer'] = v,
        ),
        adminSectionLabel(context, l10n.adminBrandingCustomCss,
            icon: Icons.code),
        TextFormField(
          initialValue: _config!['CustomCss']?.toString() ?? '',
          decoration: adminInputDecoration(
            label: l10n.adminBrandingCustomCss,
            hint: l10n.adminBrandingCustomCssHint,
          ),
          maxLines: 10,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          onChanged: (v) => _config!['CustomCss'] = v,
        ),
        adminSection(
          context,
          title: l10n.adminBrandingEnableSplash,
          icon: Icons.image_outlined,
          children: [
            adminSwitchRow(
              title: l10n.adminBrandingEnableSplash,
              value: _config!['SplashscreenEnabled'] as bool? ?? false,
              onChanged: (v) =>
                  setState(() => _config!['SplashscreenEnabled'] = v),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceXl),
        adminSaveButton(label: l10n.save, saving: _saving, onPressed: _save),
      ],
    );
  }
}
