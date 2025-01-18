import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flame/components.dart';


class Pikachu extends SpriteAnimationComponent with HasGameReference<AshCapturaPikachu>{

  Pikachu({required super.position,}):super(size: Vector2(50, 50), anchor: Anchor.topCenter);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('PIKACHU.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(64),
        stepTime: 0.15,
      ),
    );

  }

}