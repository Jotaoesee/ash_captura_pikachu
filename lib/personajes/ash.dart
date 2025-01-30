import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';

import '../Games/ash_captura_pikachu.dart';

class Ash extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>,
        KeyboardHandler,
        CollisionCallbacks {
  double velocidad = 150;
  Vector2 direccion = Vector2.zero();
  double velocidadSalto = -300;
  double gravedad = 500;
  bool enElAire = false;
  double velocidadVertical = 0;
  bool _movimientoHabilitado = false;

  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  late SpriteAnimation animacionQuieto;
  bool mirandoIzquierda = false;

  Ash({required Vector2 position, bool movimientoHabilitado = false})
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    _movimientoHabilitado = movimientoHabilitado;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      animacionCaminando = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(64),
          stepTime: 0.12,
        ),
      );

      animacionSaltando = animacionCaminando;

      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(64),
          stepTime: 0.1,
        ),
      );

      animation = animacionQuieto;
      playing = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Ash: $e');
      }
      rethrow;
    }

    add(RectangleHitbox(
      size: Vector2(32, 50),
      position: Vector2(18, 1),
      collisionType: CollisionType.active,
    )..debugColor = const Color(0xFF0033FF));
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

    position.x += direccion.x * velocidad * dt;

    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;
    }

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

    if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    } else if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1;
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1;
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        iniciarSalto();
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
        direccion.x = 0;
      }
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColisionPlataforma) {
      if (velocidadVertical > 0 && enElAire) {
        print("✅ Ash ha tocado el suelo");

        final hitbox = other.children.firstWhere((c) => c is RectangleHitbox)
            as RectangleHitbox;
        position.y = other.position.y - size.y + hitbox.position.y + 50;

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
      print("🔺 Ash dejó de estar en contacto con la plataforma.");
    }
  }
}
