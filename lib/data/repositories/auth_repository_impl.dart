// file: lib/data/repositories/auth_repository_impl.dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({fb.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  User? _mapFbUserToDomain(fb.User? fbUser) {
    if (fbUser == null) return null;
    return UserModel(
      id: fbUser.uid,
      name: fbUser.displayName ?? 'Voluntario',
      email: fbUser.email ?? '',
    );
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('[AuthRepositoryImpl] signInWithEmail INICIO: $email');
    }

    try {
      final cred = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print(
            '[AuthRepositoryImpl] signInWithEmail OK, uid: ${cred.user?.uid}');
      }

      final domainUser = _mapFbUserToDomain(cred.user);
      if (domainUser == null) {
        throw Exception('No se pudo obtener el usuario de Firebase');
      }
      return domainUser;
    } on TimeoutException {
      if (kDebugMode) {
        print('[AuthRepositoryImpl] ERROR: Timeout al conectar con Firebase');
      }
      throw Exception('Timeout al conectar con Firebase');
    } on fb.FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(
            '[AuthRepositoryImpl] FirebaseAuthException: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[AuthRepositoryImpl] ERROR genérico: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapFbUserToDomain);
  }
}