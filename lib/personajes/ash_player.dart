import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../Games/ash_captura_pikachu.dart';

/// Clase que representa al personaje principal (Ash) en el juego.
/// Esta clase maneja animaciones, movimiento y la interacción con el teclado.
class AshPlayer extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, KeyboardHandler {
  // Propiedades relacionadas con el movimiento
  double velocidad = 150; // Velocidad horizontal en píxeles por segundo
  Vector2 direccion = Vector2.zero(); // Dirección del movimiento (-1, 0, 1)
  double velocidadSalto =
      -300; // Velocidad inicial del salto en píxeles por segundo
  double gravedad = 500; // Fuerza gravitacional que afecta al personaje
  double posicionSueloInicial = 0; // Posición Y inicial del suelo
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
  AshPlayer({
    required Vector2 position,
    bool movimientoHabilitado = false,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y;
    _movimientoHabilitado = movimientoHabilitado;
  }

  /// Habilita o deshabilita el movimiento del personaje.
  void habilitarMovimiento(bool enabled) {
    if (_movimientoHabilitado == enabled) return; // Evitar redundancia

    _movimientoHabilitado = enabled;
    print('Movimiento habilitado: $_movimientoHabilitado');
    if (!enabled) {
      resetearEstado(); // Restablecer estado si se desactiva
    }
  }

  /// Reinicia las propiedades del personaje a su estado inicial.
  void resetearEstado() {
    direccion = Vector2.zero();
    velocidadVertical = 0;
    enElAire = false;
    position.y = posicionSueloInicial;
    animation = animacionQuieto;
    playing = false;
    animationTicker?.reset();
  }

  /// Carga las animaciones necesarias para el personaje.
  @override
  Future<void> onLoad() async {
    try {
      await game.images.load('AshAndando.png');

      // Configurar la animación al caminar
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
      print('Error cargando animaciones de Ash: $e');
      rethrow; // Repropagar el error para manejarlo más arriba
    }
  }

  /// Activa el movimiento del personaje al iniciar el juego.
  void iniciarJuego() {
    habilitarMovimiento(true);
  }

  /// Inicia el salto del personaje si está habilitado y no está en el aire.
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

    // Limitar el tiempo de actualización para evitar movimientos bruscos
    dt = dt.clamp(0, 0.016);

    // Actualizar posición horizontal
    position.x += direccion.x * velocidad * dt;

    // Manejar salto y gravedad
    if (enElAire) {
      velocidadVertical += gravedad * dt;
      position.y += velocidadVertical * dt;

      // Detener caída cuando toca el suelo
      if (position.y >= posicionSueloInicial) {
        position.y = posicionSueloInicial;
        enElAire = false;
        velocidadVertical = 0;
      }
    }

    // Actualizar la animación según el estado actual
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
    if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    } else if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    }
  }

  /// Maneja eventos del teclado para mover al personaje.
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (!_movimientoHabilitado) return true;

    // Eventos de tecla presionada o mantenida
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
    } else if (event is KeyUpEvent) {
      // Eventos de tecla soltada
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
        direccion.x = 0;
      }
    }

    return true;
  }
}
