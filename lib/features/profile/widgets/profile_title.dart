import 'package:flutter/material.dart';
import '../../../../app/theme/app_color.dart';
import '../../../app/theme/app_text_style.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20),

      leading: CircleAvatar(
        radius: 20,
        backgroundColor:
        AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),

      title: Text(
        title,
        style: AppTextStyles.body,
      ),

      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),

      onTap: onTap,
    );
  }
}