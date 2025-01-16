import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
            game:
                AshCapturaPikachu()), // Usamos el GameWidget con nuestro juego
      ),
    ),
  );
}
