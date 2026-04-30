import 'package:google_sign_in/google_sign_in.dart';
import 'package:natillera_flutter/models/user.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Inicia sesión con Google y retorna un objeto User si es exitoso
  Future<User?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //imprime el resultado del login
      print('Google Sign-In result: $googleUser');

      if (googleUser != null) {
        return User(
          name: googleUser.displayName ?? 'Usuario',
          email: googleUser.email,
          pictureUrl: googleUser.photoUrl ?? '',
        );
      }

      // 2. Obtener los tokens de la autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print(
        'Google Sign-In tokens: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}',
      );
    } catch (e) {
      print('Error durante Google Sign-In: $e');
    }
    return null;
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
