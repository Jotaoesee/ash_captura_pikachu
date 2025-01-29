import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColisionesRectangular extends PositionComponent with CollisionCallbacks {
  ColisionesRectangular({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Añadir un RectangleHitbox con el mismo tamaño y posición que el componente
    add(RectangleHitbox()
          ..collisionType =
              CollisionType.passive // Cambia a "active" si es necesario
        ); // Visualizar el área de colisión

    debugMode =
        true; // Habilitar para visualizar el área de colisión del componente
  }
}
