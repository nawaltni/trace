import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:trace/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:trace/src/features/authentication/presentation/pair_device_screen.dart';
import 'package:trace/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:trace/src/routing/go_router_refresh_stream.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  // @initial
  signIn,
  pairDevice,
  dashboard
  // signUp,
  // pairDevice,
  // dashboard,
  // currentLocation,
  // history,
  // settings,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  // final onboardingRepository =
  //     ref.watch(onboardingRepositoryProvider).requireValue;
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print("Redirect triggering");
      final isLoggedIn = authRepository.currentUser != null;
      print("isLoggedIn: $isLoggedIn");
      if (!isLoggedIn) {
        return '/signIn';
      }

      return '/dashboard';

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/pairDevice',
        name: AppRoute.pairDevice.name,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: PairDeviceScreen()),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DashboardScreen()),
      ),
    ],
  );
}
