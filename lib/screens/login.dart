import 'package:flutter/material.dart';
import 'package:natillera_flutter/services/auth_notifier.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Natillera'),
        centerTitle: true,
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: authNotifier,
          builder: (context, child) {
            // Estado 1: Cargando (Verificando sesión o logueando)
            if (authNotifier.isLoading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Autenticando..."),
                ],
              );
            }

            // // Estado 2: Logueado (Normalmente aquí habría redirección, pero mostramos info base)
            // if (authNotifier.isLoggedIn) {
            //   return Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       if (authNotifier.user?.pictureUrl != null && authNotifier.user!.pictureUrl.isNotEmpty)
            //         CircleAvatar(
            //           radius: 40,
            //           backgroundImage: NetworkImage(authNotifier.user!.pictureUrl),
            //         ),
            //       const SizedBox(height: 16),
            //       Text(
            //         '¡Hola, ${authNotifier.user?.name}!',
            //         style: Theme.of(context).textTheme.titleLarge,
            //       ),
            //       const SizedBox(height: 24),
            //       ElevatedButton.icon(
            //         onPressed: () => authNotifier.logout(),
            //         icon: const Icon(Icons.logout),
            //         label: const Text('Cerrar Sesión'),
            //       ),
            //     ],
            //   );
            // }

            // Estado 3: Sin loguear (Mostrar botón de Sign In)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                Text(
                  'Bienvenido a tu Natillera',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authNotifier.signInWithGoogle();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Iniciar sesión con Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}