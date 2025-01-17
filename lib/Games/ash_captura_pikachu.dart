import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Characters/ash_player.dart';

class AshCapturaPikachu extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  late AshPlayer _ashPlayer;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'AshAndando.png',
    ]);

    camera.viewfinder.anchor = Anchor.center;

    // Cargar el mapa sin parámetros adicionales como atlasSize
    TiledComponent mapa1 = await TiledComponent.load(
      "mapa1.tmx",
      Vector2(128, 128), // Tamaño base para el mapa,
    );

    mapa1.scale = Vector2(0.50 , 0.25);

    add(mapa1);

    _ashPlayer = AshPlayer(
      position: Vector2(300, 300),
    );

    world.add(_ashPlayer);
  }
}
