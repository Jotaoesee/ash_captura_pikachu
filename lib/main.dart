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
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      juego.overlays.remove('MenuInicio');
                      juego.iniciarJuego();
                    },
                    child: const Text('Iniciar Juego'),
                  ),
                ),
              );
            },
            'GameOver': (context, AshCapturaPikachu juego) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      juego.overlays.remove('GameOver');
                      juego.iniciarJuego();
                    },
                    child: const Text('Reiniciar Juego'),
                  ),
                ),
              );
            },
            'ContadorTiempo': (context, AshCapturaPikachu juego) {
              return Positioned(
                bottom: 140,
                left: 0,
                right: 0, // Asegurar que esté centrado
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Imagen de fondo (Pokébola)
                      Image.asset(
                        'assets/images/pokeboll.png', // Asegúrate de que la imagen está en assets
                        width: 80, // Tamaño de la Pokébola
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      // Texto del tiempo restante (desplazado hacia arriba)
                      Positioned(
                        top: 7,
                        child: Text(
                          juego.tiempoRestante.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 2,
                                color: Colors.white, // Efecto de sombra ligera
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
