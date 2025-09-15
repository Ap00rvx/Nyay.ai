import 'package:flutter/material.dart';
import 'package:nyay/core/router/app_router.dart';
import 'package:nyay/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nyay.ai',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouter.instance.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Removed the template counter page; routing now handled by GoRouter with placeholders.
