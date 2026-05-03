import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:natillera_flutter/env/env.dart';
import 'package:natillera_flutter/models/user.dart';
import 'package:http/http.dart' as http;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: Env.webIdClient,
    // clientId: Env.idClient,
  );

  String get _backendBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:7001';
    }

    // Android emulator maps the host machine loopback to 10.0.2.2.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:7001';
    }

    return 'http://localhost:7001';
  }

  /// Inicia sesión con Google y retorna un objeto User si es exitoso
  Future<User?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      print('Intentando iniciar sesión con Google... $googleUser');

      if (googleUser != null) {
        // 2. Obtener los tokens de la autenticación
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        print('Google accessToken: ${googleAuth.accessToken}');

        if (googleAuth.idToken != null) {
          // 3. Enviar el token al backend para validación y obtener un token de acceso
          print('ID Token recibido: ${googleAuth.idToken}');
          final accessToken = await getAccessToken(googleAuth.idToken!);
          if (accessToken != null) {
            print('Token de acceso recibido: $accessToken');
            return User(
              name: googleUser.displayName ?? 'Usuario',
              email: googleUser.email,
              pictureUrl: googleUser.photoUrl ?? '',
            );
          }
        }
      }
    } catch (e) {
      print('Error durante Google Sign-In: $e');
      if (e.toString().contains('ApiException: 10')) {
        print(
          'Google Sign-In fallo con DEVELOPER_ERROR (10). '
          'Verifica en Google Cloud Console un cliente OAuth Android con '
          'packageName=${Env.packageName} y la SHA-1 del keystore que usas para debug.',
        );
      }
    }
    return null;
  }

  // Solicitud token de acceso a backend
  Future<String?> getAccessToken(String idToken) async {
    try {
      // 4. Enviar al backend
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/app/v1/auth/google/validate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        // Suponiendo que el backend devuelve el token de acceso en el cuerpo de la respuesta
        return response.body;
      } else {
        print('Error al obtener token de acceso: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de red al validar token con backend: $e');
      print(
        'Si pruebas en Android emulador usa 10.0.2.2; en dispositivo fisico usa la IP LAN de tu PC.',
      );
      return null;
    }
  }

  /// Cierra la sesión activa
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error al cerrar sesión en Google Sign-In: $e');
    }
  }

  /// Verifica si hay un usuario logueado silenciosamente al iniciar la app
  Future<User?> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();

      if (googleUser != null) {
        return User(
          name: googleUser.displayName ?? 'Usuario',
          email: googleUser.email,
          pictureUrl: googleUser.photoUrl ?? '',
        );
      }
    } catch (e) {
      print('Error recuperando sesión silenciosamente: $e');
    }
    return null;
  }
}
