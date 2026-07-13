import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_animal/features/main/presentation/widget/bottom_nav_bar.dart';

import '../../cart/presentation/cart_page.dart';
import '../../category/ presentation/category_page.dart';
import '../../home/presentation/home_page.dart';
import '../../orders/presentation/orders_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../wishlist/presentation/wishlist_page.dart';
import '../providers/bottom_nav_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final pages = const [
      HomePage(),
      CategoriesPage(),
      CartPage(),
      OrdersPage(),
      ProfilePage(),
    ];


    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}