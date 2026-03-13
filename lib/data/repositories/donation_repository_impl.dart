// file: lib/data/repositories/donation_repository_impl.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/donation.dart';
import '../../domain/repositories/donation_repository.dart';
import '../models/donation_model.dart';

class DonationRepositoryImpl implements DonationRepository {
  final FirebaseFirestore _firestore;

  DonationRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('donations');

  @override
  Future<void> createDonation(Donation donation) async {
    try {
      final model = DonationModel(
        id: donation.id,
        description: donation.description,
        quantity: donation.quantity,
        unit: donation.unit,
        category: donation.category,
        location: donation.location,
        createdAt: donation.createdAt,
        createdByUserId: donation.createdByUserId,
        createdByEmail: donation.createdByEmail,
      );

      await _collection.doc(donation.id).set(model.toMap());

      if (kDebugMode) {
        print('[DonationRepositoryImpl] Donativo guardado en Firestore: '
            '${donation.description} por ${donation.createdByEmail}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[DonationRepositoryImpl] ERROR al crear donativo: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<Donation>> getRecentDonations() async {
    try {
      final query = await _collection
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final list = query.docs.map((doc) {
        final data = doc.data();
        return DonationModel.fromMap(data, doc.id);
      }).toList();

      if (kDebugMode) {
        print('[DonationRepositoryImpl] Donativos recuperados: ${list.length}');
      }

      return list;
    } catch (e) {
      if (kDebugMode) {
        print('[DonationRepositoryImpl] ERROR al leer donativos: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<Donation>> getDonationsByUser(String userId) async {
    try {
      // Solo filtro por usuario en Firestore
      final query = await _collection
          .where('createdByUserId', isEqualTo: userId)
          .get();

      final list = query.docs.map((doc) {
        final data = doc.data();
        return DonationModel.fromMap(data, doc.id);
      }).toList();

      // Ordeno en memoria por fecha descendente
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (kDebugMode) {
        print(
            '[DonationRepositoryImpl] Donativos del usuario $userId: ${list.length}');
      }

      return list;
    } catch (e) {
      if (kDebugMode) {
        print('[DonationRepositoryImpl] ERROR getDonationsByUser: $e');
      }
      rethrow;
    }
  }
}