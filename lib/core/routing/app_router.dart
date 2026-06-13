import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/savings/presentation/screens/create_deposit_screen.dart';
import '../../features/goals/presentation/screens/create_goal_screen.dart';

import 'dart:async';
import '../../features/authentication/presentation/bloc/authentication_bloc.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthenticationBloc authBloc) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup' ||
            state.matchedLocation == '/';

        if (authState is AuthenticationUnauthenticated) {
          // If not logged in and not heading to a public route, redirect to login
          if (!isLoggingIn) return '/login';
        } else if (authState is AuthenticationAuthenticated) {
          // If logged in and heading to a public route, redirect to dashboard
          if (isLoggingIn) return '/dashboard';
        }

        // Return null for no redirect
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/create-deposit',
          builder: (context, state) => const CreateDepositScreen(),
        ),
        GoRoute(
          path: '/create-goal',
          builder: (context, state) => const CreateGoalScreen(),
        ),
      ],
    );
  }
}

// Temporary placeholder for features not yet built
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Building $title...')),
    );
  }
}
