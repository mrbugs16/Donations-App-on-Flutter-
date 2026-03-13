// file: lib/domain/usecases/sign_in_usecase.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<User> call({
    required String email,
    required String password,
  }) {
    return authRepository.signInWithEmail(
      email: email,
      password: password,
    );
  }
}