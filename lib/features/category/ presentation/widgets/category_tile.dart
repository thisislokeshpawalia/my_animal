import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../home/models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  category.image,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                category.name,
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 4),

              Text(
                "Browse Products",
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}