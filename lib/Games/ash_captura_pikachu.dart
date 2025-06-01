import 'dart:io'; // Importación de 'dart:io' (puede que no sea estrictamente necesaria para el juego, pero se mantiene si se usa en otros contextos)

import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart'; // Importa la clase de componentes de plataforma para colisiones.
import 'package:ash_captura_pikachu/personajes/maya.dart'; // Importa la clase del personaje Maya.
import 'package:ash_captura_pikachu/personajes/pikachu.dart'; // Importa la clase del personaje Pikachu.
import 'package:flame/components.dart'; // Componentes base de Flame.
import 'package:flame/events.dart'; // Eventos de Flame (ej. teclado).
import 'package:flame/game.dart'; // La clase base para juegos Flame.
import 'package:flame/parallax.dart'; // Para el fondo parallax.
import 'package:flame_tiled/flame_tiled.dart'; // Para cargar mapas creados con Tiled.
import 'package:flame_audio/flame_audio.dart'; // Para el manejo de audio.
import 'package:flutter/foundation.dart'; // Para kDebugMode.

import '../personajes/ash.dart'; // Importa la clase del personaje Ash.

/// [AshCapturaPikachu] es la clase principal del juego, que extiende [FlameGame].
///
/// Implementa [HasCollisionDetection] para permitir la detección de colisiones
/// entre componentes, y [HasKeyboardHandlerComponents] para manejar la entrada
/// del teclado para los personajes.
///
/// Esta clase gestiona el ciclo de vida del juego, la carga de recursos,
/// la inicialización de los componentes, el control del tiempo, y los estados
/// de juego (inicio, en curso, game over).
class AshCapturaPikachu extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  /// Instancia del personaje principal, Ash.
  /// Se declara como `late` porque se inicializará en `inicializarComponentes`.
  late Ash _ashPlayer;

  /// Instancia del segundo personaje jugable, Maya.
  /// Se declara como `late` porque se inicializará en `inicializarComponentes`.
  late Maya _maya;

  /// Tiempo restante para la duración del juego en segundos.
  /// Se inicializa en 30.0 segundos.
  double tiempoRestante = 30.0;

  /// [ValueNotifier] para el contador de Pikachus capturados por Ash.
  /// Utilizado para actualizar la interfaz de usuario de forma reactiva.
  final ValueNotifier<int> pikachusAsh = ValueNotifier<int>(0);

  /// [ValueNotifier] para el contador de Pikachus capturados por Maya.
  /// Utilizado para actualizar la interfaz de usuario de forma reactiva.
  final ValueNotifier<int> pikachusMaya = ValueNotifier<int>(0);

  /// Bandera que indica si el juego está actualmente en curso.
  /// Controla el flujo de actualización del juego y la interacción del usuario.
  bool juegoEnCurso = false;

  @override
  /// Método [onLoad] que se llama una vez cuando el juego se carga.
  ///
  /// Es un método asíncrono donde se realiza la carga inicial de todos los
  /// recursos del juego (imágenes, audio, mapas) y se configuran elementos
  /// como la cámara y el fondo.
  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Llama al método onLoad del componente base (FlameGame).

    // Carga todas las imágenes necesarias en el caché de Flame.
    await images.loadAll([
      'AshAndando.png',
      'Summer6.png', // Imagen para el fondo parallax.
      'PIKACHU.png',
      'maya.png',
    ]);

    // Carga y comienza la reproducción de la música de fondo.
    await FlameAudio.audioCache.load('musica_fondo.mp3');
    FlameAudio.bgm.play('musica_fondo.mp3', volume: 0.5); // Reproduce la música con un volumen de 0.5.
    if (kDebugMode) {
      print("Reproduciendo música..."); // Mensaje de depuración.
    }

    // Configura el anclaje de la cámara en la esquina superior izquierda del juego.
    camera.viewfinder.anchor = Anchor.topLeft;

    // Carga y añade el componente de fondo parallax.
    final fondo = await loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'), // Datos de la imagen para el parallax.
      ],
      baseVelocity: Vector2(7, 0), // Velocidad de desplazamiento horizontal del fondo.
      velocityMultiplierDelta: Vector2(1.2, 1.0), // Multiplicador de velocidad para capas (si hubiera más).
      size: size, // Tamaño del fondo igual al tamaño de la vista del juego.
    );
    add(fondo); // Agrega el fondo al árbol de componentes del juego.

    // Llama a la función para inicializar los componentes específicos del juego.
    inicializarComponentes();
  }

  /// [inicializarComponentes] es una función asíncrona que se encarga de
  /// cargar el mapa del juego desde un archivo Tiled (.tmx) y poblar el mundo
  /// con plataformas ([ColisionPlataforma]), Pikachus ([Pikachu]) y los
  /// personajes jugables ([Ash], [Maya]) basándose en los datos del mapa.
  void inicializarComponentes() async {
    try {
      // Carga el mapa Tiled.
      final TiledComponent mapa = await TiledComponent.load(
        "mapa.tmx", // Nombre del archivo del mapa.
        Vector2(48, 48), // Tamaño de los azulejos (tiles) del mapa.
      );

      mapa.scale = Vector2(1.34, 1); // Ajusta la escala del mapa.
      add(mapa); // Agrega el mapa al juego.

      // Inicializa plataformas a partir de la capa 'colisiones' del mapa.
      final ObjectGroup? colisiones =
          mapa.tileMap.getLayer<ObjectGroup>('colisiones');
      if (colisiones != null) {
        for (final objeto in colisiones.objects) {
          final plataforma = ColisionPlataforma(
            position: Vector2(objeto.x * 1.34, objeto.y * 1), // Ajusta la posición según la escala del mapa.
            size: Vector2(objeto.width * 1.34, objeto.height * 1), // Ajusta el tamaño según la escala del mapa.
          );
          add(plataforma); // Agrega cada plataforma al juego.
        }
      }

      // Agrega los Pikachus desde la capa 'pikachu' del mapa.
      final ObjectGroup? objectGroupPikachu =
          mapa.tileMap.getLayer<ObjectGroup>('pikachu');

      if (objectGroupPikachu != null) {
        for (final posPikachuEnMapa in objectGroupPikachu.objects) {
          final pikachu = Pikachu(
            position:
                Vector2(posPikachuEnMapa.x * 1.34, posPikachuEnMapa.y * 1), // Ajusta la posición.
          );
          add(pikachu); // Agrega cada Pikachu al juego.
          if (kDebugMode) {
            print("⚡ Pikachu agregado en posición: ${pikachu.position}"); // Mensaje de depuración.
          }
        }
      } else {
        if (kDebugMode) {
          print("⚠ No se encontraron Pikachus en el mapa."); // Advertencia si no hay Pikachus en el mapa.
        }
      }

      // Inicializa los personajes Ash y Maya en sus posiciones de inicio predefinidas.
      _ashPlayer =
          Ash(position: Vector2(190, 890), movimientoHabilitado: false); // Ash inicia con movimiento deshabilitado.
      add(_ashPlayer); // Agrega a Ash al juego.

      _maya = Maya(position: Vector2(1330, 850), movimientoHabilitado: false); // Maya inicia con movimiento deshabilitado.
      add(_maya); // Agrega a Maya al juego.

      if (kDebugMode) {
        print("✅ Ash y Maya han sido inicializados correctamente."); // Mensaje de depuración.
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando el mapa: $e'); // Captura y muestra errores durante la carga del mapa.
      }
    }
  }

  /// [iniciarJuego] es la función que pone el juego en marcha.
  ///
  /// Restablece los contadores de Pikachus, habilita el movimiento de los
  /// jugadores, oculta el menú de inicio y muestra los overlays de juego
  /// (contadores de tiempo y de Pikachus).
  void iniciarJuego() {
    juegoEnCurso = true; // Establece el estado del juego a 'en curso'.
    pikachusAsh.value = 0; // Reinicia el contador de Pikachus de Ash.
    pikachusMaya.value = 0; // Reinicia el contador de Pikachus de Maya.

    _ashPlayer.habilitarMovimiento(true); // Habilita el movimiento de Ash.
    _maya.habilitarMovimiento(true); // Habilita el movimiento de Maya.

    overlays.remove('MenuInicio'); // Oculta el overlay del menú de inicio.
    overlays.addAll([
      'ContadorTiempo',
      'ContadorAsh',
      'ContadorMaya'
    ]); // Muestra los overlays de juego.

    FlameAudio.bgm.play('musica_fondo.mp3',
        volume: 0.5); // Asegura que la música de fondo se esté reproduciendo.
  }

  @override
  /// Bandera que controla si el modo de depuración de Flame está activo.
  ///
  /// Cuando es `true`, Flame puede dibujar elementos de depuración como
  /// hitboxes. Se establece en `false` para no mostrar estas ayudas visuales
  /// en la versión final del juego.
  bool debugMode = false;

  /// [mostrarGameOver] es la función que se llama cuando el juego termina
  /// (por ejemplo, al agotarse el tiempo).
  ///
  /// Detiene el juego, deshabilita el movimiento de los jugadores y muestra
  /// la pantalla de resultados (Game Over).
  void mostrarGameOver() {
    juegoEnCurso = false; // Detiene el flujo de actualización del juego.
    _ashPlayer.habilitarMovimiento(false); // Deshabilita el movimiento de Ash.
    _maya.habilitarMovimiento(false); // Deshabilita el movimiento de Maya.

    overlays.add('Resultados'); // Muestra el overlay de la pantalla de resultados.
  }

  /// [reiniciarJuego] es la función que se encarga de restablecer el estado
  /// del juego para comenzar una nueva partida.
  ///
  /// Limpia todos los componentes, reinicia el temporizador y vuelve a
  /// inicializar el fondo y los demás componentes del juego. Finalmente,
  /// muestra el menú de inicio nuevamente.
  void reiniciarJuego() {
    juegoEnCurso = false; // Asegura que el juego esté detenido antes de reiniciar.
    overlays.clear(); // Limpia todos los overlays actualmente mostrados.

    removeAll(children); // Elimina todos los componentes del juego.

    tiempoRestante = 30.0; // Reinicia el temporizador a su valor inicial.

    // Vuelve a cargar y añadir el fondo parallax para el nuevo juego.
    loadParallaxComponent(
      [
        ParallaxImageData('Summer6.png'),
      ],
      baseVelocity: Vector2(7, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
      size: size,
    ).then((fondo) => add(fondo)); // Agrega el fondo una vez cargado.

    inicializarComponentes(); // Vuelve a inicializar todos los elementos del juego (mapa, jugadores, Pikachus).

    overlays.add('MenuInicio'); // Muestra el menú de inicio para la nueva partida.
  }

  @override
  /// [update] es el método principal del ciclo de juego, llamado en cada fotograma.
  ///
  /// Se encarga de actualizar la lógica del juego, como el temporizador.
  ///
  /// [dt] es el tiempo transcurrido desde el último fotograma en segundos.
  void update(double dt) {
    super.update(dt); // Llama al método update de la clase base.

    if (!juegoEnCurso) return; // Si el juego no está en curso, no se actualiza la lógica.

    tiempoRestante -= dt; // Decrementa el tiempo restante.
    if (tiempoRestante <= 0) {
      tiempoRestante = 0; // Asegura que el tiempo no sea negativo.
      mostrarGameOver(); // Llama a la función para mostrar la pantalla de fin de juego.
    }

    // Actualiza el overlay del contador de tiempo.
    // Esto se hace removiendo y volviendo a añadir el overlay para forzar la reconstrucción.
    overlays.remove('ContadorTiempo');
    overlays.add('ContadorTiempo');
  }

  @override
  /// [onRemove] se llama cuando el componente de juego es eliminado (por ejemplo, al cerrar la aplicación).
  ///
  /// Se utiliza para liberar recursos, como detener la música de fondo.
  void onRemove() {
    super.onRemove(); // Llama al método onRemove de la clase base.
    FlameAudio.bgm.stop(); // Detiene la música de fondo para liberar recursos de audio.
  }
}