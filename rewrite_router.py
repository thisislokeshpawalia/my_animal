import re

# 1. Update app_routes.dart
with open("lib/app/router/app_routes.dart", "r") as f:
    content = f.read()

if "static const category = '/category';" not in content:
    content = content.replace("static const main = '/main';", "static const main = '/main';\n  static const category = '/category';\n  static const profile = '/profile';")
    with open("lib/app/router/app_routes.dart", "w") as f:
        f.write(content)

# 2. Update app_router.dart
with open("lib/app/router/app_router.dart", "r") as f:
    router_content = f.read()

# Remove old GoRoute for home, cart, orders, main
router_content = re.sub(r'      // --------------------------------------------------\n      // HOME\n      // --------------------------------------------------\n      GoRoute\(\n        path: AppRoutes\.home,\n        builder: \(context, state\) \{\n          return const HomePage\(\);\n        \},\n      \),', '', router_content)
router_content = re.sub(r'      // --------------------------------------------------\n      // CART\n      // --------------------------------------------------\n      GoRoute\(\n        path: AppRoutes\.cart,\n        builder: \(context, state\) \{\n          return const CartPage\(\);\n        \},\n      \),', '', router_content)
router_content = re.sub(r'      // --------------------------------------------------\n      // ORDERS\n      // --------------------------------------------------\n      GoRoute\(\n        path: AppRoutes\.orders,\n        builder: \(context, state\) \{\n          return const OrdersPage\(\);\n        \},\n      \),', '', router_content)

main_route_old = """      // --------------------------------------------------
      // MAIN
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) {
          return const MainPage();
        },
      ),"""

main_route_new = """      // --------------------------------------------------
      // MAIN (StatefulShellRoute)
      // --------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.category,
                builder: (context, state) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),"""

router_content = router_content.replace(main_route_old, main_route_new)

# Add missing import for CategoriesPage if missing
if "import '../../features/category/ presentation/category_page.dart';" not in router_content:
    router_content = router_content.replace("import '../../features/main/presentation/main_page.dart';", "import '../../features/main/presentation/main_page.dart';\nimport '../../features/category/ presentation/category_page.dart';\nimport '../../features/profile/presentation/profile_page.dart';")

with open("lib/app/router/app_router.dart", "w") as f:
    f.write(router_content)

