import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'utils/app_routes.dart';
import 'utils/constants.dart'; // Importa o arquivo de constantes para usar AppColors, AppStyles e AppStrings

void main() async {
  // Garante que o Flutter esteja inicializado antes de qualquer outra coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Detalhes da configuração do Parse Server
  const keyApplicationId = 'suaaplicationid';
  const keyClientKey = 'suaclientkey';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  // Inicializa o Parse
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  // Executa o aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Desativa o banner de depuração
      title: AppStrings.appName,          // Usa o título do aplicativo da constante AppStrings
      theme: ThemeData(
        // Configuração de cores principais
        primaryColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,

        // Configuração de temas de texto com nomes atualizados
        textTheme: TextTheme(
          titleLarge: AppStyles.titleStyle,       // Título principal
          bodyMedium: AppStyles.inputTextStyle,    // Texto padrão
          labelLarge: AppStyles.buttonTextStyle,   // Texto do botão
        ),

        // Configuração de tema para campos de entrada de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: AppStyles.inputTextStyle,
        ),

        // Configuração de tema para botões elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            textStyle: AppStyles.buttonTextStyle,
          ),
        ),
      ),
      themeMode: ThemeMode.light,  // Define o tema como claro, você pode alterar para ThemeMode.dark se preferir
      initialRoute: AppRoutes.login, // Define a rota inicial como a tela de login
      routes: AppRoutes.getRoutes(), // Define as rotas de navegação
    );
  }
}
