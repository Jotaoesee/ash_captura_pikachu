import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

class ResultadosOverlay extends StatelessWidget {
  final AshCapturaPikachu juego;

  const ResultadosOverlay({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                juego.reiniciarJuego(); // 🔄 Reinicia el juego
              },
              child: const Text('Reiniciar Juego'),
            ),
          ],
        ),
      ),
    );
  }
}
