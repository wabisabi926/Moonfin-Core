import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../preference/user_preferences.dart';
import '../../widgets/settings/clean_settings_typography.dart';
import '../../widgets/settings/preference_tiles.dart';
import 'settings_app_bar.dart';

class LocalPreviewsSettingsScreen extends StatelessWidget {
  const LocalPreviewsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return withCleanSettingsTypography(
      context,
      Scaffold(
        appBar: buildSettingsAppBar(
          context,
          Text(l10n.localPreviews),
        ),
        body: ListView(
          children: [
            SwitchPreferenceTile(
              preference: UserPreferences.mediaBarTrailerPreview,
              title: l10n.trailerPreview,
              subtitle: l10n.autoPlayTrailers,
              icon: Icons.movie_outlined,
            ),
            SwitchPreferenceTile(
              preference: UserPreferences.episodePreviewEnabled,
              title: l10n.mediaPreview,
              subtitle: l10n.mediaPreviewDescription,
              icon: Icons.ondemand_video,
            ),
            SwitchPreferenceTile(
              preference: UserPreferences.previewAudioEnabled,
              title: l10n.previewAudio,
              subtitle: l10n.enablePreviewAudio,
              icon: Icons.volume_up,
            ),
          ],
        ),
      ),
    );
  }
}
