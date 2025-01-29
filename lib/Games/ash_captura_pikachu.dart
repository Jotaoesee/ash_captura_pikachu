import 'dart:io';

import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart';
import 'package:ash_captura_pikachu/personajes/maya.dart';
import 'package:ash_captura_pikachu/personajes/pikachu.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_audio/flame_audio.dart';

import '../personajes/ash.dart';

// Clase principal del juego que hereda de FlameGame
class AshCapturaPikachu extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Ash _ashPlayer; // Jugador Ash
  late Maya _maya; // Jugador Ash

  bool juegoEnCurso = false; // Estado del juego (si está en curso o no)

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Carga los componentes base de Flame

    // Cargar imágenes necesarias para el juego
    await images.loadAll([
      'AshAndando.png',
      'Summer6.png',
      'PIKACHU.png',
      'maya.png',
    ]);

    // Cargar el archivo de audio de música de fondo
    await FlameAudio.audioCache.load('musica_fondo.mp3');

    // Reproducir música de fondo con un volumen del 50%
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);
    print("Reproduciendo música...");

    // Configurar la cámara para que su anclaje esté en la esquina superior izquierda
    camera.viewfinder.anchor = Anchor.topLeft;

    // Cargar y mostrar el fondo parallax
    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'),
      ],
      baseVelocity: Vector2(7, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0), // No se moverá el fondo
      size: size,
    );
    add(fondo); // Agregar el fondo al juego

    // Inicializar otros componentes del juego (jugador, enemigos, etc.)
    inicializarComponentes();
  }

  // Función que inicializa los componentes del juego
  void inicializarComponentes() async {
    try {
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",
        Vector2(48, 48),
      );

      mapa.scale = Vector2(1.34, 1);
      add(mapa);

      // Inicializar plataformas
      final ObjectGroup? colisiones =
          mapa.tileMap.getLayer<ObjectGroup>('colisiones');
      if (colisiones != null) {
        for (final objeto in colisiones.objects) {
          final plataforma = ColisionPlataforma(
            position: Vector2(objeto.x * 1.34, objeto.y * 1),
            size: Vector2(objeto.width * 1.34, objeto.height * 1),
          );
          add(plataforma);
        }
      }

      // Agregar los Pikachus desde el mapa
      final ObjectGroup? objectGroupPikachu =
          mapa.tileMap.getLayer<ObjectGroup>('pikachu');
      if (objectGroupPikachu != null) {
        for (final posPikachuEnMapa in objectGroupPikachu.objects) {
          final pikachu = Pikachu(
            position:
                Vector2(posPikachuEnMapa.x * 1.34, posPikachuEnMapa.y * 1),
          );
          add(pikachu);
          print("⚡ Pikachu agregado en posición: ${pikachu.position}");
        }
      } else {
        print("⚠ No se encontraron Pikachus en el mapa.");
      }

      // ✅ Inicializar Ash ANTES de llamar a iniciarJuego()
      _ashPlayer = Ash(position: Vector2(40, 550), movimientoHabilitado: false);
      add(_ashPlayer);

      // ✅ Inicializar Maya antes de ser usado en iniciarJuego()
      _maya = Maya(position: Vector2(1840, 753), movimientoHabilitado: false);
      add(_maya);

      print("✅ Ash y Maya han sido inicializados correctamente.");
    } catch (e) {
      print('Error cargando el mapa: $e');
    }
  }

  // Función que inicia el juego
  void iniciarJuego() {
    juegoEnCurso = true;
    _ashPlayer.habilitarMovimiento(true);
    _maya.habilitarMovimiento(true); // Habilitar el movimiento de Maya
    overlays.remove('MenuInicio');
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);
    print("Reproduciendo música...");
  }

  @override
  bool debugMode = true; // Habilitar el modo de depuración
  // Función que muestra el estado de 'Game Over'
  void mostrarGameOver() {
    juegoEnCurso = false; // Marcar que el juego ha terminado
    _ashPlayer
        .habilitarMovimiento(false); // Deshabilitar el movimiento del jugador
    overlays.add('GameOverMenu'); // Mostrar el menú de Game Over
  }

  // Función que reinicia el juego
  void reiniciarJuego() {
    juegoEnCurso = true; // Volver a iniciar el juego
    overlays.remove('GameOverMenu'); // Eliminar el menú de Game Over
    removeAll(children); // Eliminar todos los componentes del juego
    inicializarComponentes(); // Volver a inicializar los componentes
  }

  @override
  void update(double dt) {
    super.update(dt); // Llamar al método de actualización de Flame

    // Si el juego no está en curso, no hacemos nada
    if (!juegoEnCurso) {
      return;
    }

    // Si el jugador se ha caído fuera de la pantalla, mostrar 'Game Over'
    if (_ashPlayer.position.y > size.y) {
      mostrarGameOver();
    }
  }

  @override
  void onRemove() {
    super.onRemove(); // Llamar al método de eliminación de Flame
    // Detener y limpiar todos los audios cuando el juego se cierra
    FlameAudio.bgm.stop(); // Detener la música de fondo
  }
}
