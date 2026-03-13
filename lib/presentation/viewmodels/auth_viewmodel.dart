// file: lib/presentation/viewmodels/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_usecase.dart';

enum AuthStatus {
  idle,
  loading,
  authenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  AuthViewModel({required this.signInUseCase});

  AuthStatus _status = AuthStatus.idle;
  AuthStatus get status => _status;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signOut() async {
    await signInUseCase.authRepository.signOut();
    _user = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await signInUseCase(
        email: email,
        password: password,
      );
      _user = result;
      _status = AuthStatus.authenticated;
    } on fb.FirebaseAuthException catch (e) {
      _status = AuthStatus.error;

      if (e.code == 'user-not-found') {
        _errorMessage = 'No existe una cuenta con ese correo.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Contraseña incorrecta.';
      } else if (e.code == 'operation-not-allowed') {
        _errorMessage =
        'El método Email/Password no está habilitado en Firebase.';
      } else if (e.code == 'network-request-failed') {
        _errorMessage =
        'No se pudo conectar con Firebase. Revisa tu conexión a internet.';
      } else {
        _errorMessage =
        'No se pudo iniciar sesión (${e.code}). Intenta de nuevo.';
      }

      if (kDebugMode) {
        print('FirebaseAuthException: ${e.code} - ${e.message}');
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage =
      'Error al conectar con el servidor. Intenta nuevamente más tarde.';
      if (kDebugMode) {
        print('Error en signIn (otro): $e');
      }
    }

    notifyListeners();
  }

  void reset() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}