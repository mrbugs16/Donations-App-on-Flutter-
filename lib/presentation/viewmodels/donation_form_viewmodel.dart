// file: lib/presentation/viewmodels/donation_form_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/donation.dart';
import '../../domain/usecases/create_donation_usecase.dart';

enum DonationFormStatus {
  idle,
  submitting,
  success,
  error,
}

class DonationFormViewModel extends ChangeNotifier {
  final CreateDonationUseCase createDonationUseCase;
  final _uuid = const Uuid();

  DonationFormStatus _status = DonationFormStatus.idle;
  DonationFormStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DonationFormViewModel({required this.createDonationUseCase});

  Future<void> submitDonation({
    required String description,
    required int quantity,
    required String unit,
    required String category,
    required String location,
    required String createdByUserId,
    required String createdByEmail,
  }) async {
    _status = DonationFormStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final donation = Donation(
        id: _uuid.v4(),
        description: description,
        quantity: quantity,
        unit: unit,
        category: category,
        location: location,
        createdAt: DateTime.now(),
        createdByUserId: createdByUserId,
        createdByEmail: createdByEmail,
      );

      await createDonationUseCase(donation);

      _status = DonationFormStatus.success;
    } catch (e) {
      _status = DonationFormStatus.error;
      _errorMessage = 'No se pudo registrar el donativo. Intenta de nuevo.';
      if (kDebugMode) {
        print('[DonationFormViewModel] Error: $e');
      }
    }

    notifyListeners();
  }

  void reset() {
    _status = DonationFormStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}