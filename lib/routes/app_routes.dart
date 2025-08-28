import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';

class AppRoutes {

  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}