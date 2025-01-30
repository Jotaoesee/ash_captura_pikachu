import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra el contador de Pikachus capturados por Ash.
class ContadorAshOverlay extends StatelessWidget {
  final AshCapturaPikachu
      juego; // Referencia al juego para obtener datos en tiempo real.

  const ContadorAshOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:
          20, // Ubica el contador en la parte superior izquierda de la pantalla.
      left: 20,
      child: ValueListenableBuilder<int>(
        valueListenable:
            juego.pikachusAsh, // Escucha cambios en el contador de Ash.
        builder: (context, valor, child) {
          return Row(
            children: [
              // Muestra el icono de Pikachu junto al contador.
              Image.asset(
                'assets/images/pikachulogo.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(
                  width: 10), // Espaciado entre la imagen y el texto.
              // Muestra la cantidad de Pikachus capturados por Ash.
              Text(
                valor.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
