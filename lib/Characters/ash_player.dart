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
    // Detectar movimiento en base a las teclas
    if (event is KeyDownEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyW)) {
        direccion = Vector2(0, -1);  // Mover hacia arriba
      } else if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion = Vector2(-1, 0);  // Mover hacia la izquierda
      } else if (teclasPresionadas.contains(LogicalKeyboardKey.keyS)) {
        direccion = Vector2(0, 1);   // Mover hacia abajo
      } else if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion = Vector2(1, 0);   // Mover hacia la derecha
      } else if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        print('¡Saltando!');
      }
    } else if (event is KeyUpEvent) {
      // Detener el movimiento cuando la tecla se suelta
      if (teclasPresionadas.isEmpty) {
        direccion = Vector2.zero();
      }
    }

    return super.onKeyEvent(event, teclasPresionadas);
  }
}
