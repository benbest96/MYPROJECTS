class Vehicle {
  final String type; // 'Moto' ou 'Car'
  final String driverName;
  final String registration;
  final DateTime purchaseDate;
  final DateTime startDate;
  final DateTime endDate;

  Vehicle({
    required this.type,
    required this.driverName,
    required this.registration,
    required this.purchaseDate,
    required this.startDate,
    required this.endDate,
  });

  // Délai calculé automatiquement en jours
  int get delay => endDate.difference(startDate).inDays;
}
