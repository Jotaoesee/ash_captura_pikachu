import 'dart:ui';

import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:ash_captura_pikachu/personajes/ash.dart';
import 'package:ash_captura_pikachu/personajes/maya.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';

/// Clase que representa un Pikachu en el juego.
/// Pikachu es el objetivo que Ash debe capturar.
class Pikachu extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, CollisionCallbacks {
  /// Constructor de Pikachu
  ///
  /// Recibe la posición inicial del Pikachu en el mapa.
  Pikachu({
    required super.position,
  }) : super(
          size: Vector2(50, 50), // Tamaño del sprite de Pikachu
          anchor:
              Anchor.topCenter, // Punto de anclaje en la parte superior central
        );

  @override
  void onLoad() {
    // Configuración de la animación de Pikachu al cargar
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('PIKACHU.png'), // Imagen de Pikachu
      SpriteAnimationData.sequenced(
        amount: 4, // Número de fotogramas en la animación
        textureSize: Vector2.all(64), // Tamaño de cada fotograma
        stepTime: 0.12, // Tiempo entre cada fotograma
      ),
    );

    final anchoHitbox = 23.0; // Ancho fijo en píxeles
    final alturaHitbox = 32.0; // Altura fija en píxeles
    final posicionHitbox =
        Vector2(1.0, 1.0); // Ajustes manuales para la posición

    // Añadir la hitbox personalizada
    add(RectangleHitbox(
      size: Vector2(anchoHitbox, alturaHitbox), // Tamaño de la hitbox
      position: posicionHitbox, // Posición relativa al sprite
      collisionType: CollisionType.active,
    )..debugColor = const Color(0xFF0033FF)); // Color para depuración de hitbox
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ash) {
      game.pikachusAsh.value++; // ✅ Incrementa el contador correctamente
      print(
          "⚡ Pikachu capturado por Ash! Total Ash: ${game.pikachusAsh.value}");

      // 🔊 Reproducir sonido de captura
      FlameAudio.play('pikachu_sound.mp3');

      // 🔹 Desactiva la hitbox para evitar colisiones dobles
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // 🚀 Elimina el Pikachu de la pantalla
    } else if (other is Maya) {
      game.pikachusMaya.value++; // ✅ Incrementa el contador correctamente
      print(
          "⚡ Pikachu capturado por Maya! Total Maya: ${game.pikachusMaya.value}");

      // 🔊 Reproducir sonido de captura
      FlameAudio.play('pikachu_sound.mp3');

      // 🔹 Desactiva la hitbox para evitar colisiones dobles
      removeWhere((component) => component is RectangleHitbox);
      removeFromParent(); // 🚀 Elimina el Pikachu de la pantalla
    }
  }
}
