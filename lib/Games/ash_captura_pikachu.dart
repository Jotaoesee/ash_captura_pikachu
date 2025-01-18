import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Characters/ash_player.dart';

class AshCapturaPikachu extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  // Instancia del jugador (Ash)
  late AshPlayer _ashPlayer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // Cargar el supercomponente de FlameGame

    // Cargar todas las imágenes necesarias para el juego
    await images.loadAll([
      'AshAndando.png', // Cargar la imagen de la animación de caminar
    ]);

    try {
      // Cargar el mapa desde el archivo .tmx (mapa del juego)
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",  // Archivo de mapa
        Vector2(48, 48), // Tamaño de los tiles en el mapa (ancho y alto)
      );

      // Ajustar la escala del mapa (reduce el tamaño global del mapa)
      mapa.scale = Vector2.all(1);  // Ajuste de escala global del mapa

      // Añadir el mapa al juego
      add(mapa);

      // Crear la instancia del jugador (Ash) y establecer su posición inicial
      _ashPlayer = AshPlayer(
        position: Vector2(40, 655), // Posición de Ash en el mapa (x, y)
      );

      // Añadir el jugador al juego
      add(_ashPlayer);

    } catch (e) {
      // En caso de error al cargar el mapa, imprimir el error
      print('Error cargando el mapa: $e');
    }
  }
}
