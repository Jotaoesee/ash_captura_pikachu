import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class ColisionPlataforma extends PositionComponent with CollisionCallbacks {
  ColisionPlataforma({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      collisionType: CollisionType.passive,
    )..debugMode = true);
  }
}
