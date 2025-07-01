import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextApp(
          text: 'Settings',
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
          _buildSettingsTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View and edit your profile',
            context: context,
          ),
          SizedBox(height: 8.h),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            context: context,
          ),
          SizedBox(height: 8.h),
          _buildSettingsTile(
            icon: Icons.brightness_6,
            title: 'Theme',
            subtitle: 'Switch between Light and Dark mode',
            context: context,
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Theme.of(context).sliderTheme.thumbColor,
              inactiveTrackColor: Theme.of(context).sliderTheme.inactiveTrackColor,
            ),
          ),
          SizedBox(height: 8.h),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Configure your privacy settings',
            context: context,
          ),
          SizedBox(height: 8.h),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'About',
            subtitle: 'Learn more about the app',
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 24.sp,
          ),
          title: TextApp(
            text: title,
            style: AppTextStyles.medium16(context),
          ),
          subtitle: TextApp(
            text: subtitle,
            style: AppTextStyles.caption12Light(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: trailing,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
        ),
      ),
    );
  }
}