// file: lib/domain/usecases/get_user_donations_usecase.dart
import '../entities/donation.dart';
import '../repositories/donation_repository.dart';

class GetUserDonationsUseCase {
  final DonationRepository donationRepository;

  GetUserDonationsUseCase({required this.donationRepository});

  Future<List<Donation>> call(String userId) {
    return donationRepository.getDonationsByUser(userId);
  }
}