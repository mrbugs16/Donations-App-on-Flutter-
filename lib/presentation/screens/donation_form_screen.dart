// file: lib/presentation/screens/donation_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/donation_form_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/primary_button.dart';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _descriptionCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _unitCtrl = TextEditingController(text: 'piezas');
  final _locationCtrl = TextEditingController();

  String _selectedCategory = 'Alimentos';

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _quantityCtrl.dispose();
    _unitCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    final formVm = context.read<DonationFormViewModel>();
    final authVm = context.read<AuthViewModel>();

    final user = authVm.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay usuario autenticado. Vuelve a iniciar sesión.'),
        ),
      );
      return;
    }

    final desc = _descriptionCtrl.text.trim();
    final qtyStr = _quantityCtrl.text.trim();
    final unit = _unitCtrl.text.trim();
    final location = _locationCtrl.text.trim();

    if (desc.isEmpty || qtyStr.isEmpty || unit.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos.'),
        ),
      );
      return;
    }

    final qty = int.tryParse(qtyStr);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La cantidad debe ser un número entero positivo.'),
        ),
      );
      return;
    }

    await formVm.submitDonation(
      description: desc,
      quantity: qty,
      unit: unit,
      category: _selectedCategory,
      location: location,
      createdByUserId: user.id,
      createdByEmail: user.email,
    );

    if (!mounted) return;

    if (formVm.status == DonationFormStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donativo registrado correctamente.'),
        ),
      );
      Navigator.pop(context); // Regresar al Home
    } else if (formVm.status == DonationFormStatus.error &&
        formVm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(formVm.errorMessage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DonationFormViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar donativo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción del donativo',
                  hintText: 'Ej. Agua embotellada 1L',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _unitCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Unidad',
                        hintText: 'piezas, cajas, kilos...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Alimentos',
                    child: Text('Alimentos'),
                  ),
                  DropdownMenuItem(
                    value: 'Higiene',
                    child: Text('Higiene'),
                  ),
                  DropdownMenuItem(
                    value: 'Ropa',
                    child: Text('Ropa'),
                  ),
                  DropdownMenuItem(
                    value: 'Medicinas',
                    child: Text('Medicinas'),
                  ),
                  DropdownMenuItem(
                    value: 'Otros',
                    child: Text('Otros'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ubicación / almacén',
                  hintText: 'Ej. Almacén central CDMX',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Guardar donativo',
                isLoading: vm.status == DonationFormStatus.submitting,
                onPressed: vm.status == DonationFormStatus.submitting
                    ? null
                    : () => _onSubmit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}