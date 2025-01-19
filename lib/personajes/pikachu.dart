import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:flame/components.dart';

/// Clase que representa un Pikachu en el juego.
/// Pikachu es el objetivo que Ash debe capturar.
class Pikachu extends SpriteAnimationComponent with HasGameReference<AshCapturaPikachu> {

  /// Constructor de Pikachu
  ///
  /// Recibe la posición inicial del Pikachu en el mapa.
  Pikachu({
    required super.position,
  }) : super(
    size: Vector2(50, 50), // Tamaño del sprite de Pikachu
    anchor: Anchor.topCenter, // Punto de anclaje en la parte superior central
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
  }
}
