import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._internal();
  static final AppRouter _instance = AppRouter._internal();
  static AppRouter get instance => _instance;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  // Replace these placeholders with real screens later.
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';

  final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splashRoute,
    routes: <RouteBase>[
      GoRoute(
        path: splashRoute,
        name: 'splash',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Splash',
          subtitle: 'Replace with real SplashScreen',
          icon: Icons.gavel_outlined,
        ),
      ),
      GoRoute(
        path: homeRoute,
        name: 'home',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Home',
          subtitle: 'Replace with real HomeScreen',
          icon: Icons.home_outlined,
        ),
      ),
      GoRoute(
        path: loginRoute,
        name: 'login',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Login',
          subtitle: 'Replace with real LoginScreen',
          icon: Icons.lock_outline,
        ),
      ),
    ],
  );
}


class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
