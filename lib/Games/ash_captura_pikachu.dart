import 'package:ash_captura_pikachu/personajes/pikachu.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../personajes/ash_player.dart';

class AshCapturaPikachu extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // Instancia del jugador (Ash)
  late AshPlayer _ashPlayer;

  // Estado del juego
  bool juegoEnCurso = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Llamada al método de inicialización de FlameGame

    // Cargar todas las imágenes necesarias para el juego
    await images.loadAll([
      'AshAndando.png', // Imagen para la animación de Ash
      'Summer6.png',    // Fondo del juego
      'PIKACHU.png',    // Imagen de Pikachu (objetivo a capturar)
    ]);

    // Configurar la cámara para que use la esquina superior izquierda como ancla
    camera.viewfinder.anchor = Anchor.topLeft;

    // Cargar y agregar el fondo del juego
    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'), // Fondo del escenario
      ],
      baseVelocity: Vector2.zero(), // Fondo estático sin movimiento
      size: size, // Tamaño del fondo adaptado a la pantalla
    );
    add(fondo); // Agregar el fondo al juego

    // Configurar el juego
    inicializarComponentes();
  }

  void inicializarComponentes() async {
    try {
      // Cargar el mapa del juego desde un archivo .tmx
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx",        // Archivo del mapa
        Vector2(48, 48),   // Tamaño de los tiles en el mapa
      );

      // Ajustar la escala del mapa para que encaje en el escenario
      mapa.scale = Vector2(1.34, 1); // Escala horizontal y vertical del mapa

      // Agregar el mapa al juego
      add(mapa);

      // Obtener el grupo de objetos "pikachu" del mapa
      final objectGroupPikachu = mapa.tileMap.getLayer<ObjectGroup>('pikachu');

      // Iterar sobre los objetos de la capa y agregar instancias de Pikachu al juego
      for (final posPikachuEnMapa in objectGroupPikachu!.objects) {
        add(Pikachu(
          position: Vector2(
            posPikachuEnMapa.x * 1.34, // Ajuste de posición horizontal
            posPikachuEnMapa.y * 1,    // Ajuste de posición vertical
          ),
        ));
      }

      // Crear la instancia del jugador (Ash) y establecer su posición inicial
      _ashPlayer = AshPlayer(
        position: Vector2(40, 655),
        movimientoHabilitado: false, // No se habilita el movimiento al principio
      );

      // Agregar el jugador al juego
      add(_ashPlayer);
    } catch (e) {
      // Manejar errores al cargar el mapa y mostrar un mensaje en la consola
      print('Error cargando el mapa: $e');
    }
  }

  // Función para iniciar el juego
  void iniciarJuego() {
    juegoEnCurso = true;
    _ashPlayer.habilitarMovimiento(true); // Habilitar movimiento de Ash
    overlays.remove('MenuInicio'); // Eliminar el overlay de inicio
  }

  // Función para mostrar el "Game Over"
  void mostrarGameOver() {
    juegoEnCurso = false;
    _ashPlayer.habilitarMovimiento(false); // Deshabilitar movimiento de Ash
    overlays.add('GameOverMenu'); // Mostrar el overlay de "Game Over"
  }

  // Función para reiniciar el juego
  void reiniciarJuego() {
    juegoEnCurso = true;
    overlays.remove('GameOverMenu'); // Ocultar el overlay de "Game Over"
    removeAll(children); // Eliminar todos los componentes actuales
    inicializarComponentes(); // Reiniciar el juego
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!juegoEnCurso) {
      return; // Pausa el juego si no está en curso
    }

    // Lógica de "Game Over" (por ejemplo, si Ash cae fuera del mapa)
    if (_ashPlayer.position.y > size.y) {
      mostrarGameOver();
    }
  }
}
