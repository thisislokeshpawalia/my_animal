import 'package:flutter/material.dart';

import '../widgets/banner_slider.dart';
import '../widgets/category_list.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_grid.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  userName: "Lokesh",
                  onNotificationTap: () {},
                  onProfileTap: () {},
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

                SectionHeader(
                  title: "Featured Products",
                  onSeeAll: () {},
                ),

                const SizedBox(height: 15),

                const ProductGrid(),

                const SizedBox(height: 30),

                SectionHeader(
                  title: "Best Sellers",
                  onSeeAll: () {},
                ),

                const SizedBox(height: 15),

                const ProductGrid(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}