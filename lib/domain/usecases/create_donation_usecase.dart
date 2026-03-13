// file: lib/domain/usecases/create_donation_usecase.dart
import '../entities/donation.dart';
import '../repositories/donation_repository.dart';

class CreateDonationUseCase {
  final DonationRepository donationRepository;

  CreateDonationUseCase({required this.donationRepository});

  Future<void> call(Donation donation) {
    return donationRepository.createDonation(donation);
  }
}