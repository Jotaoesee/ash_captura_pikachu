import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gameInstance = AshCapturaPikachu();

    return MaterialApp(
      title: 'Ash Captura Pikachu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () => gameInstance,
          // Configuración de los overlays, mapas de widgets superpuestos al juego.
          overlayBuilderMap: {
            'MenuInicio': (context, AshCapturaPikachu game) {
              // Overlay de inicio que muestra un menú inicial con un botón para empezar el juego.
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(
                      20), // Espaciado interno del contenedor.
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white
                        .withOpacity(0.8), // Fondo semitransparente.
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados.
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
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
                      game.overlays.remove('MenuInicio');
                      game.iniciarJuego();
                    },
                    child: const Text('Iniciar Juego'),
                  ),
                ),
              );
            },
            'GameOver': (context, AshCapturaPikachu game) {
              // Overlay de Game Over que muestra un mensaje y un botón para reiniciar el juego.
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(
                      20), // Espaciado interno del contenedor.
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white
                        .withOpacity(0.8), // Fondo semitransparente.
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados.
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
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
                      game.overlays.remove('GameOverMenu');
                      game.iniciarJuego();
                    },
                    child: const Text('Reiniciar Juego'),
                  ),
                ),
              );
            },
          },
          initialActiveOverlays: const ['MenuInicio'],
        ),
      ),
    );
  }
}
