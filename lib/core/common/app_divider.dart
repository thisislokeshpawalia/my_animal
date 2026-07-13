import 'package:flutter/material.dart';

import '../../app/theme/app_color.dart';
import '../../app/theme/app_text_style.dart';


class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.text = "OR",
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: AppTextStyles.caption,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.border,
          ),
        ),
      ],
    );
  }
}