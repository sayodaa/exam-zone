import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.text, required this.onPressed});

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
        onPressed: onPressed,
        // () {
        //   Navigator.pushNamed(context, routeName);
        // }
        child: TextApp(
          text: text,
          style: AppTextStyles.body16(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
