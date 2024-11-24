// lib/models/vehicle.dart

class Vehicle {
  final int id;
  final String make; // Marca do veículo, ex: "Ford"
  final String model; // Modelo do veículo, ex: "Focus"
  final int year; // Ano do veículo, ex: 2022
  final String type; // Tipo do veículo, ex: "Carro", "Moto", etc.
  final String color; // Cor do veículo, ex: "Vermelho"
  final String plate; // Placa do veículo
  final String status; // Status do veículo, ex: "Ativo", "Inativo", "Em manutenção"
  final DateTime registrationDate; // Data de registro do veículo no sistema

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.type,
    required this.color,
    required this.plate,
    required this.status,
    required this.registrationDate,
  });

  // Método para criar um objeto Vehicle a partir de um JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      type: json['type'] as String,
      color: json['color'] as String,
      plate: json['plate'] as String,
      status: json['status'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
    );
  }

  // Método para converter um objeto Vehicle em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'type': type,
      'color': color,
      'plate': plate,
      'status': status,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
}
