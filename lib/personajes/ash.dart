import 'package:ash_captura_pikachu/personajes/pikachu.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import '../Games/ash_captura_pikachu.dart';

class Ash extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>,
        KeyboardHandler,
        CollisionCallbacks {
  final Vector2 velocidad = Vector2.zero();
  Vector2 direccion = Vector2.zero();
  bool enElSuelo = false;
  double velocidadSalto = -300;
  double gravedad = 500;
  late double posicionSueloInicial;
  bool enElAire = false;
  double velocidadVertical = 0;
  bool _movimientoHabilitado = false;
  final double aceleracion = 200;

  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  late SpriteAnimation animacionQuieto;
  bool mirandoIzquierda = false;

  bool get estaHabilitado => _movimientoHabilitado;

  Ash({
    required Vector2 position,
    bool movimientoHabilitado = false,
  }) : super(size: Vector2(64, 64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y;
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

      final hitboxWidth = 32.0;
      final hitboxHeight = 50.0;
      final hitboxPosition = Vector2(16.0, 1.0);

      final hitbox = RectangleHitbox(
        size: Vector2(hitboxWidth, hitboxHeight),
        position: hitboxPosition,
        collisionType: CollisionType.active,
      )..debugMode = true;

      add(hitbox);

      if (kDebugMode) {
        print(
            'Hitbox añadido: tamaño=$hitboxWidth x $hitboxHeight, posición=$hitboxPosition');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Ash: $e');
      }
      rethrow;
    }
  }

  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_movimientoHabilitado) {
      velocidad.x = direccion.x.clamp(-1, 1) * aceleracion;

      if (enElSuelo) {
        velocidad.y = 0;
        if (velocidad.x != 0) {
          animation = animacionCaminando; // Cambiar a animación de caminar
          playing = true;
        } else {
          animation = animacionQuieto; // Cambiar a animación de estar quieto
          playing = false;
        }
      } else {
        velocidad.y += gravedad * dt;

        if (velocidad.y.isFinite) {
          velocidad.y =
              velocidad.y.clamp(-velocidadSalto.abs(), velocidadSalto.abs());
        } else {
          velocidad.y = 0;
        }

        animation = animacionSaltando; // Cambiar a animación de saltar
        playing = true;
      }

      // Aplicar la velocidad a la posición
      position += velocidad * dt;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        direccion.x = -1; // Mover a la izquierda
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        direccion.x = 1; // Mover a la derecha
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        if (enElSuelo) {
          velocidad.y = velocidadSalto; // Saltar
          enElSuelo = false;
        }
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        direccion.x = 0; // Detener el movimiento
      }
    }
    return true;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is RectangleHitbox) {
      enElSuelo = true;
      velocidad.y = 0;
    } else if (other is Pikachu) {
      print('Ash ha capturado un Pikachu!');
      // Lógica para capturar un Pikachu
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is RectangleHitbox) {
      enElSuelo = false;
    }
  }
}
