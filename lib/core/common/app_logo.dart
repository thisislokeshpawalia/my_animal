import 'package:flutter/material.dart';
class AppLogo extends StatelessWidget {
  final double size;
  final bool showShadow;
  final double borderRadius;

  const AppLogo({
    super.key,
    this.size = 120,
    this.showShadow = true,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
            : [],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}