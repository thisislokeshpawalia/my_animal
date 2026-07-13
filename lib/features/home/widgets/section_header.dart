import 'package:flutter/material.dart';

import '../../../app/theme/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.title,
        ),

        const Spacer(),

        TextButton(
          onPressed: onSeeAll,
          child: const Text("See All"),
        )
      ],
    );
  }
}