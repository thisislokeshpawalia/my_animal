// lib/features/home/presentation/widgets/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_text_style.dart';
import '../../../core/service/location/address_provider.dart';

class HomeAppBar extends ConsumerWidget {
  final String userName;
  final ImageProvider profileImageProvider;
  final VoidCallback onNotificationTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onProfileTap;
  final VoidCallback? onLocationTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.profileImageProvider,
    required this.onNotificationTap,
    required this.onWishlistTap,
    required this.onProfileTap,
    this.onLocationTap,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // -----------------------------------------
    // GET SAVED ADDRESSES
    // -----------------------------------------

    final addresses = ref.watch(addressProvider);

    // -----------------------------------------
    // FIND DEFAULT ADDRESS
    // -----------------------------------------

    final defaultAddress = addresses.isEmpty
        ? null
        : addresses.firstWhere(
          (address) => address.isDefault,
      orElse: () => addresses.first,
    );

    // -----------------------------------------
    // LOCATION TEXT
    // -----------------------------------------

    String locationText = 'Add your location';

    if (defaultAddress != null) {
      // Show city and state
      locationText =
      '${defaultAddress.city}, ${defaultAddress.state}';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =================================================
        // USER + LOCATION
        // =================================================

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome
              Text(
                'Welcome back,',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: 2),

              // User Name
              Text(
                userName,
                style: AppTextStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Location
              GestureDetector(
                onTap: onLocationTap,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),

                    const SizedBox(width: 4),

                    Flexible(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 3),

                    // Icon(
                    //   Icons.keyboard_arrow_down,
                    //   size: 16,
                    //   color: Colors.grey.shade700,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // =================================================
        // ACTIONS
        // =================================================

        Row(
          children: [
            // Wishlist
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
              ),
              onPressed: onWishlistTap,
            ),

            // Notifications
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
              ),
              onPressed: onNotificationTap,
            ),

            const SizedBox(width: 8),

            // Profile
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: profileImageProvider,
              ),
            ),
          ],
        ),
      ],
    );
  }
}