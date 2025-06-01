import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart'; // Importa la clase de plataforma para colisiones.
import 'package:flame/components.dart'; // Componentes base de Flame.
import 'package:flutter/foundation.dart'; // Para kDebugMode (modo de depuración).
import 'package:flutter/services.dart'; // Para LogicalKeyboardKey (manejo de teclado).
import 'package:flame/collisions.dart'; // Para el manejo de colisiones.

import '../Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder a sus propiedades (ej. game over).

/// [Ash] es un componente de juego que representa al personaje principal, Ash Ketchum.
///
/// Extiende [SpriteAnimationComponent] para manejar animaciones,
/// mezcla [HasGameReference] para acceder a la instancia del juego principal,
/// [KeyboardHandler] para gestionar la entrada del teclado, y
/// [CollisionCallbacks] para detectar y responder a colisiones con otros componentes.
class Ash extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>, // Permite acceder a la instancia de `AshCapturaPikachu`.
        KeyboardHandler, // Habilita la detección de eventos de teclado.
        CollisionCallbacks {
  // --- Propiedades de Movimiento y Física ---

  /// Velocidad horizontal de Ash en píxeles por segundo.
  double velocidad = 150;

  /// Dirección actual del movimiento horizontal de Ash.
  /// - `Vector2(-1, 0)` para izquierda, `Vector2(1, 0)` para derecha, `Vector2.zero()` para quieto.
  Vector2 direccion = Vector2.zero();

  /// Velocidad inicial aplicada al personaje al saltar.
  /// Es negativa porque en Flame, el eje Y positivo va hacia abajo.
  double velocidadSalto = -308;

  /// Valor de la gravedad que afecta a Ash, en píxeles/segundo².
  double gravedad = 500;

  /// Bandera que indica si Ash está actualmente en el aire (saltando o cayendo).
  bool enElAire = false;

  /// Velocidad vertical actual de Ash, afectada por la gravedad y los saltos.
  double velocidadVertical = 0;

  /// Bandera que controla si el movimiento de Ash está habilitado.
  /// Esto es útil para pausas o menús de inicio/fin de juego.
  bool _movimientoHabilitado = false;

  // --- Propiedades de Animación ---

  /// Animación de Ash cuando está caminando.
  late SpriteAnimation animacionCaminando;

  /// Animación de Ash cuando está saltando.
  late SpriteAnimation animacionSaltando;

  /// Animación de Ash cuando está quieto.
  late SpriteAnimation animacionQuieto;

  /// Bandera que indica si Ash está mirando hacia la izquierda (sprite volteado horizontalmente).
  bool mirandoIzquierda = false;

  /// Constructor de la clase [Ash].
  ///
  /// Recibe la [position] inicial de Ash en el mundo del juego y un valor
  /// opcional para [movimientoHabilitado] que determina si puede moverse al inicio.
  Ash({required Vector2 position, bool movimientoHabilitado = false})
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    _movimientoHabilitado = movimientoHabilitado;
  }

  @override
  /// Método [onLoad] que se llama una vez cuando el componente Ash se añade al árbol de componentes.
  ///
  /// En este método asíncrono se cargan y configuran todas las animaciones
  /// de Ash, y se añade su [RectangleHitbox] para la detección de colisiones.
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      // Cargar animación de caminata de Ash desde la imagen en caché.
      // Se asume que 'AshAndando.png' contiene una secuencia de 4 sprites de 64x64.
      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 4, // Número de frames en la animación.
          textureSize: Vector2.all(64), // Tamaño de cada frame en la imagen.
          stepTime: 0.12, // Duración de cada frame (para una animación fluida).
        ),
      );

      // En este caso, la animación de salto es la misma que la de caminata.
      // Podría ser una animación diferente si se tiene un sprite específico para saltar.
      animacionSaltando = animacionCaminando;

      // Animación de Ash cuando está quieto (un solo frame de la secuencia).
      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 1, // Un solo frame.
          textureSize: Vector2.all(64),
          stepTime: 0.1, // El stepTime no es crítico para una animación de un solo frame.
        ),
      );

      // Establece la animación inicial de Ash a "quieto" y detiene la reproducción.
      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Ash: $e'); // Mensaje de error en modo depuración.
      }
      rethrow; // Relanza la excepción para un manejo superior.
    }

    // Agrega una hitbox rectangular a Ash para la detección de colisiones.
    // El tamaño y la posición se ajustan para que la hitbox sea más precisa
    // al cuerpo de Ash y no ocupe todo el sprite.
    add(RectangleHitbox(
      size: Vector2(32, 50), // Tamaño de la hitbox (más pequeño que el sprite completo).
      position: Vector2(18, 1), // Ajuste de la posición de la hitbox relativa al sprite.
      collisionType: CollisionType.active, // Tipo de colisión activa (participa en la física).
    ));
  }

  /// Habilita explícitamente el movimiento de Ash.
  ///
  /// Este método es útil para iniciar el control del jugador después de un menú
  /// de inicio o una secuencia introductoria.
  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  /// Activa o desactiva la capacidad de movimiento de Ash.
  ///
  /// [habilitado] es `true` para permitir el movimiento, `false` para deshabilitarlo.
  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  /// Inicia el salto de Ash.
  ///
  /// Solo se puede saltar si el movimiento está habilitado y Ash no está ya en el aire.
  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return; // No saltar si está deshabilitado o ya en el aire.
    enElAire = true; // Marca a Ash como "en el aire".
    velocidadVertical = velocidadSalto; // Establece la velocidad vertical inicial para el salto.
  }

  @override
  /// [update] es el método principal de actualización del componente, llamado en cada fotograma.
  ///
  /// Contiene la lógica para el movimiento horizontal, la aplicación de la gravedad,
  /// la detección de la caída fuera de los límites del juego y la actualización
  /// de la animación de Ash.
  ///
  /// [dt] es el tiempo transcurrido desde el último fotograma en segundos.
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return; // Si el movimiento no está habilitado, no se actualiza.

    // Mueve a Ash horizontalmente según la dirección y la velocidad.
    position.x += direccion.x * velocidad * dt;

    // Aplica la gravedad si Ash está en el aire.
    if (enElAire) {
      velocidadVertical += gravedad * dt; // Acelera la velocidad vertical debido a la gravedad.
      position.y += velocidadVertical * dt; // Actualiza la posición vertical.
    }

    // Si Ash cae por debajo del límite inferior de la pantalla, activa el Game Over.
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    // Actualiza la animación de Ash basándose en su estado actual (movimiento, salto).
    actualizarAnimacion();
  }

  /// [actualizarAnimacion] cambia la animación de Ash ([animacionCaminando],
  /// [animacionSaltando], [animacionQuieto]) y voltea el sprite
  /// horizontalmente si la dirección de movimiento cambia.
  void actualizarAnimacion() {
    if (enElAire) {
      animation = animacionSaltando; // Animación de salto si está en el aire.
    } else if (direccion.x != 0) {
      animation = animacionCaminando; // Animación de caminata si se está moviendo horizontalmente.
      playing = true; // Asegura que la animación esté reproduciéndose.
    } else {
      animation = animacionQuieto; // Animación de quieto si no se mueve y no está en el aire.
      playing = false; // Detiene la reproducción de la animación.
      animationTicker?.reset(); // Reinicia el ticker de animación para mostrar el primer frame.
    }

    // Voltea el sprite horizontalmente para que Ash mire en la dirección de su movimiento.
    if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    } else if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    }
  }

  @override
  /// [onKeyEvent] es el método callback para manejar eventos de teclado.
  ///
  /// Responde a las pulsaciones de las teclas 'A' (izquierda), 'D' (derecha)
  /// y 'Espacio' (salto) para controlar el movimiento de Ash.
  ///
  /// [event] es el evento de teclado.
  /// [teclasPresionadas] es el conjunto de todas las teclas que están actualmente presionadas.
  /// Retorna `true` si el evento fue manejado, `false` para que se propague.
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true; // Si el movimiento está deshabilitado, no procesa el evento.

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1; // Establece la dirección a la izquierda.
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1; // Establece la dirección a la derecha.
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        iniciarSalto(); // Llama a la función de salto.
      }
    }

    if (event is KeyUpEvent) {
      // Detiene el movimiento horizontal si se suelta la tecla correspondiente.
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
        direccion.x = 0;
      }
    }

    return true; // Indica que el evento de teclado ha sido procesado.
  }

  @override
  /// [onCollision] es el método callback que se invoca cuando Ash colisiona con otro componente.
  ///
  /// Se utiliza para gestionar las interacciones de Ash con las plataformas,
  /// asegurando que aterrice correctamente y detenga su caída.
  ///
  /// [intersectionPoints] son los puntos donde las hitboxes se superponen.
  /// [other] es el otro componente con el que Ash ha colisionado.
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColisionPlataforma) {
      // Si Ash colisiona con una plataforma y está cayendo (velocidadVertical > 0)
      // y estaba en el aire, significa que ha aterrizado en la plataforma.
      if (velocidadVertical > 0 && enElAire) {
        if (kDebugMode) {
          print("Ash ha tocado el suelo"); // Mensaje de depuración.
        }

        // Ajusta la posición de Ash para que quede justo encima de la plataforma,
        // evitando que se "hunda" o rebote.
        // Se obtiene la hitbox de la plataforma para un ajuste más preciso.
        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        // Ajuste fino de la posición Y para asegurar que Ash esté firmemente sobre la plataforma.
        position.y = other.position.y - size.y + hitbox.position.y + 50;

        velocidadVertical = 0; // Detiene la velocidad vertical.
        enElAire = false; // Ash ya no está en el aire.
      }
    }
  }

  @override
  /// [onCollisionEnd] es el método callback que se invoca cuando Ash deja de
  /// colisionar con otro componente.
  ///
  /// Se utiliza para detectar cuando Ash deja de estar en contacto con una
  /// plataforma, lo que indica que vuelve a estar en el aire (cayendo).
  ///
  /// [other] es el componente con el que Ash ha dejado de colisionar.
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      enElAire = true; // Ash vuelve a estar en el aire una vez que deja la plataforma.
      if (kDebugMode) {
        print("Ash dejó de estar en contacto con la plataforma."); // Mensaje de depuración.
      }
    }
  }
}