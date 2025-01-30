import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:ash_captura_pikachu/overlays/menu_inicio_overlay.dart';
import 'package:ash_captura_pikachu/overlays/resultados_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_tiempo_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_ash_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_maya_overlay.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final instanciaDelJuego = AshCapturaPikachu();

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "DEBUG"
      title: 'Ash Captura Pikachu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () => instanciaDelJuego,
          overlayBuilderMap: {
            'MenuInicio': (context, AshCapturaPikachu juego) =>
                MenuInicioOverlay(juego: juego),
            'Resultados': (context, AshCapturaPikachu juego) =>
                ResultadosOverlay(juego: juego),
            'ContadorTiempo': (context, AshCapturaPikachu juego) =>
                ContadorTiempoOverlay(juego: juego),
            'ContadorAsh': (context, AshCapturaPikachu juego) =>
                ContadorAshOverlay(juego: juego),
            'ContadorMaya': (context, AshCapturaPikachu juego) =>
                ContadorMayaOverlay(juego: juego),
          },
          initialActiveOverlays: const ['MenuInicio'],
        ),
      ),
    );
  }
}
