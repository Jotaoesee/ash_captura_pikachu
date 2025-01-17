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
    await super.onLoad();

    await images.loadAll([
      'AshAndando.png',
    ]);

    camera.viewfinder.anchor = Anchor.center;

    try {
      // Mantenemos el tamaño original de los tiles (32x32)
      TiledComponent mapa=await TiledComponent.load("mapa.tmx", Vector2(48, 48));

      // Usamos una escala de 2.0 para hacer el mapa más visible
      mapa.scale = Vector2.all(0.5);

      world.add(mapa);

      // Ajustamos la posición inicial del jugador según el nuevo tamaño
      _ashPlayer = AshPlayer(
        position: Vector2(50, 350),
      );
      world.add(_ashPlayer);

    } catch (e) {
      print('Error cargando el mapa: $e');
    }
  }
}