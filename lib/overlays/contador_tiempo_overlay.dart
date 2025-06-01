import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder al tiempo restante.
import 'package:flutter/material.dart'; // Importa los componentes de Material Design de Flutter.

/// [ContadorTiempoOverlay] es un widget [StatelessWidget] que se utiliza como
/// un overlay en la interfaz de usuario del juego para mostrar el tiempo
/// restante de la partida.
///
/// El tiempo se muestra dentro de una imagen de Pokébola, centrado en la
/// parte inferior de la pantalla.
class ContadorTiempoOverlay extends StatelessWidget {
  /// Referencia a la instancia del juego [AshCapturaPikachu].
  ///
  /// Es necesaria para acceder al valor actual de `tiempoRestante` del juego.
  final AshCapturaPikachu juego;

  /// Constructor de [ContadorTiempoOverlay].
  ///
  /// Requiere una referencia a la instancia del juego [juego].
  /// La clave [key] es opcional.
  const ContadorTiempoOverlay({super.key, required this.juego});

  @override
  /// Construye la interfaz de usuario del overlay del contador de tiempo.
  ///
  /// Retorna un [Positioned] widget para ubicar el contador en la parte
  /// inferior central de la pantalla. Utiliza un [Stack] para superponer
  /// la imagen de la Pokébola y el texto del tiempo restante.
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 140, // Posiciona el contador a 140 unidades desde la parte inferior.
      left: 0, // Se extiende desde el borde izquierdo...
      right: 0, // ...hasta el borde derecho para permitir el centrado.
      child: Center(
        // Centra el contenido horizontalmente.
        child: Stack(
          // Permite superponer widgets unos sobre otros.
          alignment: Alignment.center, // Centra los hijos del Stack.
          children: [
            // Imagen de fondo del contador (Pokébola).
            // Asegúrate de que 'assets/images/pokeboll.png' esté incluido
            // en tu archivo `pubspec.yaml` bajo la sección `assets`.
            Image.asset(
              'assets/images/pokeboll.png',
              width: 80, // Ancho de la imagen de la Pokébola.
              height: 80, // Alto de la imagen de la Pokébola.
              fit: BoxFit.cover, // Cubre el espacio disponible manteniendo la relación de aspecto.
            ),
            // Texto que muestra el tiempo restante.
            Positioned(
              top: 7, // Ajusta la posición vertical del texto dentro de la Pokébola.
              child: Text(
                juego.tiempoRestante
                    .toInt()
                    .toString(), // Convierte el tiempo restante (double) a un entero y luego a String.
                style: const TextStyle(
                  color: Colors.black, // Color del texto principal.
                  fontSize: 28, // Tamaño de fuente grande.
                  fontWeight: FontWeight.bold, // Texto en negrita.
                  shadows: [
                    // Añade una sombra al texto para mejorar la visibilidad.
                    Shadow(
                      offset: Offset(2, 2), // Desplazamiento de la sombra.
                      blurRadius: 2, // Radio de desenfoque de la sombra.
                      color:
                          Colors.white, // Color de la sombra (blanco para contraste).
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}