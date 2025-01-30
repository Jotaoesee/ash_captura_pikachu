import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

class MenuInicioOverlay extends StatelessWidget {
  final AshCapturaPikachu juego;

  const MenuInicioOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            juego.overlays.remove('MenuInicio');
            juego.iniciarJuego();
          },
          child: const Text('Iniciar Juego'),
        ),
      ),
    );
  }
}
