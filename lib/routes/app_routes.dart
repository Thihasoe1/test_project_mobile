import 'package:go_router/go_router.dart';
import 'package:test_project_mobile/models/product_model.dart';
import 'package:test_project_mobile/screens/home/add_product.dart';
import 'package:test_project_mobile/screens/home/update_product.dart';

import '../screens/home/home_screen.dart';

class AppRoutes {
  ///static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: routeList,
  );

  static List<RouteBase> routeList = [
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: Routes.addProduct,
      builder: (context, state) => const AddProductForm(),
    ),
    GoRoute(
      path: Routes.updateProduct,
      builder:
          (context, state) =>
              UpdateProductForm(product: state.extra as Product),
    ),
  ];
}

class Routes {
  static const String home = '/home';
  static const String addProduct = '/add_product';
  static const String updateProduct = '/update_product';
}
