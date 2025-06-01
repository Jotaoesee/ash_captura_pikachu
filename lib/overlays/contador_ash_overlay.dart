import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart'; // Importa la clase principal del juego para acceder a sus datos.
import 'package:flutter/material.dart'; // Importa los componentes de Material Design de Flutter.

/// [ContadorAshOverlay] es un widget [StatelessWidget] que se utiliza como
/// un overlay en la interfaz de usuario del juego para mostrar el número de
/// Pikachus capturados por el personaje Ash.
///
/// Este contador se actualiza de forma reactiva gracias a un [ValueListenableBuilder]
/// que escucha los cambios en el `ValueNotifier` de `pikachusAsh` de la instancia del juego.
class ContadorAshOverlay extends StatelessWidget {
  /// Referencia a la instancia del juego [AshCapturaPikachu].
  ///
  /// Es necesaria para acceder a los datos en tiempo real del juego,
  /// específicamente el contador de Pikachus de Ash.
  final AshCapturaPikachu juego;

  /// Constructor de [ContadorAshOverlay].
  ///
  /// Requiere una referencia a la instancia del juego [juego].
  /// La clave [key] es opcional.
  const ContadorAshOverlay({super.key, required this.juego});

  @override
  /// Construye la interfaz de usuario del overlay del contador de Ash.
  ///
  /// Retorna un [Positioned] widget para controlar la ubicación exacta en
  /// la pantalla, y un [ValueListenableBuilder] para reconstruir solo la
  /// parte del contador cuando el número de Pikachus de Ash cambie.
  Widget build(BuildContext context) {
    return Positioned(
      top: 20, // Ubica el contador a 20 unidades de la parte superior de la pantalla.
      left: 20, // Ubica el contador a 20 unidades de la izquierda de la pantalla.
      child: ValueListenableBuilder<int>(
        valueListenable:
            juego.pikachusAsh, // Escucha los cambios en el ValueNotifier de pikachusAsh del juego.
        builder: (context, valor, child) {
          // El builder se llama cada vez que 'juego.pikachusAsh.value' cambia.
          return Row(
            // Utiliza un [Row] para alinear el icono de Pikachu y el número horizontalmente.
            children: [
              // Muestra la imagen de Pikachu. Asegúrate de que 'assets/images/pikachulogo.png'
              // esté incluido en tu archivo `pubspec.yaml` bajo la sección `assets`.
              Image.asset(
                'assets/images/pikachulogo.png',
                width: 40, // Ancho de la imagen del logo de Pikachu.
                height: 40, // Alto de la imagen del logo de Pikachu.
              ),
              const SizedBox(
                  width: 10), // Espacio horizontal entre la imagen y el texto del contador.
              // Muestra el número actual de Pikachus capturados por Ash.
              Text(
                valor.toString(), // Convierte el valor entero a una cadena para mostrar.
                style: const TextStyle(
                  color: Colors.white, // Color del texto.
                  fontSize: 28, // Tamaño de fuente grande para la visibilidad.
                  fontWeight: FontWeight.bold, // Texto en negrita.
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}