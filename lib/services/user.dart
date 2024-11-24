// lib/models/user.dart

class User {
  final int id; // Identificador único do usuário
  final String name; // Nome completo do usuário
  final String email; // Endereço de email do usuário
  final String phoneNumber; // Número de telefone do usuário
  final String role; // Papel do usuário no sistema, ex: "Cliente", "Administrador"
  final String status; // Status da conta do usuário, ex: "Ativo", "Inativo"
  final DateTime createdAt; // Data de criação da conta do usuário
  final DateTime updatedAt; // Data da última atualização da conta

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para criar um objeto User a partir de um JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Método para converter um objeto User em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}