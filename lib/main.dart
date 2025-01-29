import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final instanciaDelJuego = AshCapturaPikachu();

    return MaterialApp(
      title: 'Ash Captura Pikachu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () => instanciaDelJuego,
          // Configuración de los overlays, mapas de widgets superpuestos al juego.
          overlayBuilderMap: {
            'MenuInicio': (context, AshCapturaPikachu juego) {
              // Overlay de inicio que muestra un menú con un botón para empezar el juego.
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(
                      20), // Espaciado interno del contenedor.
                  decoration: BoxDecoration(
                    // Establecemos el color de fondo del contenedor.
                    color: Colors.white
                        .withOpacity(0.8), // Fondo semitransparente.
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Sombra del contenedor.
                        blurRadius: 10,
                        offset:
                            const Offset(0, 4), // Desplazamiento de la sombra.
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Elimina el overlay del menú de inicio y comienza el juego.
                      juego.overlays.remove('MenuInicio');
                      juego.iniciarJuego();
                    },
                    child: const Text('Iniciar Juego'),
                  ),
                ),
              );
            },
            'GameOver': (context, AshCapturaPikachu juego) {
              // Overlay de Game Over que muestra un mensaje y un botón para reiniciar el juego.
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(
                      20), // Espaciado interno del contenedor.
                  decoration: BoxDecoration(
                    // Establecemos el color de fondo del contenedor.
                    color: Colors.white
                        .withOpacity(0.8), // Fondo semitransparente.
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Sombra del contenedor.
                        blurRadius: 10,
                        offset:
                            const Offset(0, 4), // Desplazamiento de la sombra.
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Elimina el overlay de "GameOverMenu" y reinicia el juego.
                      juego.overlays.remove('GameOver');
                      juego.iniciarJuego();
                    },
                    child: const Text('Reiniciar Juego'),
                  ),
                ),
              );
            },
          },
          initialActiveOverlays: const [
            'MenuInicio'
          ], // Iniciar con el overlay de inicio visible.
        ),
      ),
    );
  }
}
