import 'package:flame/components.dart'; // Componentes base de Flame.
import 'package:flame/collisions.dart'; // Para el manejo de colisiones.
import 'package:flutter/foundation.dart'; // Para kDebugMode (modo de depuración).
import 'package:flutter/services.dart'; // Para LogicalKeyboardKey (manejo de teclado).

import '../Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder a sus propiedades (ej. game over).
import '../colisiones/colision_plataforma.dart'; // Importa la clase de plataforma para colisiones.

/// [Maya] es un componente de juego que representa al personaje de Maya.
///
/// Extiende [SpriteAnimationComponent] para manejar animaciones,
/// mezcla [HasGameReference] para acceder a la instancia del juego principal,
/// [KeyboardHandler] para gestionar la entrada del teclado, y
/// [CollisionCallbacks] para detectar y responder a colisiones con otros componentes.
/// Maya se controla con las flechas del teclado y la tecla de punto decimal del teclado numérico.
class Maya extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>, // Permite acceder a la instancia de `AshCapturaPikachu`.
        KeyboardHandler, // Habilita la detección de eventos de teclado.
        CollisionCallbacks {
  // --- Propiedades de Movimiento y Física ---

  /// Velocidad horizontal de Maya en píxeles por segundo.
  double velocidad = 150;

  /// Dirección actual del movimiento horizontal de Maya.
  /// - `Vector2(-1, 0)` para izquierda, `Vector2(1, 0)` para derecha, `Vector2.zero()` para quieto.
  Vector2 direccion = Vector2.zero();

  /// Velocidad inicial aplicada al personaje al saltar.
  /// Es negativa porque en Flame, el eje Y positivo va hacia abajo.
  double velocidadSalto = -308;

  /// Valor de la gravedad que afecta a Maya, en píxeles/segundo².
  double gravedad = 500;

  /// Posición inicial en el eje Y donde Maya comenzó (para referencia).
  late double posicionSueloInicial;

  /// Bandera que indica si Maya está actualmente en el aire (saltando o cayendo).
  bool enElAire = false;

  /// Velocidad vertical actual de Maya, afectada por la gravedad y los saltos.
  double velocidadVertical = 0;

  /// Bandera que controla si el movimiento de Maya está habilitado.
  /// Esto es útil para pausas o menús de inicio/fin de juego.
  late bool _movimientoHabilitado;

  // --- Propiedades de Animación ---

  /// Animación de Maya cuando está caminando.
  late SpriteAnimation animacionCaminando;

  /// Animación de Maya cuando está saltando.
  late SpriteAnimation animacionSaltando;

  /// Animación de Maya cuando está quieta.
  late SpriteAnimation animacionQuieto;

  /// Bandera que indica si Maya está mirando hacia la izquierda (sprite volteado horizontalmente).
  bool mirandoIzquierda = false;

  /// Constructor de la clase [Maya].
  ///
  /// Recibe la [position] inicial de Maya en el mundo del juego y un valor
  /// opcional para [movimientoHabilitado] que determina si puede moverse al inicio.
  Maya({
    required Vector2 position,
    bool movimientoHabilitado = false,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y; // Guarda la posición inicial Y.
    _movimientoHabilitado = movimientoHabilitado;
  }

  @override
  /// Método [onLoad] que se llama una vez cuando el componente Maya se añade al árbol de componentes.
  ///
  /// En este método asíncrono se cargan y configuran todas las animaciones
  /// de Maya, y se añade su [RectangleHitbox] para la detección de colisiones.
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      // Cargar la imagen de Maya en el caché de Flame.
      await game.images.load('Maya.png');

      // Cargar animación de caminata de Maya desde la imagen en caché.
      // Se asume que 'Maya.png' contiene una secuencia de 4 sprites de 64x64.
      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
          amount: 4, // Número de frames en la animación.
          textureSize: Vector2.all(64), // Tamaño de cada frame en la imagen.
          stepTime: 0.12, // Duración de cada frame (para una animación fluida).
        ),
      );

      // En este caso, la animación de salto es la misma que la de caminata.
      animacionSaltando = animacionCaminando;

      // Animación de Maya cuando está quieta (un solo frame de la secuencia).
      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
          amount: 1, // Un solo frame.
          textureSize: Vector2.all(64),
          stepTime: 0.1,
        ),
      );

      // Establece la animación inicial de Maya a "quieto" y detiene la reproducción.
      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Maya: $e'); // Mensaje de error en modo depuración.
      }
      rethrow; // Relanza la excepción para un manejo superior.
    }

    // Agrega una hitbox rectangular a Maya para la detección de colisiones.
    // El tamaño y la posición se ajustan para que la hitbox sea más precisa
    // al cuerpo de Maya y no ocupe todo el sprite.
    add(RectangleHitbox(
      size: Vector2(32, 50), // Tamaño de la hitbox (más pequeño que el sprite completo).
      position: Vector2(18, 1), // Ajuste de la posición de la hitbox relativa al sprite.
      collisionType: CollisionType.active, // Tipo de colisión activa (participa en la física).
    ));
  }

  /// Habilita explícitamente el movimiento de Maya.
  ///
  /// Este método es útil para iniciar el control del jugador después de un menú
  /// de inicio o una secuencia introductoria.
  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  /// Activa o desactiva la capacidad de movimiento de Maya.
  ///
  /// [habilitado] es `true` para permitir el movimiento, `false` para deshabilitarlo.
  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  /// Inicia el salto de Maya.
  ///
  /// Solo se puede saltar si el movimiento está habilitado y Maya no está ya en el aire.
  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return; // No saltar si está deshabilitado o ya en el aire.
    enElAire = true; // Marca a Maya como "en el aire".
    velocidadVertical = velocidadSalto; // Establece la velocidad vertical inicial para el salto.
  }

  @override
  /// [update] es el método principal de actualización del componente, llamado en cada fotograma.
  ///
  /// Contiene la lógica para el movimiento horizontal, la aplicación de la gravedad,
  /// la detección de la caída fuera de los límites del juego y la actualización
  /// de la animación de Maya.
  ///
  /// [dt] es el tiempo transcurrido desde el último fotograma en segundos.
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return; // Si el movimiento no está habilitado, no se actualiza.

    // Mueve a Maya horizontalmente según la dirección y la velocidad.
    position.x += direccion.x * velocidad * dt;

    // Aplica la gravedad si Maya está en el aire.
    if (enElAire) {
      velocidadVertical += gravedad * dt; // Acelera la velocidad vertical debido a la gravedad.
      position.y += velocidadVertical * dt; // Actualiza la posición vertical.
    }

    // Si Maya cae por debajo del límite inferior de la pantalla, activa el Game Over.
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    // Actualiza la animación de Maya basándose en su estado actual (movimiento, salto).
    actualizarAnimacion();
  }

  /// [actualizarAnimacion] cambia la animación de Maya ([animacionCaminando],
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

    // Voltea el sprite horizontalmente para que Maya mire en la dirección de su movimiento.
    // Maya tiene una lógica de volteo inversa a Ash (por ejemplo, si el sprite original mira a la derecha).
    if (direccion.x > 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    } else if (direccion.x < 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    }
  }

  @override
  /// [onKeyEvent] es el método callback para manejar eventos de teclado.
  ///
  /// Responde a las pulsaciones de las teclas 'Flecha Izquierda' (izquierda),
  /// 'Flecha Derecha' (derecha) y 'NumpadDecimal' (salto) para controlar el
  /// movimiento de Maya.
  ///
  /// [event] es el evento de teclado.
  /// [teclasPresionadas] es el conjunto de todas las teclas que están actualmente presionadas.
  /// Retorna `true` si el evento fue manejado, `false` para que se propague.
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true; // Si el movimiento está deshabilitado, no procesa el evento.

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowLeft)) {
        direccion.x = -1; // Establece la dirección a la izquierda.
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowRight)) {
        direccion.x = 1; // Establece la dirección a la derecha.
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.numpadDecimal)) {
        iniciarSalto(); // Llama a la función de salto.
      }
    } else if (event is KeyUpEvent) {
      // Detiene el movimiento horizontal si se suelta la tecla correspondiente.
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          direccion.x > 0) {
        direccion.x = 0;
      }
    }

    return true; // Indica que el evento de teclado ha sido procesado.
  }

  @override
  /// [onCollision] es el método callback que se invoca cuando Maya colisiona con otro componente.
  ///
  /// Se utiliza para gestionar las interacciones de Maya con las plataformas,
  /// asegurando que aterrice correctamente y detenga su caída.
  ///
  /// [intersectionPoints] son los puntos donde las hitboxes se superponen.
  /// [other] es el otro componente con el que Maya ha colisionado.
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColisionPlataforma) {
      // Si Maya colisiona con una plataforma y está cayendo (velocidadVertical > 0)
      // y estaba en el aire, significa que ha aterrizado en la plataforma.
      if (velocidadVertical > 0 && enElAire) {
        if (kDebugMode) {
          print("Maya ha tocado el suelo"); // Mensaje de depuración.
        }

        // Ajusta la posición de Maya para que quede justo encima de la plataforma,
        // evitando que se "hunda" o rebote.
        // Se obtiene la hitbox de la plataforma para un ajuste más preciso.
        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        // Ajuste fino de la posición Y para asegurar que Maya esté firmemente sobre la plataforma.
        position.y = other.position.y - size.y + hitbox.position.y + 50;

        velocidadVertical = 0; // Detiene la velocidad vertical.
        enElAire = false; // Maya ya no está en el aire.
      }
    }
  }

  @override
  /// [onCollisionEnd] es el método callback que se invoca cuando Maya deja de
  /// colisionar con otro componente.
  ///
  /// Se utiliza para detectar cuando Maya deja de estar en contacto con una
  /// plataforma, lo que indica que vuelve a estar en el aire (cayendo).
  ///
  /// [other] es el componente con el que Maya ha dejado de colisionar.
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      enElAire = true; // Maya vuelve a estar en el aire una vez que deja la plataforma.
      if (kDebugMode) {
        print("Maya dejó de estar en contacto con la plataforma."); // Mensaje de depuración.
      }
    }
  }
}