import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra el contador de Pikachus capturados por Maya.
class ContadorMayaOverlay extends StatelessWidget {
  final AshCapturaPikachu
      juego; // Referencia al juego para acceder a los datos.

  const ContadorMayaOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20, // Ubica el contador en la parte superior derecha de la pantalla.
      right: 20,
      child: ValueListenableBuilder<int>(
        valueListenable:
            juego.pikachusMaya, // Escucha cambios en el contador de Maya.
        builder: (context, valor, child) {
          return Row(
            children: [
              // Muestra la cantidad de Pikachus capturados por Maya.
              Text(
                valor.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                  width: 10), // Espaciado entre el texto y la imagen.
              // Muestra el icono de Pikachu junto al contador.
              Image.asset(
                'assets/images/pikachulogo.png',
                width: 40,
                height: 40,
              ),
            ],
          );
        },
      ),
    );
  }
}
