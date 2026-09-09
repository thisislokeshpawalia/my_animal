import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../data/mock_categories.dart';
import 'category_card.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mockCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final category = mockCategories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              context.push(AppRoutes.search, extra: category.name);
            },
          );
        },
      ),
    );
  }
}