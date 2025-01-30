import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';
import 'package:ash_captura_pikachu/overlays/menu_inicio_overlay.dart';
import 'package:ash_captura_pikachu/overlays/resultados_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_tiempo_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_ash_overlay.dart';
import 'package:ash_captura_pikachu/overlays/contador_maya_overlay.dart';

/// **Función principal** que inicia la aplicación Flutter.
void main() {
  runApp(const MiApp());
}

/// **Clase principal de la aplicación.**
/// Define la estructura del juego y gestiona los overlays (menús e interfaces).
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // **Instancia del juego principal**
    final instanciaDelJuego = AshCapturaPikachu();

    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //  Oculta la etiqueta de "DEBUG" en la app.
      title: 'Ash Captura Pikachu', //  Título de la aplicación.
      theme: ThemeData(
        primarySwatch: Colors.blue, //  Define el tema de la aplicación.
      ),
      home: Scaffold(
        // **GameWidget**: Widget que renderiza el juego dentro de la app.
        body: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () =>
              instanciaDelJuego, //  Crea una instancia del juego.

          // **Mapeo de Overlays (interfaces)**
          overlayBuilderMap: {
            //  Menú de inicio (pantalla inicial con botón "Iniciar Juego").
            'MenuInicio': (context, AshCapturaPikachu juego) =>
                MenuInicioOverlay(juego: juego),

            //  Overlay que muestra los resultados al finalizar el juego.
            'Resultados': (context, AshCapturaPikachu juego) =>
                ResultadosOverlay(juego: juego),

            //  Overlay que muestra el contador de tiempo restante.
            'ContadorTiempo': (context, AshCapturaPikachu juego) =>
                ContadorTiempoOverlay(juego: juego),

            //  Overlay que muestra el contador de Pikachus capturados por Ash.
            'ContadorAsh': (context, AshCapturaPikachu juego) =>
                ContadorAshOverlay(juego: juego),

            //  Overlay que muestra el contador de Pikachus capturados por Maya.
            'ContadorMaya': (context, AshCapturaPikachu juego) =>
                ContadorMayaOverlay(juego: juego),
          },

          // **Overlays activos al iniciar el juego**
          initialActiveOverlays: const [
            'MenuInicio'
          ], //  Muestra el menú de inicio al empezar.
        ),
      ),
    );
  }
}
