import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

import '../Characters/ash_player.dart';

class AshCapturaPikachu extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late AshPlayer _ashPlayer;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'AshAndando.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    /*
    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('fondo1.png'), // Cargar la imagen
      ],
      baseVelocity: Vector2.zero(), // Fondo estático (sin movimiento)
      size: size, // Tamaño del fondo
    );

    add(fondo); // Agregar el fond
   */

    _ashPlayer = AshPlayer(
      position: Vector2(140, canvasSize.y - 62),
    );
    add(_ashPlayer);
  }
}
