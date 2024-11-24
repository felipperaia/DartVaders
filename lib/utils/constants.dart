// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppColors {
  // Cores principais da paleta
  static const Color background = Color(0xFF373737); // Fundo de toda página (exceto login e logo)
  static const Color white = Color(0xFFFFFFFF);       // Detalhes brancos
  static const Color accent = Color(0xFF4CAF50);      // Exemplo de cor de destaque para botões ou ícones
  static const Color inputFieldBackground = Color(0xFF373737); // Fundo das entradas de dados (login, senha, email...)

  // Cores para uso específico de telas (caso precise)
  static const Color loginBackground = Color(0xFFFFFFFF); // Fundo branco na tela de login
  static const Color logoBackground = Color(0xFFFFFFFF);  // Fundo branco na tela de logo
}

class AppStrings {
  // Títulos e mensagens
  static const String appName = "Manager Auto";
  static const String loginTitle = "Entrar";
  static const String registerTitle = "Cadastrar";
  static const String forgotPassword = "Esqueceu sua senha?";
  static const String profileTitle = "Meu Perfil";
  static const String addVehicleTitle = "Adicionar Veículo";
  static const String myVehiclesTitle = "Meus Veículos";
  static const String editProfile = "Editar Meus Dados";
  static const String logout = "Sair da Conta";

  // Mensagens de erro e validação
  static const String emailError = "Por favor, insira um email válido.";
  static const String passwordError = "A senha deve ter pelo menos 6 caracteres.";
}

class AppStyles {
  // Estilos de textos para uso no aplicativo
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
