// file: lib/domain/usecases/get_recent_donations_usecase.dart
import '../entities/donation.dart';
import '../repositories/donation_repository.dart';

class GetRecentDonationsUseCase {
  final DonationRepository donationRepository;

  GetRecentDonationsUseCase({required this.donationRepository});

  Future<List<Donation>> call() {
    return donationRepository.getRecentDonations();
  }
}