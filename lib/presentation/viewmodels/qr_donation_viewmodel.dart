// file: lib/presentation/viewmodels/qr_donation_viewmodel.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/donation.dart';
import '../../domain/usecases/create_donation_usecase.dart';

enum QrDonationStatus {
  idle,
  processing,
  success,
  error,
}

class QrDonationViewModel extends ChangeNotifier {
  final CreateDonationUseCase createDonationUseCase;
  final _uuid = const Uuid();

  QrDonationStatus _status = QrDonationStatus.idle;
  QrDonationStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  QrDonationViewModel({required this.createDonationUseCase});

  Future<Donation?> processQrData({
    required String rawValue,
    required String userId,
    required String userEmail,
  }) async {
    _status = QrDonationStatus.processing;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1) Parsear JSON
      final map = json.decode(rawValue);
      if (map is! Map<String, dynamic>) {
        throw Exception('Formato de QR inválido.');
      }

      // 2) Validar type
      final type = map['type'];
      if (type != 'donation_qr_v1') {
        throw Exception('Tipo de QR no soportado.');
      }

      // 3) Tomar campos
      final description = map['description'] as String? ?? '';
      final quantityNum = map['quantity'];
      final unit = map['unit'] as String? ?? '';
      final category = map['category'] as String? ?? 'Otros';
      final location = map['location'] as String? ?? '';

      if (description.isEmpty ||
          quantityNum == null ||
          unit.isEmpty ||
          location.isEmpty) {
        throw Exception('El QR no contiene todos los campos requeridos.');
      }

      final quantity = (quantityNum as num).toInt();

      // 4) Construir Donation
      final donation = Donation(
        id: _uuid.v4(),
        description: description,
        quantity: quantity,
        unit: unit,
        category: category,
        location: location,
        createdAt: DateTime.now(),
        createdByUserId: userId,
        createdByEmail: userEmail,
      );

      // 5) Guardar en Firestore
      await createDonationUseCase(donation);

      _status = QrDonationStatus.success;
      notifyListeners();
      return donation;
    } catch (e) {
      _status = QrDonationStatus.error;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('[QrDonationViewModel] Error al procesar QR: $e');
      }
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _status = QrDonationStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}