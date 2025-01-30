import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra los resultados del juego después de que el tiempo ha finalizado.
class ResultadosOverlay extends StatelessWidget {
  final AshCapturaPikachu juego; // Referencia al juego actual

  const ResultadosOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    // Determina el mensaje a mostrar según quién haya capturado más Pikachus
    String mensaje;
    if (juego.pikachusAsh.value > juego.pikachusMaya.value) {
      mensaje = "🏆 ¡Ash gana con ${juego.pikachusAsh.value} Pikachus!";
    } else if (juego.pikachusMaya.value > juego.pikachusAsh.value) {
      mensaje = "🏆 ¡Maya gana con ${juego.pikachusMaya.value} Pikachus!";
    } else {
      mensaje =
          "🤝 ¡Empate! Ambos capturaron ${juego.pikachusAsh.value} Pikachus.";
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Fondo semi-transparente
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4), // Sombra para efecto 3D
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
          children: [
            // Muestra el mensaje con los resultados del juego
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Espaciado entre el texto y el botón

            // Botón para reiniciar el juego
            ElevatedButton(
              onPressed: () {
                juego.reiniciarJuego(); // Reinicia el juego
              },
              child: const Text('Reiniciar Juego'),
            ),
          ],
        ),
      ),
    );
  }
}
