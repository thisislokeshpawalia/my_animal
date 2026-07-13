import 'package:flutter/material.dart';

import '../../app/theme/app_color.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 28,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(
          AppColors.primary,
        ),
      ),
    );
  }
}