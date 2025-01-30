import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

class ContadorAshOverlay extends StatelessWidget {
  final AshCapturaPikachu juego;

  const ContadorAshOverlay({Key? key, required this.juego}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: ValueListenableBuilder<int>(
        valueListenable: juego.pikachusAsh,
        builder: (context, valor, child) {
          return Row(
            children: [
              Image.asset(
                'assets/images/pikachulogo.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
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
