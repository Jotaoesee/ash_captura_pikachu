import 'package:ash_captura_pikachu/colisiones/colision_plataforma.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';

import '../Games/ash_captura_pikachu.dart';

/// Clase que representa al personaje principal (Ash) en el juego.
/// Esta clase maneja animaciones, movimiento y la interacción con el teclado.
class Ash extends SpriteAnimationComponent
    with
        HasGameReference<AshCapturaPikachu>,
        KeyboardHandler,
        CollisionCallbacks {
  // Propiedades relacionadas con el movimiento
  double velocidad = 150; // Velocidad horizontal en píxeles por segundo
  Vector2 direccion = Vector2.zero(); // Dirección del movimiento (-1, 0, 1)
  double velocidadSalto =
      -300; // Velocidad inicial del salto en píxeles por segundo
  double gravedad = 500; // Fuerza gravitacional que afecta al personaje
  late double posicionSueloInicial; // Posición Y inicial del suelo
  bool enElAire = false; // Indica si el personaje está saltando
  double velocidadVertical = 0; // Velocidad vertical durante el salto/caída
  bool _movimientoHabilitado = false; // Controla si el movimiento está activo

  // Animaciones del personaje
  late SpriteAnimation animacionCaminando; // Animación al caminar
  late SpriteAnimation animacionSaltando; // Animación al saltar
  late SpriteAnimation animacionQuieto; // Animación cuando está quieto
  bool mirandoIzquierda = false; // Controla la dirección en que mira el sprite

  /// Getter para verificar si el movimiento está habilitado.
  bool get estaHabilitado => _movimientoHabilitado;

  /// Constructor de la clase.
  Ash({
    required Vector2 position,
    bool movimientoHabilitado = false,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
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

      // Usar la misma animación para saltar (puedes cambiar esto si tienes una animación específica)
      animacionSaltando = animacionCaminando;

      // Configurar la animación cuando está quieto
      animacionQuieto = SpriteAnimation.fromFrameData(
        game.images.fromCache('AshAndando.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(64),
          stepTime: 0.1,
        ),
      );

      animation = animacionQuieto; // Animación inicial
      playing = false; // No reproducir la animación por defecto
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando animaciones de Ash: $e');
      }
      rethrow; // Repropagar el error para manejarlo más arriba
    }

    final hitboxWidth = 32.0; // Ancho fijo en píxeles
    final hitboxHeight = 50.0; // Altura fija en píxeles
    final hitboxPosition =
        Vector2(18.0, 1.0); // Ajustes manuales para la posición

    // Añadir la hitbox personalizada
    add(RectangleHitbox(
      size: Vector2(hitboxWidth, hitboxHeight), // Tamaño de la hitbox
      position: hitboxPosition, // Posición relativa al sprite
      collisionType: CollisionType.active,
    )..debugColor =
        const Color(0xFF0033FF)); // Activa depuración para ver hitboxes
  }

  /// Activa el movimiento del personaje al iniciar el juego.
  void iniciarJuego() {
    _movimientoHabilitado = true;
  }

  /// Habilita o deshabilita el movimiento del personaje.
  void habilitarMovimiento(bool habilitado) {
    _movimientoHabilitado = habilitado;
  }

  /// Inicia el salto del personaje si no está en el aire.
  void iniciarSalto() {
    if (!_movimientoHabilitado || enElAire) return;

    enElAire = true;
    velocidadVertical = velocidadSalto;
  }

  /// Actualiza el estado del personaje en cada frame.
  @override
  void update(double dt) {
    super.update(dt);

    if (!_movimientoHabilitado) return;

    // Asegurar que la gravedad se aplique desde el inicio
    if (!enElAire) {
      enElAire = true;
    }

    // Aplicar gravedad solo cuando está en el aire
    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;
    }

    // Mover en el eje X
    position.x += direccion.x * velocidad * dt;

    // Si Ash cae fuera de la pantalla, activar Game Over
    if (position.y > game.size.y) {
      game.mostrarGameOver();
    }

    actualizarAnimacion();
  }

  /// Cambia la animación según el estado actual del personaje.
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

    // Cambiar la dirección del sprite al moverse
    if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally(); // Voltear a la derecha
      mirandoIzquierda = false;
    } else if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally(); // Voltear a la izquierda
      mirandoIzquierda = true;
    }
  }

  /// Maneja eventos del teclado para mover a Maya.
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
        iniciarSalto(); // Saltar con el espacio
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

    print("🎮 Movimiento: ${direccion.x}, Salto: ${enElAire}");
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColisionPlataforma) {
      print(
          "🔹 Ash ha colisionado con una plataforma en y: ${other.position.y}");

      // Obtener la posición superior de la plataforma
      double plataformaTop = other.position.y;
      double ashBottom = position.y + size.y / 2;

      // Verificar si Ash está cayendo y toca la parte superior de la plataforma
      if (velocidadVertical > 0 && ashBottom >= plataformaTop - 5) {
        position.y =
            plataformaTop - size.y / 2; // Ajustarlo sobre la plataforma
        velocidadVertical = 0; // Detener la velocidad de caída
        enElAire = false; // Indicar que está en el suelo
        print("✅ Ash aterrizó en la plataforma en y: ${position.y}");
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is ColisionPlataforma) {
      // Si deja de colisionar con una plataforma, vuelve a estar en el aire
      enElAire = true;
      print(
          "🔺 Ash dejó de estar en contacto con la plataforma, vuelve a caer.");
    }
  }
}
