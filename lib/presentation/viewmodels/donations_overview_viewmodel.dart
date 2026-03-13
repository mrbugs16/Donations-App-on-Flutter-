// file: lib/presentation/viewmodels/donations_overview_viewmodel.dart
import 'package:flutter/foundation.dart';

import '../../domain/entities/donation.dart';
import '../../domain/usecases/get_recent_donations_usecase.dart';

enum DonationsOverviewStatus {
  idle,
  loading,
  loaded,
  error,
}

class DonationsOverviewViewModel extends ChangeNotifier {
  final GetRecentDonationsUseCase getRecentDonationsUseCase;

  DonationsOverviewViewModel({
    required this.getRecentDonationsUseCase,
  });

  DonationsOverviewStatus _status = DonationsOverviewStatus.idle;
  DonationsOverviewStatus get status => _status;

  List<Donation> _donations = [];
  List<Donation> get donations => _donations;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadDonations() async {
    _status = DonationsOverviewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getRecentDonationsUseCase();
      _donations = result;
      _status = DonationsOverviewStatus.loaded;
    } catch (e) {
      _status = DonationsOverviewStatus.error;
      _errorMessage = 'No se pudieron cargar los donativos.';
      if (kDebugMode) {
        print('[DonationsOverviewViewModel] Error: $e');
      }
    }

    notifyListeners();
  }
}