import 'package:google_sign_in/google_sign_in.dart';
import 'package:natillera_flutter/models/user.dart';
import 'package:http/http.dart' as http;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Inicia sesión con Google y retorna un objeto User si es exitoso
  Future<User?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // 2. Obtener los tokens de la autenticación
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        if (googleAuth.idToken != null) {
          // 3. Enviar el token al backend para validación y obtener un token de acceso
          final accessToken = await getAccessToken(googleAuth.idToken!);
          if (accessToken != null) {
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
    }
    return null;
  }

  // Solicitud token de acceso a backend
  Future<String?> getAccessToken(String idToken) async {
    // 4. Enviar al backend
    final response = await http.post(
      Uri.parse('https://tu-api.com/auth/google'),
      body: {'token': idToken},
    );

    if (response.statusCode == 200) {
      // Suponiendo que el backend devuelve el token de acceso en el cuerpo de la respuesta
      return response.body;
    } else {
      print('Error al obtener token de acceso: ${response.statusCode}');
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
