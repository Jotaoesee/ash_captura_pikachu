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

    try {
      // Cargar el mapa desde el archivo .tmx
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",
        Vector2(48, 48), // Tamaño de los tiles del mapa
      );

      // Ajustar la escala del mapa (reduce el tamaño global)
      mapa.scale = Vector2.all(1);

      // Añadir el mapa al juego
      add(mapa);

      // Crear y añadir el jugador
      _ashPlayer = AshPlayer(
        position: Vector2(100, 100),
      );
      add(_ashPlayer);
    } catch (e) {
      print('Error cargando el mapa: $e');
    }
  }
}
