import 'package:flutter/material.dart'; // Importa los componentes de Material Design de Flutter.
import 'package:flame/game.dart'; // Importa el widget GameWidget de Flame.
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego.
import 'package:ash_captura_pikachu/overlays/menu_inicio_overlay.dart'; // Importa el overlay del menú de inicio.
import 'package:ash_captura_pikachu/overlays/resultados_overlay.dart'; // Importa el overlay de resultados.
import 'package:ash_captura_pikachu/overlays/contador_tiempo_overlay.dart'; // Importa el overlay del contador de tiempo.
import 'package:ash_captura_pikachu/overlays/contador_ash_overlay.dart'; // Importa el overlay del contador de Ash.
import 'package:ash_captura_pikachu/overlays/contador_maya_overlay.dart'; // Importa el overlay del contador de Maya.

/// **Función principal** que sirve como punto de entrada de la aplicación Flutter.
///
/// Llama a `runApp` para iniciar la interfaz de usuario de la aplicación,
/// construyendo el widget raíz [MiApp].
void main() {
  runApp(const MiApp());
}

/// **Clase principal de la aplicación Flutter.**
///
/// Es un [StatelessWidget] que define la estructura visual de la aplicación.
/// Se encarga de instanciar el juego [AshCapturaPikachu] y de gestionar
/// los diferentes overlays (interfaces de usuario) que se superponen al juego.
class MiApp extends StatelessWidget {
  /// Constructor de [MiApp].
  ///
  /// La clave [key] es opcional.
  const MiApp({super.key});

  @override
  /// Construye el árbol de widgets de la aplicación.
  ///
  /// Retorna un [MaterialApp] que envuelve un [Scaffold] y el widget principal
  /// del juego de Flame, [GameWidget].
  Widget build(BuildContext context) {
    // Instancia del juego principal. Esta instancia se pasa a los overlays
    // para que puedan interactuar con el estado del juego.
    final instanciaDelJuego = AshCapturaPikachu();

    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Oculta la etiqueta de "DEBUG" en la esquina superior derecha de la aplicación.
      title: 'Ash Captura Pikachu', // Título que se muestra en la barra de tareas de la aplicación.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define la paleta de colores principal para la aplicación.
      ),
      home: Scaffold(
        // El widget [GameWidget] de Flame es el corazón de la integración del juego
        // en la interfaz de usuario de Flutter.
        // `.controlled` permite pasar una fábrica de juegos y un mapa de overlays.
        body: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () =>
              instanciaDelJuego, // Una función de fábrica que retorna la instancia del juego.
          // **Mapeo de Overlays (interfaces de usuario)**
          // Define qué widgets de Flutter corresponden a cada nombre de overlay.
          // Estos overlays pueden ser activados y desactivados desde la lógica del juego.
          overlayBuilderMap: {
            // 'MenuInicio': Muestra la pantalla inicial con el botón "Iniciar Juego".
            'MenuInicio': (context, AshCapturaPikachu juego) =>
                MenuInicioOverlay(juego: juego),

            // 'Resultados': Muestra los resultados finales del juego (ganador, empate).
            'Resultados': (context, AshCapturaPikachu juego) =>
                ResultadosOverlay(juego: juego),

            // 'ContadorTiempo': Muestra el tiempo restante de la partida.
            'ContadorTiempo': (context, AshCapturaPikachu juego) =>
                ContadorTiempoOverlay(juego: juego),

            // 'ContadorAsh': Muestra la cantidad de Pikachus capturados por Ash.
            'ContadorAsh': (context, AshCapturaPikachu juego) =>
                ContadorAshOverlay(juego: juego),

            // 'ContadorMaya': Muestra la cantidad de Pikachus capturados por Maya.
            'ContadorMaya': (context, AshCapturaPikachu juego) =>
                ContadorMayaOverlay(juego: juego),
          },
          // **Overlays activos al iniciar el juego**
          // Una lista de los nombres de los overlays que deben estar visibles
          // tan pronto como la aplicación se inicia.
          initialActiveOverlays: const [
            'MenuInicio'
          ], // El juego comienza mostrando el menú de inicio.
        ),
      ),
    );
  }
}