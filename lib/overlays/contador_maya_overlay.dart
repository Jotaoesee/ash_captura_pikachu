import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';

class ContadorMayaOverlay extends StatelessWidget {
  final AshCapturaPikachu juego;

  const ContadorMayaOverlay({Key? key, required this.juego}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: ValueListenableBuilder<int>(
        valueListenable: juego.pikachusMaya,
        builder: (context, valor, child) {
          return Row(
            children: [
              Text(
                valor.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
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
