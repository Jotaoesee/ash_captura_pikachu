import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra el tiempo restante en la partida.
class ContadorTiempoOverlay extends StatelessWidget {
  final AshCapturaPikachu juego; // Referencia al juego

  const ContadorTiempoOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 140, // Posiciona el contador en la parte inferior de la pantalla
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Imagen de fondo del contador (Pokébola)
            Image.asset(
              'assets/images/pokeboll.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            // Número del tiempo restante
            Positioned(
              top: 7,
              child: Text(
                juego.tiempoRestante
                    .toInt()
                    .toString(), // Convierte el tiempo en entero y lo muestra
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                      color: Colors
                          .white, // Sombra blanca para mejorar la visibilidad
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
