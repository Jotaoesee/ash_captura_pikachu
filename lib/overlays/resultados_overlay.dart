import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder a los resultados y reiniciar.
import 'package:flutter/material.dart'; // Importa los componentes de Material Design de Flutter.

/// [ResultadosOverlay] es un widget [StatelessWidget] que se muestra como
/// un overlay al finalizar la partida.
///
/// Su propósito es informar al jugador sobre los resultados del juego,
/// indicando quién ganó (Ash o Maya) o si hubo un empate, basándose en la
/// cantidad de Pikachus capturados por cada uno. También proporciona un botón
/// para reiniciar el juego.
class ResultadosOverlay extends StatelessWidget {
  /// Referencia a la instancia del juego [AshCapturaPikachu].
  ///
  /// Es necesaria para obtener los contadores finales de Pikachus de ambos
  /// jugadores y para llamar al método `reiniciarJuego()`.
  final AshCapturaPikachu juego;

  /// Constructor de [ResultadosOverlay].
  ///
  /// Requiere una referencia a la instancia del juego [juego].
  /// La clave [key] es opcional.
  const ResultadosOverlay({super.key, required this.juego});

  @override
  /// Construye la interfaz de usuario del overlay de resultados.
  ///
  /// Retorna un [Center] widget para centrar el contenido. Dentro, un [Container]
  /// con un estilo visual que incluye un fondo semi-transparente, bordes
  /// redondeados y una sombra. Contiene una [Column] que muestra el mensaje
  /// de resultado y un [ElevatedButton] para reiniciar la partida.
  Widget build(BuildContext context) {
    // Determina el mensaje de resultado a mostrar, comparando los contadores de Pikachus.
    String mensaje;
    if (juego.pikachusAsh.value > juego.pikachusMaya.value) {
      mensaje = "🏆 ¡Ash gana con ${juego.pikachusAsh.value} Pikachus!";
    } else if (juego.pikachusMaya.value > juego.pikachusAsh.value) {
      mensaje = "🏆 ¡Maya gana con ${juego.pikachusMaya.value} Pikachus!";
    } else {
      mensaje =
          "🤝 ¡Empate! Ambos capturaron ${juego.pikachusAsh.value} Pikachus.";
    }

    return Center(
      // Centra el contenido horizontal y verticalmente en la pantalla.
      child: Container(
        padding: const EdgeInsets.all(20), // Padding interno del contenedor.
        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(0.8), // Fondo blanco con un 80% de opacidad.
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
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // La columna ocupa el mínimo espacio vertical necesario.
          children: [
            // Texto que muestra el mensaje de resultados.
            Text(
              mensaje,
              textAlign: TextAlign.center, // Centra el texto si ocupa varias líneas.
              style: const TextStyle(
                fontSize: 24, // Tamaño de fuente grande.
                fontWeight: FontWeight.bold, // Texto en negrita.
                color: Colors.black, // Color del texto.
              ),
            ),
            const SizedBox(height: 20), // Espacio vertical entre el texto y el botón.

            // Botón para reiniciar el juego.
            ElevatedButton(
              onPressed: () {
                // Al presionar el botón, llama al método `reiniciarJuego()` de la instancia del juego.
                juego.reiniciarJuego();
              },
              // Texto del botón.
              child: const Text('Reiniciar Juego'),
            ),
          ],
        ),
      ),
    );
  }
}