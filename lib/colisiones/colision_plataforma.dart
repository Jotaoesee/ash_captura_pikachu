import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

/// Clase que representa una plataforma en el juego para manejar las colisiones.
class ColisionPlataforma extends PositionComponent with CollisionCallbacks {
  /// Constructor de la clase ColisionPlataforma.
  /// Recibe la posición y el tamaño de la plataforma.
  ColisionPlataforma({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super
        .onLoad(); // Llama al método onLoad del componente base (PositionComponent).

    // Añadimos una hitbox (área de colisión) a la plataforma.
    // La hitbox será del mismo tamaño que la plataforma y estará en la posición (0, 0) relativa a la plataforma.
    add(RectangleHitbox(
      size:
          size, // El tamaño de la hitbox será igual al tamaño de la plataforma.
      position: Vector2
          .zero(), // La posición de la hitbox es (0, 0), es decir, alineada con la plataforma.
      collisionType: CollisionType
          .passive, // Tipo de colisión pasiva, no activa el movimiento al colisionar.
    )..debugMode =
        true); // Activamos el modo de depuración para que podamos ver la hitbox visualmente durante el desarrollo.
  }
}
