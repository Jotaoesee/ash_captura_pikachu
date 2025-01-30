import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../Games/ash_captura_pikachu.dart';
import '../colisiones/colision_plataforma.dart';

/// Clase que representa a Maya en el juego.
class Maya extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>,
        KeyboardHandler,
        CollisionCallbacks {
  // Propiedades relacionadas con el movimiento de Maya
  double velocidad = 150; // Velocidad horizontal en píxeles por segundo
  Vector2 direccion = Vector2
      .zero(); // Dirección del movimiento (-1: izquierda, 1: derecha, 0: sin movimiento)
  double velocidadSalto =
      -308; // Velocidad inicial del salto (negativo porque va hacia arriba)
  double gravedad = 500; // Valor de la gravedad aplicada a Maya
  late double posicionSueloInicial; // Guarda la posición en Y donde Maya inicia
  bool enElAire = false; // Indica si el personaje está en el aire o en el suelo
  double velocidadVertical = 0; // Velocidad de caída
  late bool _movimientoHabilitado; // Determina si Maya puede moverse o no

  // Animaciones del personaje
  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  late SpriteAnimation animacionQuieto;
  bool mirandoIzquierda =
      false; // Indica si Maya está mirando hacia la izquierda

  /// Constructor de Maya
  Maya({
    required Vector2 position,
    bool movimientoHabilitado = false,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y;
    _movimientoHabilitado = movimientoHabilitado;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      // Cargar la imagen de Maya en caché para las animaciones
      await game.images.load('Maya.png');

      // Animación de caminata
      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(64),
          stepTime: 0.12,
        ),
      );

      // La animación de salto es la misma que la de caminata en este caso
      animacionSaltando = animacionCaminando;

      // Animación cuando Maya está quieta
      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(64),
          stepTime: 0.1,
        ),
      );

      // Inicialmente, Maya estará en la animación de quieto
      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Maya: $e');
      }
      rethrow;
    }

    // Agregar una hitbox para detectar colisiones
    add(RectangleHitbox(
      size: Vector2(32, 50), // Tamaño de la hitbox
      position: Vector2(18, 1), // Ajuste de posición dentro del sprite
      collisionType: CollisionType.active, // Tipo de colisión
    ));
  }

  /// Habilita el movimiento de Maya
  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  /// Activa o desactiva el movimiento de Maya
  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  /// Lógica para que Maya salte
  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return;
    enElAire = true;
    velocidadVertical = velocidadSalto;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return;

    // Mover horizontalmente a Maya en función de la dirección
    position.x += direccion.x * velocidad * dt;

    // Aplicar gravedad y actualizar la posición en Y
    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;
    }

    // Si Maya cae fuera de la pantalla, se activa el Game Over
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    // Actualizar la animación según el estado de Maya
    actualizarAnimacion();
  }

  /// Cambia la animación de Maya según su estado actual
  void actualizarAnimacion() {
    if (enElAire) {
      animation = animacionSaltando;
    } else if (direccion.x != 0) {
      animation = animacionCaminando;
      playing = true;
    } else {
      animation = animacionQuieto;
      playing = false;
      animationTicker?.reset();
    }

    // Voltear la imagen si cambia la dirección del movimiento
    if (direccion.x > 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    } else if (direccion.x < 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    }
  }

  /// Manejo de eventos de teclado para mover a Maya
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowLeft)) {
        direccion.x = -1; // Mover a la izquierda
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowRight)) {
        direccion.x = 1; // Mover a la derecha
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.numpadDecimal)) {
        iniciarSalto(); // Saltar
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && direccion.x < 0) {
        direccion.x =
            0; // Detener el movimiento si se suelta la tecla izquierda
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          direccion.x > 0) {
        direccion.x = 0; // Detener el movimiento si se suelta la tecla derecha
      }
    }

    return true;
  }

  /// Manejo de colisiones con plataformas
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColisionPlataforma) {
      // Solo si está cayendo y choca con la plataforma
      if (velocidadVertical > 0 && enElAire) {
        if (kDebugMode) {
          print("Maya ha tocado el suelo");
        }

        // Ajustar la posición para evitar rebotes y asegurar que Maya esté sobre la plataforma
        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        position.y = other.position.y - size.y + hitbox.position.y + 50;

        // Detener la caída
        velocidadVertical = 0;
        enElAire = false;
      }
    }
  }

  /// Detecta cuando Maya deja de estar en contacto con una plataforma
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      enElAire = true;
      if (kDebugMode) {
        print("Maya dejó de estar en contacto con la plataforma.");
      }
    }
  }
}
