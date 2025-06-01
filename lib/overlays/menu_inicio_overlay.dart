import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para interactuar con ella.
import 'package:flutter/material.dart'; // Importa los componentes de Material Design de Flutter.

/// [MenuInicioOverlay] es un widget [StatelessWidget] que representa la
/// pantalla de menú de inicio del juego.
///
/// Este overlay se superpone al juego y proporciona una opción para que
/// el usuario inicie la partida. Está diseñado con un fondo semi-transparente
/// y un botón central.
class MenuInicioOverlay extends StatelessWidget {
  /// Referencia a la instancia del juego [AshCapturaPikachu].
  ///
  /// Es necesaria para poder llamar a métodos del juego, como `iniciarJuego()`
  /// y manipular sus `overlays`.
  final AshCapturaPikachu juego;

  /// Constructor de [MenuInicioOverlay].
  ///
  /// Requiere una referencia a la instancia del juego [juego].
  /// La clave [key] es opcional.
  const MenuInicioOverlay({super.key, required this.juego});

  @override
  /// Construye la interfaz de usuario del overlay del menú de inicio.
  ///
  /// Retorna un [Center] widget para centrar el contenido en la pantalla.
  /// Dentro, un [Container] proporciona el estilo visual (fondo semi-transparente,
  /// bordes redondeados y sombra). Contiene un [ElevatedButton] que, al ser
  /// presionado, oculta el menú y comienza el juego.
  Widget build(BuildContext context) {
    return Center(
      // Centra el contenido horizontal y verticalmente en la pantalla.
      child: Container(
        padding: const EdgeInsets.all(20), // Padding interno del contenedor.
        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(0.8), // Fondo blanco con un 80% de opacidad para un efecto semi-transparente.
          borderRadius:
              BorderRadius.circular(15), // Aplica bordes redondeados al contenedor.
          boxShadow: [
            // Añade una sombra para dar un efecto de profundidad.
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.3), // Color de la sombra con opacidad.
              blurRadius: 10, // Radio de desenfoque de la sombra.
              offset: const Offset(0, 4), // Desplazamiento de la sombra (eje Y).
            ),
          ],
        ),
        // Botón para iniciar el juego.
        child: ElevatedButton(
          onPressed: () {
            // Al presionar el botón:
            // 1. Remueve este overlay (el menú de inicio) de la lista de overlays activos del juego.
            juego.overlays.remove('MenuInicio');
            // 2. Llama al método `iniciarJuego()` de la instancia del juego para comenzar la partida.
            juego.iniciarJuego();
          },
          // Texto del botón.
          child: const Text('Iniciar Juego'),
        ),
      ),
    );
  }
}