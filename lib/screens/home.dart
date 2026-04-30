import 'package:flutter/material.dart';
import 'package:natillera_flutter/services/auth_notifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ListenableBuilder(
          listenable: authNotifier,
          builder: (context, child) {
            if (authNotifier.isLoading) {
              return const CircularProgressIndicator();
            }

            return ElevatedButton.icon(
              onPressed: () async {
                await authNotifier.logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            );
          },
        ),
      ),
    );
  }
}
