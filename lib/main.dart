import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/savings/presentation/bloc/savings_bloc.dart';
import 'features/goals/presentation/bloc/goals_bloc.dart';
import 'injection_container/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Catching error if not configured yet to allow UI development)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not configured yet: $e');
  }

  await configureDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const LockSaveApp());
}

class LockSaveApp extends StatelessWidget {
  const LockSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthenticationBloc>()..add(AppStarted()),
        ),
        BlocProvider(
          create: (_) => sl<SavingsBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<GoalsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'LockSave',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

