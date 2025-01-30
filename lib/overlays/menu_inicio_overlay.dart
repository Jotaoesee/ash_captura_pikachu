import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra el menú de inicio del juego.
class MenuInicioOverlay extends StatelessWidget {
  final AshCapturaPikachu juego; // Referencia al juego

  const MenuInicioOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Fondo semi-transparente
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Sombra para efecto 3D
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            juego.overlays.remove('MenuInicio'); // Oculta el menú de inicio
            juego.iniciarJuego(); // Inicia la partida
          },
          child: const Text('Iniciar Juego'),
        ),
      ),
    );
  }
}
