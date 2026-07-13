import 'package:flutter/material.dart';

import '../../../app/theme/app_text_style.dart';
import '../../../core/constants/app_assets.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                "Hello 👋",
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 4),
              Text(
                "Find everything for your pet",
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: onNotificationTap,
          icon: const Badge(
            child: Icon(Icons.notifications_none),
          ),
        ),

        GestureDetector(
          onTap: onProfileTap,
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(AppAssets.avatar),
          ),
        ),
      ],
    );
  }
}