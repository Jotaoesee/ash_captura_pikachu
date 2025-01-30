import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:ash_captura_pikachu/personajes/ash.dart';
import 'package:ash_captura_pikachu/personajes/maya.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// Clase que representa un Pikachu en el juego.
/// Pikachu es el objetivo que Ash y Maya deben capturar.
class Pikachu extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, CollisionCallbacks {
  /// Constructor de Pikachu que recibe su posición inicial en el mapa.
  Pikachu({
    required super.position,
  }) : super(
          size: Vector2(50, 50), // Define el tamaño del sprite de Pikachu
          anchor: Anchor
              .topCenter, // Establece el punto de anclaje en la parte superior central
        );

  @override
  void onLoad() {
    // Configuración de la animación de Pikachu al cargar
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'PIKACHU.png'), // Carga la imagen de Pikachu desde la caché
      SpriteAnimationData.sequenced(
        amount: 4, // Número de fotogramas en la animación
        textureSize: Vector2.all(64), // Tamaño de cada fotograma
        stepTime: 0.12, // Tiempo entre cada fotograma
      ),
    );

    final anchoHitbox = 23.0; // Ancho de la hitbox en píxeles
    final alturaHitbox = 32.0; // Altura de la hitbox en píxeles
    final posicionHitbox = Vector2(1.0, 1.0); // Posición relativa de la hitbox

    // Añadir la hitbox para detectar colisiones
    add(RectangleHitbox(
      size: Vector2(anchoHitbox, alturaHitbox), // Tamaño de la hitbox
      position: posicionHitbox, // Posición relativa al sprite
      collisionType: CollisionType
          .active, // Define la hitbox como activa para detectar colisiones
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Verifica si la colisión es con Ash
    if (other is Ash) {
      game.pikachusAsh
          .value++; // Incrementa el contador de Pikachus capturados por Ash
      if (kDebugMode) {
        print(
            "Pikachu capturado por Ash! Total Ash: ${game.pikachusAsh.value}");
      }

      // Reproduce el sonido de captura de Pikachu
      FlameAudio.play('pikachu_sound.mp3');

      // Desactiva la hitbox para evitar múltiples colisiones
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // Elimina el Pikachu del juego
    }
    // Verifica si la colisión es con Maya
    else if (other is Maya) {
      game.pikachusMaya
          .value++; // Incrementa el contador de Pikachus capturados por Maya
      if (kDebugMode) {
        print(
            "Pikachu capturado por Maya! Total Maya: ${game.pikachusMaya.value}");
      }

      // Reproduce el sonido de captura de Pikachu
      FlameAudio.play('pikachu_sound.mp3');

      // Desactiva la hitbox para evitar múltiples colisiones
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // Elimina el Pikachu del juego
    }
  }
}
