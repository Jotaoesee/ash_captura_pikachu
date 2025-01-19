import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import '../Games/ash_captura_pikachu.dart';

// Clase que representa al jugador "Ash" en el juego
class AshPlayer extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, KeyboardHandler {
  // Velocidad de movimiento horizontal
  double velocidad = 150;

  // Dirección del movimiento en el eje X (-1: izquierda, 1: derecha, 0: sin movimiento)
  Vector2 direccion = Vector2.zero();

  // Velocidad inicial del salto
  double velocidadSalto = -300;

  // Gravedad que afecta al jugador, incrementa la velocidad de caída
  double gravedad = 500;

  // Posición inicial del suelo donde el jugador debe estar parado
  double posicionSueloInicial = 0;

  // Estado del salto (true si está en el aire, false si está en el suelo)
  bool enElAire = false;

  // Velocidad vertical actual del jugador (positiva para caer, negativa para subir)
  double velocidadVertical = 0;

  // Animación para el movimiento caminando
  late SpriteAnimation animacionCaminando;

  // Animación para el estado de salto
  late SpriteAnimation animacionSaltando;

  // Animación para el estado quieto (sin movimiento)
  late SpriteAnimation animacionQuieto;

  // Indica si el personaje está mirando hacia la izquierda
  bool mirandoIzquierda = false;

  // Constructor que inicializa la posición del jugador
  AshPlayer({required Vector2 position})
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y;
  }

  // Método que se ejecuta al cargar el jugador, inicializa las animaciones
  @override
  Future<void> onLoad() async {
    // Cargar la imagen del sprite del jugador
    await game.images.load('AshAndando.png');

    // Crear la animación para caminar
    animacionCaminando = SpriteAnimation.fromFrameData(
      game.images.fromCache('AshAndando.png'),
      SpriteAnimationData.sequenced(
        amount: 4, // Número de fotogramas
        textureSize: Vector2.all(64), // Tamaño de cada fotograma
        stepTime: 0.12, // Tiempo entre fotogramas
      ),
    );

    // Crear la animación para saltar (por ahora reutiliza la de caminar)
    animacionSaltando = animacionCaminando;

    // Crear la animación para estar quieto (primer fotograma de la animación)
    animacionQuieto = SpriteAnimation.fromFrameData(
      game.images.fromCache('AshAndando.png'),
      SpriteAnimationData.sequenced(
        amount: 1, // Solo un fotograma
        textureSize: Vector2.all(64),
        stepTime: 0.1,
      ),
    );

    // Establecer la animación inicial como la de caminar
    animation = animacionCaminando;
    playing = true;
  }

  // Método que inicia el salto del jugador
  void iniciarSalto() {
    // Solo puede saltar si no está ya en el aire
    if (!enElAire) {
      enElAire = true;
      velocidadVertical = velocidadSalto; // Aplicar la velocidad inicial del salto
    }
  }

  // Método que se ejecuta en cada frame para actualizar el estado del jugador
  @override
  void update(double dt) {
    super.update(dt);

    // Limitar el tiempo delta para evitar grandes saltos en la simulación
    dt = dt.clamp(0, 0.016);

    // Actualizar la posición horizontal según la dirección y velocidad
    position.x += direccion.x * velocidad * dt;

    // Lógica del salto y la gravedad
    if (enElAire) {
      velocidadVertical += gravedad * dt; // Incrementar la velocidad vertical por gravedad
      position.y += velocidadVertical * dt; // Actualizar la posición vertical

      // Verificar si el jugador ha aterrizado
      if (position.y >= posicionSueloInicial) {
        position.y = posicionSueloInicial; // Corregir la posición al nivel del suelo
        enElAire = false; // Marcar que ya no está en el aire
        velocidadVertical = 0; // Restablecer la velocidad vertical
      }
    }

    // Cambiar la animación según el estado del jugador
    if (enElAire) {
      animation = animacionSaltando; // Usar animación de salto si está en el aire
    } else if (direccion.x != 0) {
      animation = animacionCaminando; // Usar animación de caminar si está en movimiento
      playing = true;
    } else {
      animation = animacionQuieto; // Usar animación de quieto si no se mueve
      playing = false;
      animationTicker?.reset(); // Reiniciar la animación
    }

    // Voltear el sprite si cambia la dirección del movimiento
    if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = true;
    } else if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally();
      mirandoIzquierda = false;
    }
  }

  // Método para manejar eventos de teclado
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    // Detectar teclas presionadas
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1; // Mover hacia la izquierda
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1; // Mover hacia la derecha
      }
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        iniciarSalto(); // Iniciar el salto
      }
    } else if (event is KeyUpEvent) {
      // Detectar teclas soltadas
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x = 0; // Detener movimiento hacia la izquierda
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
        direccion.x = 0; // Detener movimiento hacia la derecha
      }
    }
    return super.onKeyEvent(event, teclasPresionadas);
  }
}
