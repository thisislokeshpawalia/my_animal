import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/service/biomertic/biometric_service.dart';
import '../../../core/service/biomertic/biometric_preference_service.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_title.dart'; // Note: Assuming this provides ProfileTile layout

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vendor/presentation/vendor_registration_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final BiometricService biometricService = BiometricService();
  final BiometricPreferenceService preferenceService = BiometricPreferenceService();

  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    loadBiometricStatus();
  }

  Future<void> loadBiometricStatus() async {
    final status = await preferenceService.isEnabled();
    if (mounted) {
      setState(() {
        biometricEnabled = status;
      });
    }
  }

  Future<void> changeBiometric(bool value) async {
    if (value) {
      bool success = await biometricService.authenticate();
      if (success) {
        await preferenceService.setEnabled(true);
        if (mounted) {
          setState(() {
            biometricEnabled = true;
          });
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric login enabled")),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric authentication failed")),
        );
      }
    } else {
      await preferenceService.setEnabled(false);
      if (mounted) {
        setState(() {
          biometricEnabled = false;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric login disabled")),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red.shade400,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Logout",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to logout from your MyAnimal account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");

    if (!context.mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProfileHeader(),
            const SizedBox(height: 30),

            // --- NEW DASHBOARD GRID SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1, // Adjust this ratio to tweak card height
                    children: [
                      _buildDashboardCard(
                        icon: Icons.shopping_bag_outlined,
                        label: "My Orders",
                        onTap: () {

                          context.push(AppRoutes.orders);

                        },
                      ),
                      _buildDashboardCard(
                        icon: Icons.favorite_outline,
                        label: "Wishlist",
                        onTap: () {
                          context.push(AppRoutes.wishlist);
                        },
                      ),
                      _buildDashboardCard(
                        icon: Icons.location_on_outlined,
                        label: "Addresses",
                        onTap: () {
                          context.push(AppRoutes.savedAddress);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ----------------------------------

            const SizedBox(height: 24),

            ProfileSection(
              title: "Account",
              children: [
                ProfileTile(
                  icon: Icons.admin_panel_settings,
                  title: "Admin Dashboard",
                  onTap: () => context.push(AppRoutes.adminDashboard),
                ),
                const Divider(height: 1),
                ProfileTile(
                  icon: Icons.person_outline,
                  title: "Personal Information",
                  onTap: () => context.push(AppRoutes.updateProfile),
                ),
                const Divider(height: 1),
                  Consumer(
                  builder: (context, ref, child) {
                    final vendorState = ref.watch(vendorRegistrationControllerProvider);
                    
                    if (vendorState.isInitializing) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (vendorState.status == VendorStatus.verified) {
                      return Column(
                        children: [
                          ProfileTile(
                            icon: Icons.dashboard,
                            title: "Vendor Dashboard",
                            onTap: () => context.push(AppRoutes.vendorDashboard),
                          ),
                          const Divider(height: 1),
                          ProfileTile(
                            icon: Icons.storefront,
                            title: "Your Vendor Details",
                            onTap: () => context.push(AppRoutes.vendorDetails),
                          ),
                        ],
                      );
                    } else if (vendorState.status == VendorStatus.pending) {
                      return ProfileTile(
                        icon: Icons.hourglass_top,
                        title: "Registration Pending",
                        onTap: () => context.push(AppRoutes.vendorRegistration),
                      );
                    }
                    
                    return ProfileTile(
                      icon: Icons.storefront,
                      title: "Become a vendor",
                      onTap: () => context.push(AppRoutes.vendorRegistration),
                    );
                  },
                ),
                const Divider(height: 1),
                ProfileTile(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  onTap: () {},
                ),
                const Divider(height: 1),
                ProfileTile(
                  icon: Icons.fingerprint,
                  title: "Biometric Login",
                  trailing: Switch(
                    value: biometricEnabled,
                    onChanged: changeBiometric,
                  ),
                  onTap: () => changeBiometric(!biometricEnabled),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ProfileSection(
              title: "Support",
              children: [
                ProfileTile(
                  icon: Icons.payment,
                  title: "Payment Method",
                  onTap: () {},
                ),
                const Divider(height: 1),
                ProfileTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                const Divider(height: 1),
                ProfileTile(
                  icon: Icons.star_outline,
                  title: "Rate App",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper builder widget to keep the layout code clean
  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}