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
  // Propiedades relacionadas con el movimiento
  double velocidad = 150; // Velocidad horizontal en píxeles por segundo
  Vector2 direccion = Vector2.zero(); // Dirección del movimiento (-1, 0, 1)
  double velocidadSalto = -308; // Velocidad inicial del salto
  double gravedad = 500; // Fuerza gravitacional
  late double posicionSueloInicial; // Posición Y del suelo
  bool enElAire = false; // Indica si el personaje está en el aire
  double velocidadVertical = 0; // Velocidad de caída
  late bool _movimientoHabilitado; // Controla si el movimiento está activo

  // Animaciones
  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  late SpriteAnimation animacionQuieto;
  bool mirandoIzquierda = false; // Dirección en que mira Maya

  /// Constructor
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
      await game.images.load('Maya.png');

      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
            amount: 4, textureSize: Vector2.all(64), stepTime: 0.12),
      );

      animacionSaltando = animacionCaminando;

      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('Maya.png'),
        SpriteAnimationData.sequenced(
            amount: 1, textureSize: Vector2.all(64), stepTime: 0.1),
      );

      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Maya: $e');
      }
      rethrow;
    }

    // Añadir hitbox de Maya
    add(RectangleHitbox(
      size: Vector2(32, 50),
      position: Vector2(18, 1),
      collisionType: CollisionType.active,
    ));
  }

  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return;

    enElAire = true;
    velocidadVertical = velocidadSalto;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return;

    // Aplicar movimiento horizontal
    position.x += direccion.x * velocidad * dt;

    // Aplicar gravedad
    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;
    }

    // Si Maya cae fuera de la pantalla, activar Game Over
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    actualizarAnimacion();
  }

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

    // Voltear la dirección del sprite
    if (direccion.x > 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    } else if (direccion.x < 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowLeft)) {
        direccion.x = -1;
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.arrowRight)) {
        direccion.x = 1;
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.numpadDecimal)) {
        iniciarSalto();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          direccion.x > 0) {
        direccion.x = 0;
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
        print("✅ Maya ha tocado el suelo");

        // Ajustar la posición para evitar rebotes
        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        position.y = other.position.y - size.y + hitbox.position.y + 50;

        // Detener la caída
        velocidadVertical = 0;
        enElAire = false;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      enElAire = true;
      print("🔺 Maya dejó de estar en contacto con la plataforma.");
    }
  }
}
