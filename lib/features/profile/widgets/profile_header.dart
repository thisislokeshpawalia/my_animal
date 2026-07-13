import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';
import '../../../app/theme/app_text_style.dart';
import '../../../core/constants/app_assets.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [

          const CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.primary,
            backgroundImage: AssetImage(AppAssets.avatar)
          ),

          const SizedBox(height: 16),

          Text(
            "Lokesh Pawalia",
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 6),

          Text(
            "lokesh@email.com",
            style: AppTextStyles.bodyMedium,
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {},

            icon: const Icon(Icons.edit),

            label: const Text("Edit Profile"),

            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}