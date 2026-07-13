import 'package:flutter/material.dart';

import '../../../home/data/mock_categories.dart';
import 'category_tile.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockCategories.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: .82,
      ),
      itemBuilder: (_, index) {
        return CategoryTile(
          category: mockCategories[index],
          onTap: () {},
        );
      },
    );
  }
}