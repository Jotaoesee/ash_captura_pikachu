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
import 'package:flutter/foundation.dart';

import '../personajes/ash.dart';

/// Clase principal del juego que hereda de FlameGame
class AshCapturaPikachu extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Ash _ashPlayer; // Instancia del personaje Ash
  late Maya _maya; // Instancia del personaje Maya
  double tiempoRestante = 30.0; // Tiempo total del juego en segundos

  // Contadores de Pikachus capturados por cada jugador (usando ValueNotifier para actualizar UI)
  final ValueNotifier<int> pikachusAsh = ValueNotifier<int>(0);
  final ValueNotifier<int> pikachusMaya = ValueNotifier<int>(0);

  bool juegoEnCurso = false; // Indica si el juego está en curso

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

    // Cargar y reproducir la música de fondo
    await FlameAudio.audioCache.load('musica_fondo.mp3');
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);
    if (kDebugMode) {
      print("Reproduciendo música...");
    }

    // Configurar la cámara para anclarse en la esquina superior izquierda
    camera.viewfinder.anchor = Anchor.topLeft;

    // Cargar y mostrar el fondo parallax
    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'),
      ],
      baseVelocity: Vector2(7, 0), // Velocidad de desplazamiento del fondo
      velocityMultiplierDelta: Vector2(1.2, 1.0),
      size: size,
    );
    add(fondo); // Agregar el fondo al juego

    // Inicializar los componentes del juego (jugadores, plataformas, Pikachus, etc.)
    inicializarComponentes();
  }

  /// Función que inicializa los componentes del juego
  void inicializarComponentes() async {
    try {
      // Cargar el mapa de Tiled
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",
        Vector2(48, 48),
      );

      mapa.scale = Vector2(1.34, 1); // Ajustar escala del mapa
      add(mapa);

      // Inicializar plataformas a partir de los datos del mapa
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
          if (kDebugMode) {
            print("⚡ Pikachu agregado en posición: ${pikachu.position}");
          }
        }
      } else {
        if (kDebugMode) {
          print("⚠ No se encontraron Pikachus en el mapa.");
        }
      }

      // Inicializar los personajes Ash y Maya en sus posiciones de inicio
      _ashPlayer =
          Ash(position: Vector2(190, 890), movimientoHabilitado: false);
      add(_ashPlayer);

      _maya = Maya(position: Vector2(1330, 850), movimientoHabilitado: false);
      add(_maya);

      if (kDebugMode) {
        print("✅ Ash y Maya han sido inicializados correctamente.");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando el mapa: $e');
      }
    }
  }

  /// Función que inicia el juego
  void iniciarJuego() {
    juegoEnCurso = true;
    pikachusAsh.value = 0; // Reiniciar el contador de Ash
    pikachusMaya.value = 0; // Reiniciar el contador de Maya

    _ashPlayer.habilitarMovimiento(true);
    _maya.habilitarMovimiento(true);

    overlays.remove('MenuInicio'); // Ocultar el menú de inicio
    overlays.addAll([
      'ContadorTiempo',
      'ContadorAsh',
      'ContadorMaya'
    ]); // Mostrar overlays de juego

    // Reproducir la música de fondo
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5);
  }

  @override
  bool debugMode = false; // Desactiva el modo de depuración

  /// Función que muestra la pantalla de Game Over
  void mostrarGameOver() {
    juegoEnCurso = false; // Detener el juego
    _ashPlayer.habilitarMovimiento(false);
    _maya.habilitarMovimiento(false);

    overlays.add('Resultados'); // Muestra la pantalla de resultados
  }

  /// Función que reinicia el juego
  void reiniciarJuego() {
    juegoEnCurso = false; // Detener el juego antes de reiniciarlo
    overlays.clear(); // Eliminar todos los overlays activos

    removeAll(children); // Eliminar todos los elementos del juego

    tiempoRestante = 30.0; // Reiniciar el temporizador

    // Volver a cargar el fondo parallax
    loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'),
      ],
      baseVelocity: Vector2(7, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
      size: size,
    ).then((fondo) => add(fondo));

    inicializarComponentes(); // Volver a inicializar los demás componentes

    overlays.add('MenuInicio'); // Mostrar el menú de inicio nuevamente
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!juegoEnCurso) return; // Si el juego no está en curso, no actualizar

    tiempoRestante -= dt;
    if (tiempoRestante <= 0) {
      tiempoRestante = 0;
      mostrarGameOver();
    }

    // Actualizar el overlay del contador de tiempo
    overlays.remove('ContadorTiempo');
    overlays.add('ContadorTiempo');
  }

  @override
  void onRemove() {
    super.onRemove(); // Llamar al método de eliminación de Flame
    FlameAudio.bgm.stop(); // Detener la música de fondo al salir del juego
  }
}
