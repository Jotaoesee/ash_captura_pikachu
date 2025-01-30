import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

class ContadorTiempoOverlay extends StatelessWidget {
  final AshCapturaPikachu juego;

  const ContadorTiempoOverlay({Key? key, required this.juego})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 140,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/pokeboll.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 7,
              child: Text(
                juego.tiempoRestante.toInt().toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                      color: Colors.white,
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
