import 'package:flutter/material.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';

class CustomAppBarForExams extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarForExams({
    super.key,
    required this.text, this.icon,
  });
  final String text;
  final IconData? icon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(icon ?? Icons.arrow_back, color:Theme.of(context).textTheme.bodyMedium?.color),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextApp(
        text:  text,
        style: AppTextStyles.bold24(context),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
      elevation: 0,
    );
  }
}
