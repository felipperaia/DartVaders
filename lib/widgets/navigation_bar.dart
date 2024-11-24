import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background para dar um espaçamento entre o botão flutuante e a barra
        Container(
          height: 100,
          color: Colors.transparent,
        ),

        // Botão "Home" centralizado com tamanho médio-grande
        Positioned(
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () => onTap(0), // Navega para a Home
            backgroundColor: Colors.white,
            elevation: 6,
            shape: CircleBorder(),
            child: Icon(
              Icons.home,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),

        // Botão "Serviços" no lado esquerdo com tamanho médio
        Positioned(
          left: 50,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () => onTap(1), // Navega para Serviços
            backgroundColor: Colors.white,
            elevation: 6,
            shape: CircleBorder(),
            child: Icon(
              Icons.miscellaneous_services,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),

        // Botão "Perfil" no lado direito com tamanho médio
        Positioned(
          right: 50,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () => onTap(2), // Navega para Perfil
            backgroundColor: Colors.white,
            elevation: 6,
            shape: CircleBorder(),
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
