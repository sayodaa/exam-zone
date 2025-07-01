import 'package:flutter/material.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_text_styles.dart';

class HaveAuth extends StatelessWidget {
  const HaveAuth({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style?.copyWith(
                  foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ) ??
            TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
        onPressed: onPressed,
        child: TextApp(
          text: text,
          style: AppTextStyles.body14(context).copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
