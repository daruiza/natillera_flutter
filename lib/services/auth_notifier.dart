import 'package:flutter/material.dart';
import 'package:natillera_flutter/models/user.dart';
import 'package:natillera_flutter/services/google_auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true; // Para mostrar carga inicial o durante el login
  User? _user;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  User? get user => _user;

  AuthNotifier() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    final user = await _googleAuthService.signInSilently();
    if (user != null) {
      _isLoggedIn = true;
      _user = user;
    }
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    final user = await _googleAuthService.signIn();
    if (user != null) {
      _isLoggedIn = true;
      _user = user;
    }
    _setLoading(false);
  }

  void login(User user) {
    _isLoggedIn = true;
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    await _googleAuthService.signOut();
    _isLoggedIn = false;
    _user = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();
