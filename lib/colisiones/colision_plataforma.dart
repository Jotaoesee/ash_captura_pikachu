import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColisionPlataforma extends PositionComponent with CollisionCallbacks {
  ColisionPlataforma({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft) {
    add(RectangleHitbox(
      collisionType:
          CollisionType.passive, // Es pasivo para que Ash interactúe con él
    )..debugMode = true);
  }
}
