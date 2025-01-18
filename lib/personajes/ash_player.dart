import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import '../Games/ash_captura_pikachu.dart';

class AshPlayer extends SpriteAnimationComponent
    with HasGameReference<AshCapturaPikachu>, KeyboardHandler {

  // Velocidad de movimiento horizontal del jugador
  double velocidad = 150;

  // Dirección del movimiento (horizontal y vertical)
  Vector2 direccion = Vector2.zero();

  // Parámetros del salto ajustados
  double velocidadSalto = -300; // Velocidad inicial del salto (negativa para que vaya hacia arriba)
  double gravedad = 500; // Gravedad que afecta al jugador (en aumento cada frame)
  double posicionSueloInicial = 0; // Posición de referencia para el suelo
  bool enElAire = false; // Estado del jugador (si está en el aire o no)
  double velocidadVertical = 0; // Velocidad vertical del jugador (usada para el salto y la caída)

  // Animaciones del jugador (caminando y saltando)
  late SpriteAnimation animacionCaminando;
  late SpriteAnimation animacionSaltando;
  bool mirandoIzquierda = false; // Para saber si el jugador está mirando hacia la izquierda

  AshPlayer({
    required Vector2 position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
    this.position = position;
    posicionSueloInicial = position.y; // Establecer la posición inicial del suelo
  }

  @override
  Future<void> onLoad() async {
    // Cargar la imagen de la animación de caminar
    await game.images.load('AshAndando.png');

    // Crear la animación caminando a partir de los fotogramas
    animacionCaminando = SpriteAnimation.fromFrameData(
      game.images.fromCache('AshAndando.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(64),
        stepTime: 0.12,
      ),
    );

    // Usar la misma animación para el salto por ahora (puedes modificar esto)
    animacionSaltando = animacionCaminando;
    animation = animacionCaminando;
    playing = true;
  }

  // Función para iniciar el salto
  void iniciarSalto() {
    if (!enElAire) { // Solo saltar si no estamos ya en el aire
      enElAire = true;
      velocidadVertical = velocidadSalto; // Establecer la velocidad inicial del salto
      print('Iniciando salto desde altura: ${position.y}');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Limitar dt para evitar grandes saltos en bajas tasas de actualización
    dt = dt.clamp(0, 0.016);

    // Actualizar la posición horizontal del jugador según la dirección
    position.x += direccion.x * velocidad * dt;

    // Lógica del salto y la caída del jugador
    if (enElAire) {
      // Aplicar la gravedad a la velocidad vertical
      velocidadVertical += gravedad * dt;

      // Actualizar la posición Y del jugador según la velocidad vertical
      position.y += velocidadVertical * dt;

      // Comprobar si el jugador ha aterrizado
      if (position.y >= posicionSueloInicial) {
        position.y = posicionSueloInicial; // Establecer la posición Y al suelo
        enElAire = false; // El jugador ya no está en el aire
        velocidadVertical = 0; // Detener la velocidad vertical
        print('Aterrizaje en: ${position.y}');
      }
    }

    // Controlar las animaciones según el estado del jugador
    if (enElAire) {
      animation = animacionSaltando; // Usar la animación de salto cuando está en el aire
    } else {
      if (direccion.x != 0) {
        animation = animacionCaminando; // Animación de caminar si se mueve horizontalmente
        playing = true;
      } else {
        animation = animacionCaminando; // Animación de caminar cuando está parado
        playing = false;
        animationTicker?.reset(); // Detener la animación si está parado
      }
    }

    // Actualizar la dirección del sprite (voltear si el jugador cambia de dirección)
    if (direccion.x < 0 && !mirandoIzquierda) {
      flipHorizontally(); // Voltear el sprite horizontalmente cuando va hacia la izquierda
      mirandoIzquierda = true;
    } else if (direccion.x > 0 && mirandoIzquierda) {
      flipHorizontally(); // Voltear el sprite hacia la derecha
      mirandoIzquierda = false;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> teclasPresionadas) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      // Mover hacia la izquierda (tecla A)
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyA)) {
        direccion.x = -1;
      }

      // Mover hacia la derecha (tecla D)
      if (teclasPresionadas.contains(LogicalKeyboardKey.keyD)) {
        direccion.x = 1;
      }

      // Iniciar salto (tecla Espacio)
      if (teclasPresionadas.contains(LogicalKeyboardKey.space)) {
        iniciarSalto();
      }
    } else if (event is KeyUpEvent) {
      // Detener el movimiento cuando se suelta la tecla correspondiente
      if (event.logicalKey == LogicalKeyboardKey.keyA && direccion.x < 0) {
        direccion.x = 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD && direccion.x > 0) {
        direccion.x = 0;
      }
    }

    return super.onKeyEvent(event, teclasPresionadas);
  }
}
