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
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        TextButton(
          onPressed: onSeeAll,
          child: const Text("See All"),
        )
      ],
    );
  }
}