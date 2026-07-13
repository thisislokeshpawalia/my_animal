import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                "Search food, toys, medicines...",
              ),
            ),

            Icon(Icons.mic_none),

            SizedBox(width: 12),

            Icon(Icons.camera_alt_outlined),
          ],
        ),
      ),
    );
  }
}