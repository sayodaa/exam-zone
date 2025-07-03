import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/home/presentation/views/home_screen.dart';
import 'package:graduation/features/profile/profile_screen.dart';
import 'package:graduation/features/settings/presentation/views/settings_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  final List<_NavBarItemData> _navItems = [
    _NavBarItemData(
      icon: Icons.dashboard,
      labelKey: LangKeys.createExam,
      color: AppColorsStyles.dark.primaryColor, // Adjust to your primary color
    ),
    _NavBarItemData(
      icon: Icons.person_outline,
      labelKey: LangKeys.profile,
      color: AppColorsStyles.dark.accentColor, // Adjust to your accent color
    ),
    _NavBarItemData(
      icon: Icons.settings,
      labelKey: LangKeys.settings,
      color: AppColorsStyles.dark.secondaryColor, // Adjust to your secondary color
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildAnimatedBottomNavBar(context),
    );
  }

  Widget _buildAnimatedBottomNavBar(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, -2.h),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppColorsStyles.defaultBorderRadius.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          return _buildNavItem(context, index: index);
        }),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required int index}) {
    final item = _navItems[index];
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final scale = isSelected ? 1.2 + 0.2 * _animation.value : 1.0;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? item.color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isSelected)
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.color.withOpacity(0.2),
                        ),
                      ),
                    Transform.scale(
                      scale: scale,
                      child: Icon(
                        item.icon,
                        size: 28.sp,
                        color: isSelected
                            ? item.color
                            : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
                      ),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: isSelected
                      ? TextApp(
                          text: (context).translate(item.labelKey),
                          style: AppTextStyles.caption12(context).copyWith(
                            color: AppColorsStyles.dark.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final String labelKey;
  final Color color;

  const _NavBarItemData({
    required this.icon,
    required this.labelKey,
    required this.color,
  });
}