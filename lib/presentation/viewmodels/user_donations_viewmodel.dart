// file: lib/presentation/viewmodels/user_donations_viewmodel.dart
import 'package:flutter/foundation.dart';

import '../../domain/entities/donation.dart';
import '../../domain/usecases/get_user_donations_usecase.dart';

enum UserDonationsStatus {
  idle,
  loading,
  loaded,
  error,
}

class UserDonationsViewModel extends ChangeNotifier {
  final GetUserDonationsUseCase getUserDonationsUseCase;

  UserDonationsViewModel({required this.getUserDonationsUseCase});

  UserDonationsStatus _status = UserDonationsStatus.idle;
  UserDonationsStatus get status => _status;

  List<Donation> _donations = [];
  List<Donation> get donations => _donations;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadForUser(String userId) async {
    _status = UserDonationsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getUserDonationsUseCase(userId);
      _donations = result;
      _status = UserDonationsStatus.loaded;
    } catch (e) {
      _status = UserDonationsStatus.error;
      _errorMessage = 'No se pudieron cargar tus donativos.';
      if (kDebugMode) {
        print('[UserDonationsViewModel] Error: $e');
      }
    }

    notifyListeners();
  }
}