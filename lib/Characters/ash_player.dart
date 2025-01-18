import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import '../Games/ash_captura_pikachu.dart';

class AshPlayer extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, KeyboardHandler {

  // Velocidad de movimiento
  double velocidad = 150;

  // Dirección del movimiento
  Vector2 direccion = Vector2.zero();

  AshPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('AshAndando.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(64),
        stepTime: 0.12,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Actualizar la posición del jugador según la dirección
    position += direccion * velocidad * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    // Reiniciar la dirección a cero en cada ciclo de evento
    direccion = Vector2.zero();

    if (event is KeyDownEvent) {
      // Mover hacia arriba
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyW)) {
        direccion.y = -1;
      }

      // Mover hacia abajo
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyS)) {
        direccion.y = 1;
      }

      // Mover hacia la izquierda
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1;
      }

      // Mover hacia la derecha
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1;
      }

      // Hacer salto (aún no implementado)
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        print('¡Saltando!');
      }
    }

    // Normalizar el vector de dirección si es necesario (para movimientos diagonales)
    if (direccion.length > 1) {
      direccion.normalize();
    }

    return super.onKeyEvent(event, teclasPresionadas);
  }
}
