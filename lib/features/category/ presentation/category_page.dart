import 'package:flutter/material.dart';
import '../../../app/theme/app_text_style.dart';
import '../../home/data/mock_categories.dart';
import '../../home/widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            TextField(
              decoration: InputDecoration(
                hintText: "Search Category",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "All Categories",
              style: AppTextStyles.heading2,
            ),

            const SizedBox(height: 20),

            /// 👇 ADD THE GRID HERE
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockCategories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (_, index) {
                return CategoryCard(
                  category: mockCategories[index],
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}