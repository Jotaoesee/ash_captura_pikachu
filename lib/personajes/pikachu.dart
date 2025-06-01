import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder a los contadores.
import 'package:ash_captura_pikachu/personajes/ash.dart'; // Importa la clase del personaje Ash.
import 'package:ash_captura_pikachu/personajes/maya.dart'; // Importa la clase del personaje Maya.
import 'package:flame/components.dart'; // Componentes base de Flame.
import 'package:flame/collisions.dart'; // Para el manejo de colisiones.
import 'package:flame_audio/flame_audio.dart'; // Para el manejo de audio.
import 'package:flutter/foundation.dart'; // Para kDebugMode (modo de depuración).

/// [Pikachu] es un componente de juego que representa un Pikachu.
///
/// Extiende [SpriteAnimationComponent] para manejar la animación del sprite
/// de Pikachu, mezcla [HasGameReference] para acceder a la instancia del juego
/// principal (y sus contadores de Pikachus), y [CollisionCallbacks] para
/// detectar colisiones con los personajes Ash y Maya.
///
/// Cuando un Pikachu es capturado por un jugador, su contador respectivo
/// se incrementa, se reproduce un sonido y el Pikachu es eliminado del juego.
class Pikachu extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, CollisionCallbacks {
  /// Constructor de la clase [Pikachu].
  ///
  /// Recibe la [position] inicial de Pikachu en el mundo del juego.
  Pikachu({
    required super.position,
  }) : super(
          size: Vector2(50, 50), // Define el tamaño visual del sprite de Pikachu (ancho y alto).
          anchor: Anchor
              .topCenter, // El punto de anclaje del sprite se establece en la parte superior central.
        );

  @override
  /// Método [onLoad] que se llama una vez cuando el componente Pikachu se añade al árbol de componentes.
  ///
  /// En este método, se configura la animación de Pikachu y se añade su
  /// [RectangleHitbox] para la detección de colisiones.
  void onLoad() {
    // Configura la animación de Pikachu.
    // Se asume que 'PIKACHU.png' contiene una secuencia de 4 frames de 64x64 píxeles.
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'PIKACHU.png'), // Carga la imagen de Pikachu desde el caché de imágenes de Flame.
      SpriteAnimationData.sequenced(
        amount: 4, // Número de fotogramas en la secuencia de animación.
        textureSize: Vector2.all(64), // Tamaño de cada fotograma individual en la hoja de sprites.
        stepTime: 0.12, // Duración de cada fotograma en segundos, controlando la velocidad de la animación.
      ),
    );

    // Definición de las dimensiones y posición de la hitbox de Pikachu.
    // Una hitbox más pequeña que el sprite completo puede hacer que las colisiones
    // se sientan más naturales, detectando el cuerpo central de Pikachu.
    final double anchoHitbox = 23.0; // Ancho de la hitbox en píxeles.
    final double alturaHitbox = 32.0; // Altura de la hitbox en píxeles.
    final Vector2 posicionHitbox =
        Vector2(1.0, 1.0); // Posición relativa de la hitbox con respecto al origen del sprite.

    // Añade una hitbox rectangular a Pikachu para la detección de colisiones.
    add(RectangleHitbox(
      size: Vector2(anchoHitbox, alturaHitbox), // Tamaño de la hitbox definido anteriormente.
      position: posicionHitbox, // Posición relativa de la hitbox.
      collisionType: CollisionType
          .active, // Define la hitbox como activa, lo que significa que participará en las colisiones.
    ));
  }

  @override
  /// [onCollision] es el método callback que se invoca cuando Pikachu colisiona con otro componente.
  ///
  /// Se utiliza para detectar cuando Pikachu es "capturado" por Ash o Maya.
  /// Cuando esto ocurre, se incrementa el contador de Pikachus del jugador
  /// correspondiente, se reproduce un sonido y el Pikachu es removido del juego.
  ///
  /// [intersectionPoints] son los puntos donde las hitboxes se superponen.
  /// [other] es el otro componente con el que Pikachu ha colisionado.
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Comprueba si el componente con el que ha colisionado es Ash.
    if (other is Ash) {
      game.pikachusAsh
          .value++; // Incrementa el contador de Pikachus de Ash en la instancia del juego.
      if (kDebugMode) {
        print(
            "Pikachu capturado por Ash! Total Ash: ${game.pikachusAsh.value}"); // Mensaje de depuración.
      }

      // Reproduce el sonido de captura de Pikachu.
      // Asegúrate de que 'pikachu_sound.mp3' esté cargado en el caché de audio de Flame.
      FlameAudio.play('pikachu_sound.mp3');

      // Remueve la hitbox de Pikachu para evitar que se colisione de nuevo
      // si ya ha sido capturado.
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // Elimina este componente Pikachu del árbol de componentes del juego.
    }
    // Comprueba si el componente con el que ha colisionado es Maya.
    else if (other is Maya) {
      game.pikachusMaya
          .value++; // Incrementa el contador de Pikachus de Maya en la instancia del juego.
      if (kDebugMode) {
        print(
            "Pikachu capturado por Maya! Total Maya: ${game.pikachusMaya.value}"); // Mensaje de depuración.
      }

      // Reproduce el sonido de captura de Pikachu.
      FlameAudio.play('pikachu_sound.mp3');

      // Remueve la hitbox de Pikachu.
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // Elimina este componente Pikachu del árbol de componentes del juego.
    }
  }
}