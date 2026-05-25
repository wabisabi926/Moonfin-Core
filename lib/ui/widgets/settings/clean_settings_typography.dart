import 'package:flutter/material.dart';

const String kCleanSettingsFontFamily = 'NotoSans';

Widget withCleanSettingsTypography(BuildContext context, Widget child) {
  final theme = Theme.of(context);
  return Theme(
    data: theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: kCleanSettingsFontFamily),
      primaryTextTheme: theme.primaryTextTheme.apply(
        fontFamily: kCleanSettingsFontFamily,
      ),
    ),
    child: child,
  );
}