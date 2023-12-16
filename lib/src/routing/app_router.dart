import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:trace/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:trace/src/features/authentication/presentation/pair_device_screen.dart';
import 'package:trace/src/features/current_meta/presentation/current_meta.dart';
import 'package:trace/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:trace/src/features/profile/presentation/profile.dart';
import 'package:trace/src/routing/go_router_refresh_stream.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  // @initial
  signIn,
  pairDevice,
  dashboard,
  currentMeta,
  profile,
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
    initialLocation: '/dashboard',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print("Redirect triggering");

      final isLoggedIn = authRepository.currentUser != null;
      final onLoginPage = state.fullPath == '/signIn';
      final onPairDevicePage = state.fullPath == '/pairDevice';

      print("isLoggedIn: $isLoggedIn");
      if (!isLoggedIn && !onPairDevicePage) {
        return '/signIn';
      }
      if (isLoggedIn && onLoginPage) {
        print("Redirecting to dashboard from login page");
        return '/dashboard';
      }

      if (isLoggedIn && onPairDevicePage) {
        print("Redirecting to dashboard from pair page");

        return '/dashboard';
      }

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
      GoRoute(
        path: '/currentLocation',
        name: AppRoute.currentMeta.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CurrentMetaScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfileScreen(),
        ),
      ),
    ],
  );
}
