import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_color.dart';
import '../../../cart/provider/cart_provider.dart';

class AppBottomNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppBottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    final cartCount = cartItems.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,

      onDestinationSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },

      backgroundColor: Colors.white,

      indicatorColor: AppColors.primary.withValues(alpha: 0.15),

      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        const NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: "Categories",
        ),

        NavigationDestination(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(cartCount.toString()),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(cartCount.toString()),
            child: const Icon(Icons.shopping_cart),
          ),
          label: "Cart",
        ),

        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: "Orders",
        ),

        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
