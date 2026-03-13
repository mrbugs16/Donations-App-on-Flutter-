// file: lib/presentation/screens/qr_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/qr_donation_viewmodel.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool _isHandlingCode = false;

  Future<void> _onDetect(
      BuildContext context,
      BarcodeCapture capture,
      ) async {
    if (_isHandlingCode) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final value = barcodes.first.rawValue;
    if (value == null) return;

    _isHandlingCode = true;

    final authVm = context.read<AuthViewModel>();
    final user = authVm.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay usuario autenticado. Vuelve a iniciar sesión.'),
        ),
      );
      _isHandlingCode = false;
      return;
    }

    final qrVm = context.read<QrDonationViewModel>();

    // Mostrar diálogo de pre-confirmación con el texto crudo (opcional)
    final shouldProcess = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR detectado'),
        content: Text(
          '¿Deseas registrar este donativo a partir del QR?\n\n'
              'Contenido:\n$value',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Registrar'),
          ),
        ],
      ),
    ) ??
        false;

    if (!shouldProcess) {
      _isHandlingCode = false;
      return;
    }

    // Procesar QR y registrar donativo
    final donation = await qrVm.processQrData(
      rawValue: value,
      userId: user.id,
      userEmail: user.email,
    );

    if (!mounted) return;

    if (donation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Donativo registrado: ${donation.description}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            qrVm.errorMessage ?? 'No se pudo registrar el donativo.',
          ),
        ),
      );
    }

    // Pequeño delay para no disparar múltiples veces
    await Future.delayed(const Duration(seconds: 2));
    _isHandlingCode = false;
  }

  @override
  Widget build(BuildContext context) {
    final qrVm = context.watch<QrDonationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR de donativo'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  onDetect: (capture) => _onDetect(context, capture),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Instrucciones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Acerca el código QR del donativo al recuadro.\n'
                        '2. Revisa el contenido detectado.\n'
                        '3. Confirma para registrar el donativo en la base de datos.',
                  ),
                  const SizedBox(height: 12),
                  if (qrVm.status == QrDonationStatus.processing)
                    const LinearProgressIndicator(),
                  if (qrVm.status == QrDonationStatus.error &&
                      qrVm.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      qrVm.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}