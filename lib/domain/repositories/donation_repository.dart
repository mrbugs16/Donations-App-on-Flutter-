// file: lib/domain/repositories/donation_repository.dart
import '../entities/donation.dart';

abstract class DonationRepository {
  Future<void> createDonation(Donation donation);

  /// Donativos recientes (todos)
  Future<List<Donation>> getRecentDonations();

  /// Donativos de un usuario específico (para perfil / estadísticas)
  Future<List<Donation>> getDonationsByUser(String userId);
}