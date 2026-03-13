// file: lib/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Stream<User?> authStateChanges();
}