// file: lib/di/providers.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// DATA
import '../data/repositories/auth_repository_impl.dart' as auth_data;
import '../data/repositories/donation_repository_impl.dart' as donation_data;

// DOMAIN
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/donation_repository.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/create_donation_usecase.dart';
import '../domain/usecases/get_recent_donations_usecase.dart';

// VIEWMODELS
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/donation_form_viewmodel.dart';
import '../presentation/viewmodels/donations_overview_viewmodel.dart';
import '../domain/usecases/get_user_donations_usecase.dart';
import '../presentation/viewmodels/user_donations_viewmodel.dart';
import '../presentation/viewmodels/qr_donation_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // -------- AUTH ----------
        Provider<AuthRepository>(
          create: (_) => auth_data.AuthRepositoryImpl(),
        ),
        ProxyProvider<AuthRepository, SignInUseCase>(
          update: (_, authRepo, __) =>
              SignInUseCase(authRepository: authRepo),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            signInUseCase:
            Provider.of<SignInUseCase>(context, listen: false),
          ),
        ),

        // -------- DONATIONS ----------
        Provider<DonationRepository>(
          create: (_) => donation_data.DonationRepositoryImpl(),
        ),
        ProxyProvider<DonationRepository, CreateDonationUseCase>(
          update: (_, donationRepo, __) =>
              CreateDonationUseCase(donationRepository: donationRepo),
        ),
        ProxyProvider<DonationRepository, GetRecentDonationsUseCase>(
          update: (_, donationRepo, __) =>
              GetRecentDonationsUseCase(donationRepository: donationRepo),
        ),
        ProxyProvider<DonationRepository, GetUserDonationsUseCase>(
          update: (_, donationRepo, __) =>
              GetUserDonationsUseCase(donationRepository: donationRepo),
        ),
        ChangeNotifierProvider<QrDonationViewModel>(
          create: (context) => QrDonationViewModel(
            createDonationUseCase:
            Provider.of<CreateDonationUseCase>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<DonationFormViewModel>(
          create: (context) => DonationFormViewModel(
            createDonationUseCase:
            Provider.of<CreateDonationUseCase>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<DonationsOverviewViewModel>(
          create: (context) => DonationsOverviewViewModel(
            getRecentDonationsUseCase:
            Provider.of<GetRecentDonationsUseCase>(context, listen: false),
          )..loadDonations(),
        ),
        ChangeNotifierProvider<UserDonationsViewModel>(
          create: (context) => UserDonationsViewModel(
            getUserDonationsUseCase:
            Provider.of<GetUserDonationsUseCase>(context, listen: false),
          ),
        ),
      ],
      child: child,
    );
  }
}