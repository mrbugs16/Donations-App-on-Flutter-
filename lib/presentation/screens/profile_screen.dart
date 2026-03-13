// file: lib/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/user_donations_viewmodel.dart';
import '../../core/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _initialized = false;

  Future<void> _logout(BuildContext context) async {
    final vm = context.read<AuthViewModel>();
    await vm.signOut();

    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final authVm = context.read<AuthViewModel>();
      final user = authVm.user;
      if (user != null) {
        context.read<UserDonationsViewModel>().loadForUser(user.id);
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;

    final donationsVm = context.watch<UserDonationsViewModel>();

    final total = donationsVm.donations.length;
    final thisMonth = donationsVm.donations.where((d) {
      final now = DateTime.now();
      return d.createdAt.year == now.year &&
          d.createdAt.month == now.month;
    }).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfil del voluntario',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              Text('Correo: ${user.email}'),
              const SizedBox(height: 4),
              Text('ID de usuario: ${user.id}'),
            ] else
              const Text('No hay usuario autenticado.'),

            const SizedBox(height: 24),

            Text(
              'Tus donativos registrados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            if (donationsVm.status == UserDonationsStatus.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: LinearProgressIndicator(),
              )
            else if (donationsVm.status == UserDonationsStatus.error)
              Text(
                donationsVm.errorMessage ??
                    'Error al cargar tus donativos.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            else ...[
                Text('Total registrados: $total'),
                Text('Este mes: $thisMonth'),
              ],

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}