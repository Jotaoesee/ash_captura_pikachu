import 'dart:ui';

import 'package:ash_captura_pikachu/personajes/maya.dart';
import 'package:ash_captura_pikachu/personajes/pikachu.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../personajes/ash.dart';

// Clase principal del juego que hereda de FlameGame
class AshCapturaPikachu extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Ash _ashPlayer;
  late Maya _maya;

  double tiempoRestante = 30;
  bool tiempoAgotado = false;
  int pikachusCapturadosAsh = 0;
  int pikachusCapturadosMaya = 0;
  bool juegoEnCurso = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      'AshAndando.png',
      'Summer6.png',
      'PIKACHU.png',
      'maya.png',
    ]);

    await FlameAudio.audioCache.load('musica_fondo.mp3');
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);

    camera.viewfinder.anchor = Anchor.topLeft;

    final fondo = await loadParallaxComponent(
      [ParallaxImageData('Summer6.png')],
      baseVelocity: Vector2(7, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
      size: size,
    );
    add(fondo);

    inicializarComponentes();
  }

  void inicializarComponentes() async {
    try {
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",
        Vector2(48, 48),
      );
      mapa.scale = Vector2(1.34, 1);
      add(mapa);

      final objectGroupPikachu = mapa.tileMap.getLayer<ObjectGroup>('pikachu');
      final fisicasRectangulos =
          mapa.tileMap.getLayer<ObjectGroup>('colisiones_rectagulos');

      if (fisicasRectangulos != null) {
        for (final TiledObject obj in fisicasRectangulos.objects) {
          final collisionObject = PositionComponent(
            position: Vector2(obj.x * 1.34, obj.y * 1),
            size: Vector2(obj.width * 1.34, obj.height * 1),
            anchor: Anchor.topLeft,
          );

          collisionObject.add(
            RectangleHitbox()
              ..collisionType = CollisionType.passive
              ..debugColor = const Color(0xFFFF0000), // Rojo brillante
          );

          collisionObject.debugMode = true;
          add(collisionObject);

          if (kDebugMode) {
            print(
                'Objeto de colisión añadido: posición=${obj.x * 1.34}, ${obj.y * 1}, tamaño=${obj.width * 1.34}, ${obj.height * 1}');
          }
        }
      }

      for (final posPikachuEnMapa in objectGroupPikachu!.objects) {
        add(Pikachu(
          position: Vector2(posPikachuEnMapa.x * 1.34, posPikachuEnMapa.y * 1),
        ));
      }

      _ashPlayer = Ash(position: Vector2(40, 655), movimientoHabilitado: false);
      add(_ashPlayer);

      _maya = Maya(position: Vector2(1840, 753), movimientoHabilitado: false);
      add(_maya);
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando el mapa: $e');
      }
    }
  }

  // Función que inicia el juego
  void iniciarJuego() {
    juegoEnCurso = true;
    tiempoRestante = 30; // Reiniciar el tiempo
    tiempoAgotado = false;
    pikachusCapturadosAsh = 0; // Reiniciar contadores
    pikachusCapturadosMaya = 0;
    _ashPlayer.habilitarMovimiento(true);
    _maya.habilitarMovimiento(true); // Habilitar el movimiento de Maya
    overlays.remove('MenuInicio');
    overlays.add('CuentaAtras'); // Mostrar la cuenta atrás
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);
    if (kDebugMode) {
      print("Reproduciendo música...");
    }
  }

  @override
  // ignore: overridden_fields
  bool debugMode = true; // Habilitar el modo de depuración

  // Función que muestra el estado de 'Game Over'
  void mostrarGameOver() {
    juegoEnCurso = false;
    _ashPlayer.habilitarMovimiento(false);
    overlays.add('GameOver'); // Cambiado a 'GameOver'
  }

  // Función que muestra el resultado final del juego
  void mostrarResultado() {
    juegoEnCurso = false;
    _ashPlayer.habilitarMovimiento(false);
    _maya.habilitarMovimiento(false);

    String mensajeGanador;
    if (pikachusCapturadosAsh > pikachusCapturadosMaya) {
      mensajeGanador = "¡Ash gana!";
    } else if (pikachusCapturadosMaya > pikachusCapturadosAsh) {
      mensajeGanador = "¡Maya gana!";
    } else {
      mensajeGanador = "¡Es un empate!";
    }

    overlays.add('Resultado'); // Mostrar el overlay de resultado
  }

  // Función que reinicia el juego
  void reiniciarJuego() {
    juegoEnCurso = true; // Volver a iniciar el juego
    tiempoRestante = 30; // Reiniciar el tiempo
    tiempoAgotado = false;
    pikachusCapturadosAsh = 0; // Reiniciar contadores
    pikachusCapturadosMaya = 0;
    overlays.remove('GameOverMenu'); // Eliminar el menú de Game Over
    removeAll(children); // Eliminar todos los componentes del juego
    inicializarComponentes(); // Volver a inicializar los componentes
    overlays.add('CuentaAtras'); // Mostrar la cuenta atrás
  }

  @override
  void update(double dt) {
    super.update(dt); // Llamar al método de actualización de Flame

    // Si el juego no está en curso, no hacemos nada
    if (!juegoEnCurso) {
      return;
    }

    // Actualizar el temporizador
    if (!tiempoAgotado) {
      tiempoRestante -= dt; // Reducir el tiempo restante
      if (tiempoRestante <= 0) {
        tiempoAgotado = true;
        tiempoRestante = 0;
        mostrarResultado(); // Mostrar el resultado cuando el tiempo se agote
      }
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
