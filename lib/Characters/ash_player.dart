import 'dart:ui';

import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flame/components.dart';

class AshPlayer extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, KeyboardHandler {
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
    x = x + 2;
  }
}
