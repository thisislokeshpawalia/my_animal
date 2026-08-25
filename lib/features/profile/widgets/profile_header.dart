import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme/app_color.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_text_style.dart';
import '../../../core/constants/app_assets.dart';

class ProfileHeader extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const ProfileHeader({super.key, this.onProfileUpdated});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String _name = "Lokesh Pawalia";
  String _email = "lokesh@email.com";
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _name = prefs.getString('user_name') ?? "Lokesh Pawalia";
        _email = prefs.getString('user_email') ?? "lokesh@email.com";
        _imagePath = prefs.getString('user_profile_image'); // Load dynamic image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine target profile image provider state mapping definitions
    ImageProvider avatarImage;
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      avatarImage = FileImage(File(_imagePath!));
    } else {
      avatarImage = const AssetImage(AppAssets.avatar);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.primary,
            backgroundImage: avatarImage,
          ),
          const SizedBox(height: 16),
          Text(_name, style: AppTextStyles.title),
          const SizedBox(height: 6),
          Text(_email, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await context.push(AppRoutes.updateProfile);
              _loadUserData(); // Auto-refresh when returning
              if (widget.onProfileUpdated != null) {
                widget.onProfileUpdated!();
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}