import 'package:ash_captura_pikachu/personajes/pikachu.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../personajes/ash_player.dart';

class AshCapturaPikachu extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  // Instancia del jugador (Ash)
  late AshPlayer _ashPlayer;
  late Pikachu _pikachu;

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // Cargar el supercomponente de FlameGame

    // Cargar todas las imágenes necesarias para el juego
    await images.loadAll([
      'AshAndando.png',// Cargar la imagen de la animación de caminar
      'Summer6.png',// Cargar el fondo
      'PIKACHU.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;

    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'), // Cargar la imagen
      ],
      baseVelocity: Vector2.zero(), // Fondo estático (sin movimiento)
      size: size, // Tamaño del fondo
    );

    add(fondo); // Agregar el fond
    try {
      // Cargar el mapa desde el archivo .tmx (mapa del juego)
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",  // Archivo de mapa
        Vector2(48, 48), // Tamaño de los tiles en el mapa (ancho y alto)
      );

      // Ajustar la escala del mapa (reduce el tamaño global del mapa)
      mapa.scale = Vector2(1.34, 1);  // Ajuste de escala global del mapa

      // Añadir el mapa al juego
      add(mapa);

      final objectGroupPikachu = mapa.tileMap.getLayer<ObjectGroup>('pikachu');

      for (final posPikachuEnMapa in objectGroupPikachu!.objects) {

        add(Pikachu(position: Vector2(posPikachuEnMapa.x * 1.34, posPikachuEnMapa.y * 1)));
      }

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
