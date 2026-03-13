// file: lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/donations_overview_viewmodel.dart';
import '../widgets/dashboard_stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authVm = context.read<AuthViewModel>();
    await authVm.signOut();

    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _openDonationForm(BuildContext context) async {
    // Abrir formulario
    await Navigator.pushNamed(context, AppRoutes.donationForm);

    // Al regresar, recargamos la lista
    if (!context.mounted) return;
    context.read<DonationsOverviewViewModel>().loadDonations();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de voluntario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Encabezado --------
              Text(
                'Hola, ${authVm.user?.name ?? 'voluntario'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Gracias por apoyar en la gestión de donativos ante desastres.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // -------- Dashboard rápido --------
              Consumer<DonationsOverviewViewModel>(
                builder: (context, vm, _) {
                  final total = vm.donations.length;

                  return Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Donativos\nregistrados',
                          value: '$total',
                          icon: Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Hoy',
                          value: vm.donations
                              .where((d) =>
                          DateTime.now()
                              .difference(d.createdAt)
                              .inDays ==
                              0)
                              .length
                              .toString(),
                          icon: Icons.today_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // -------- Acciones rápidas --------
              Text(
                'Acciones rápidas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openDonationForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar donativo manual'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // futuro: lector de QR, tracking de entregas, etc.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Funcionalidad de QR en desarrollo para la siguiente fase.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Registrar por QR'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // -------- Lista de últimos donativos --------
              Text(
                'Últimos donativos registrados',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Consumer<DonationsOverviewViewModel>(
                builder: (context, vm, _) {
                  if (vm.status == DonationsOverviewStatus.loading &&
                      vm.donations.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (vm.status == DonationsOverviewStatus.error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        vm.errorMessage ?? 'Error al cargar donativos.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  if (vm.donations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Aún no hay donativos registrados.'),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.donations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final d = vm.donations[index];
                      return ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(d.description),
                        subtitle: Text(
                          '${d.quantity} ${d.unit} • ${d.category}\n${d.location}',
                        ),
                        isThreeLine: true,
                        dense: true,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}