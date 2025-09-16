import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/case_intake/view/case_intake_page.dart';
import '../../features/matching/view/matching_page.dart';
import '../../features/tracking/view/tracking_page.dart';
import '../../features/ai_chat/view/ai_chat_page.dart';
import '../../core/domain/entities.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/signup_page.dart';
import '../../features/dashboard/view/dashboard_shell.dart';

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
  static const String caseIntakeRoute = '/intake';
  static const String signupRoute = '/signup';
  static const String dashboardRoute = '/dashboard';

  final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splashRoute,
    routes: <RouteBase>[
      GoRoute(
        path: splashRoute,
        name: 'splash',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: caseIntakeRoute,
        name: 'intake',
        builder: (context, state) => const CaseIntakePage(),
      ),
      GoRoute(
        path: loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signupRoute,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: homeRoute,
        name: 'home',
        builder: (context, state) {
          final data = state.extra;
          if (data is! ClientCase) {
            return const CaseIntakePage();
          }
          return MatchingPage(clientCase: data);
        },
      ),
      GoRoute(
        path: TrackingPage.routePath,
        name: 'track',
        builder: (context, state) {
          final data = state.extra;
          if (data is! ClientCase) return const CaseIntakePage();
          return TrackingPage(clientCase: data);
        },
      ),
      GoRoute(
        path: '/ai',
        name: 'ai',
        builder: (context, state) => const AiChatPage(),
      ),
      GoRoute(
        path: DashboardShell.routePath,
        name: 'dashboard',
        builder: (context, state) => const DashboardShell(),
      ),
    ],
  );
}

// Placeholder page removed; real pages wired.
