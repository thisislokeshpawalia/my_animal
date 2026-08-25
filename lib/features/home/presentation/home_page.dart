// lib/features/home/presentation/home_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/router/app_routes.dart';
import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../../vendor/presentation/vendor_dashboard_controller.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_list.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_grid.dart';
import '../widgets/section_header.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _userName = "User";
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? "User";
        _profileImagePath = prefs.getString('user_profile_image');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the API data stream
    final productsAsyncValue = ref.watch(productsProvider);
    
    // Watch the vendor products
    final vendorProducts = ref.watch(vendorDashboardControllerProvider);
    final mappedVendorProducts = vendorProducts.map((vp) => Product(
      id: int.tryParse(vp.id) ?? 9999,
      title: vp.name,
      price: vp.price,
      description: vp.description,
      category: vp.category,
      image: vp.imageUrl,
      rating: 5.0,
      ratingCount: 1,
    )).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(
                  userName: _userName,
                  profileImageProvider: _profileImagePath != null && _profileImagePath!.isNotEmpty
                      ? FileImage(File(_profileImagePath!)) as ImageProvider
                      : const AssetImage('assets/images/default_avatar.png'),
                  onNotificationTap: () {},
                  onWishlistTap: () => context.push(AppRoutes.wishlist),
                  onProfileTap: () async {
                    await context.push(AppRoutes.updateProfile);
                    _loadUserProfile();
                  },
                ),
                const SizedBox(height: 20),
                const HomeSearchBar(),
                const SizedBox(height: 20),
                const BannerSlider(),
                const SizedBox(height: 30),
                SectionHeader(
                  title: "Shop By Pet",
                  onSeeAll: () {},
                ),
                const SizedBox(height: 15),
                const CategoryList(),
                const SizedBox(height: 30),

                // Handle API Response States
                productsAsyncValue.when(
                  data: (apiProducts) {
                    // Combine vendor products with API products
                    final products = [...mappedVendorProducts.reversed, ...apiProducts];
                    
                    // Slicing the response to populate different sections
                    final featuredProducts = products.take(4).toList();
                    final bestSellersProducts = products.skip(4).take(4).toList();

                    return Column(
                      children: [
                        SectionHeader(
                          title: "Featured Products",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ProductGrid(products: featuredProducts),
                        const SizedBox(height: 30),
                        SectionHeader(
                          title: "Best Sellers",
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 15),
                        ProductGrid(products: bestSellersProducts),
                        const SizedBox(height: 30),

                        SectionHeader(
                          title: "All Products",
                          onSeeAll: () {},
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // THIS DISPLAYS ALL PRODUCTS
                        // FROM THE API
                        ProductGrid(
                          products: products,
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  },
                  loading: () => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.56,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "Failed to load products.\n$error",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}