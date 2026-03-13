// file: lib/domain/entities/donation.dart
class Donation {
  final String id;
  final String description;     // p.ej. "Agua embotellada 1L"
  final int quantity;           // p.ej. 24
  final String unit;            // p.ej. "piezas", "cajas"
  final String category;        // p.ej. "Alimentos", "Higiene"
  final String location;        // p.ej. "Almacén central CDMX"
  final DateTime createdAt;

  // Nuevo: trazabilidad
  final String createdByUserId;   // uid de Firebase
  final String createdByEmail;    // correo del voluntario

  const Donation({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.location,
    required this.createdAt,
    required this.createdByUserId,
    required this.createdByEmail,
  });
}