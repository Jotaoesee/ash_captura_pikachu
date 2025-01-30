import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';

import '../Games/ash_captura_pikachu.dart';

/// Clase que representa a Ash en el juego.
class Ash extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>,
        KeyboardHandler,
        CollisionCallbacks {
  // Propiedades relacionadas con el movimiento de Ash
  double velocidad = 150; // Velocidad horizontal en píxeles por segundo
  Vector2 direccion = Vector2
      .zero(); // Dirección del movimiento (-1: izquierda, 1: derecha, 0: sin movimiento)
  double velocidadSalto =
      -308; // Velocidad inicial del salto (negativo porque va hacia arriba)
  double gravedad = 500; // Valor de la gravedad aplicada a Ash
  bool enElAire = false; // Indica si el personaje está en el aire o en el suelo
  double velocidadVertical = 0; // Velocidad de caída
  bool _movimientoHabilitado = false; // Determina si Ash puede moverse o no

  // Animaciones del personaje
  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  late SpriteAnimation animacionQuieto;
  bool mirandoIzquierda =
      false; // Indica si Ash está mirando hacia la izquierda

  /// Constructor de Ash
  Ash({required Vector2 position, bool movimientoHabilitado = false})
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    _movimientoHabilitado = movimientoHabilitado;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      // Cargar animaciones de Ash desde la imagen en caché
      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(64),
          stepTime: 0.12,
        ),
      );

      // La animación de salto es la misma que la de caminata en este caso
      animacionSaltando = animacionCaminando;

      // Animación cuando Ash está quieto
      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(64),
          stepTime: 0.1,
        ),
      );

      // Inicialmente, Ash estará en la animación de quieto
      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Ash: $e');
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

  /// Habilita el movimiento de Ash
  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  /// Activa o desactiva el movimiento de Ash
  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  /// Lógica para que Ash salte
  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return;
    enElAire = true;
    velocidadVertical = velocidadSalto;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return;

    // Mover horizontalmente a Ash en función de la dirección
    position.x += direccion.x * velocidad * dt;

    // Aplicar gravedad y actualizar la posición en Y
    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;
    }

    // Si Ash cae fuera de la pantalla, se activa el Game Over
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    // Actualizar la animación según el estado de Ash
    actualizarAnimacion();
  }

  /// Cambia la animación de Ash según su estado actual
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
    if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    } else if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    }
  }

  /// Manejo de eventos de teclado para mover a Ash
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1; // Mover a la izquierda
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1; // Mover a la derecha
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        iniciarSalto(); // Saltar
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x =
            0; // Detener el movimiento si se suelta la tecla izquierda
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
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
          print("Ash ha tocado el suelo");
        }

        // Ajustar la posición para evitar rebotes y asegurar que Ash esté sobre la plataforma
        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        position.y = other.position.y - size.y + hitbox.position.y + 50;

        // Detener la caída
        velocidadVertical = 0;
        enElAire = false;
      }
    }
  }

  /// Detecta cuando Ash deja de estar en contacto con una plataforma
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      enElAire = true;
      if (kDebugMode) {
        print("Ash dejó de estar en contacto con la plataforma.");
      }
    }
  }
}
