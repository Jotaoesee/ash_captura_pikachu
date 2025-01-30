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
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/pokeboll.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
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
                                color: Colors.white,
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
            // 🔹 Contador de Pikachus de Ash (esquina superior izquierda)
            'ContadorAsh': (context, AshCapturaPikachu juego) {
              return Positioned(
                top: 20,
                left: 20,
                child: ValueListenableBuilder<int>(
                  valueListenable:
                      juego.pikachusAsh, // 🔥 Se actualizará automáticamente
                  builder: (context, valor, child) {
                    return Row(
                      children: [
                        Image.asset(
                          'assets/images/pikachulogo.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          valor.toString(), // ✅ Se actualiza dinámicamente
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },

            // 🔹 Contador de Pikachus de Maya (esquina superior derecha)
            'ContadorMaya': (context, AshCapturaPikachu juego) {
              return Positioned(
                top: 20,
                right: 20,
                child: ValueListenableBuilder<int>(
                  valueListenable:
                      juego.pikachusMaya, // 🔥 Se actualizará automáticamente
                  builder: (context, valor, child) {
                    return Row(
                      children: [
                        Image.asset(
                          'assets/images/pikachulogo.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          valor.toString(), // ✅ Se actualiza dinámicamente
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
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
