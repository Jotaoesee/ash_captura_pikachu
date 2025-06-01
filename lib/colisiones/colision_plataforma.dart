import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

/// [ColisionPlataforma] es una clase que representa una plataforma estática
/// en el juego, diseñada específicamente para manejar colisiones.
///
/// Extiende [PositionComponent] de Flame para tener propiedades de posición
/// y tamaño, y mezcla [CollisionCallbacks] para habilitar la detección de colisiones.
/// Esta clase es fundamental para definir los límites del mundo o superficies
/// sobre las cuales otros componentes pueden interactuar, como un jugador
/// que aterriza en ellas.
class ColisionPlataforma extends PositionComponent with CollisionCallbacks {
  /// Constructor de la clase [ColisionPlataforma].
  ///
  /// Requiere una [position] (posición) y un [size] (tamaño) para definir
  /// dónde se ubicará y qué tan grande será la plataforma en el mundo del juego.
  ColisionPlataforma({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  /// Método [onLoad] que se llama una vez cuando el componente se añade al árbol de componentes.
  ///
  /// En este método asíncrono, se inicializa la lógica de colisión para la plataforma.
  /// Se añade un [RectangleHitbox] que define el área de colisión de la plataforma.
  ///
  /// El [CollisionType.passive] significa que este componente no iniciará eventos de colisión
  /// con otros componentes pasivos, pero otros componentes activos pueden colisionar con él.
  /// Es ideal para plataformas y elementos estáticos del entorno.
  Future<void> onLoad() async {
    super.onLoad(); // Llama al método onLoad de la clase base (PositionComponent).

    // Añade una hitbox rectangular al componente.
    // La hitbox es esencial para que Flame detecte interacciones físicas con esta plataforma.
    add(RectangleHitbox(
      size: size, // El tamaño de la hitbox es idéntico al tamaño visual de la plataforma.
      position: Vector2.zero(), // La hitbox se posiciona en el origen local (0,0) del componente.
      collisionType: CollisionType.passive, // Define el tipo de colisión como pasivo.
    )
          // `debugMode = false` (o true para depuración) controla si la hitbox se dibuja
          // visiblemente en la pantalla durante el desarrollo.
          // En producción, esto debería ser `false` para evitar el dibujo de las cajas.
          ..debugMode = false); // Establecido a false para evitar que se dibuje la hitbox en producción.
  }
}