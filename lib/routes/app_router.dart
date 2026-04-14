import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:natillera_flutter/screens/home.dart';
import 'package:natillera_flutter/screens/login.dart';
import 'package:natillera_flutter/services/auth_notifier.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      ShellRoute(
        // 'child' es la página que cambia, el resto es el menú fijo
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Mi Menu Fijo")),
            body: child, // Aquí se "inyectan" las páginas hijas
          );
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      ),
    ],
  );
}
