import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart'; // Importando ProfileScreen
import '../screens/services_screen.dart'; // Importando ServicesScreen
import '../screens/product_details_screen.dart';
import '../screens/register_screen.dart';
import '../screens/add_product_screen.dart';

class AppRoutes {
  // Definição das rotas
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile'; // Tela de perfil
  static const String services = '/services'; // Tela de serviços
  static const String productDetails = '/productDetails'; // Detalhes do produto
  static const String registration = '/registration'; // Tela de registro de usuário
  static const String addProduct = '/addProduct'; // Rota para adicionar produto

  // Método que retorna todas as rotas do app
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      home: (context) => HomeScreen(), // Tela de Home
      profile: (context) => ProfileScreen(), // Tela de perfil
      services: (context) => ServicesScreen(), // Tela de serviços
      productDetails: (context) {
        final vehiclePlate = ModalRoute.of(context)?.settings.arguments as String?;
        return ProductDetailsScreen(plate: vehiclePlate ?? ''); // Detalhes do produto
      },
      registration: (context) => RegisterScreen(),
      addProduct: (context) => AddProductScreen(), // Tela para adicionar produto
    };
  }
}

