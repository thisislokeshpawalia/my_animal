import 'package:flutter/material.dart';

import '../../../app/theme/app_text_style.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(12),
                child: Image.asset(
                  product.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                product.name,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: AppTextStyles.label,
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "₹${product.price.toInt()}",
                style: AppTextStyles.title,
              ),

              Text(
                "₹${product.oldPrice.toInt()}",
                style: const TextStyle(
                  decoration:
                  TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Add to Cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}