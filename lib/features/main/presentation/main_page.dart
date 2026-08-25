import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_animal/features/main/presentation/widget/bottom_nav_bar.dart';

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  
  const MainPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(navigationShell: navigationShell),
    );
  }
}
