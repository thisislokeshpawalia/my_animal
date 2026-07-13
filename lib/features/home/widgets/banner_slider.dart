import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = [
      AppAssets.banner1,
      AppAssets.banner2,
    ];

    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              banners[index],
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 180,
        viewportFraction: 0.95,
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOut,
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: true,
      ),
    );
  }
}