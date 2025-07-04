import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/language/app_localizations.dart';
import 'package:graduation/core/language/lang_keys.dart'; // Import LangKeys
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/theme/theme_provider.dart';
import 'package:graduation/features/settings/presentation/widgets/settings_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextApp(
          text: AppLocalizations.of(context)?.translate(LangKeys.settings) ?? '',
          style: AppTextStyles.semiBold20(context),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        children: [
          SizedBox(height: 8.h),
          CustomFadeInLeft(
            duration: 300,
            child: SettingsTile(
              icon: Icons.notifications,
              title: AppLocalizations.of(context)?.translate(LangKeys.notifications) ?? '',
              subtitle: AppLocalizations.of(context)?.translate(LangKeys.manageNotifications)??'',
            ),
          ),
          SizedBox(height: 8.h),
          CustomFadeInUp(
            duration: 600,
            child: SettingsTile(
              icon: Icons.brightness_6,
              title: AppLocalizations.of(context)?.translate(LangKeys.theme)??'',
              subtitle: AppLocalizations.of(context)?.translate(LangKeys.chooseTheme) ?? '',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: Theme.of(context).sliderTheme.thumbColor,
                inactiveTrackColor: Theme.of(context).sliderTheme.inactiveTrackColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          CustomFadeInRight(
            duration: 300,
            child: SettingsTile(
              icon: Icons.language,
              title: AppLocalizations.of(context)?.translate(LangKeys.language) ?? '',
              subtitle: AppLocalizations.of(context)?.translate(LangKeys.changeLanguage) ?? '',
              trailing: Switch(
                value: themeProvider.currentLocale.languageCode == 'ar',
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeLanguage(value ? 'ar' : 'en');
                },
                activeColor: Theme.of(context).sliderTheme.thumbColor,
                inactiveTrackColor: Theme.of(context).sliderTheme.inactiveTrackColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          CustomFadeInDown(
            duration: 600,
            child: SettingsTile(
              icon: Icons.info,
              title: AppLocalizations.of(context)?.translate(LangKeys.about) ?? '',
              subtitle: AppLocalizations.of(context)?.translate(LangKeys.learnMore) ?? '',
            ),
          ),
        ],
      ),
    );
  }
}