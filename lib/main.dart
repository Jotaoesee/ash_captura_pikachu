import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ash_captura_pikachu/Games/ash_captura_pikachu.dart';

void main() {
  // Crear una instancia del juego para utilizarla en la configuración inicial.
  final gameInstance = AshCapturaPikachu();

  // Ejecutar la aplicación Flutter con MaterialApp.
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Ocultar la etiqueta de "debug" en la esquina superior derecha.
      home: Focus(
        autofocus: true, // Habilitar el enfoque automático para recibir eventos de teclado.
        child: GameWidget<AshCapturaPikachu>.controlled(
          gameFactory: () => gameInstance, // Proporcionar la instancia del juego al widget.

          // Configuración de los overlays, mapas de widgets superpuestos al juego.
          overlayBuilderMap: {
            'MenuInicio': (context, AshCapturaPikachu game) {
              // Overlay de inicio que muestra un menú inicial con un botón para empezar el juego.
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20), // Espaciado interno del contenedor.
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Fondo semitransparente.
                    borderRadius: BorderRadius.circular(15), // Bordes redondeados.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Sombra del contenedor.
                        blurRadius: 10,
                        offset: const Offset(0, 4), // Desplazamiento de la sombra.
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ajustar el tamaño de la columna al contenido.
                    children: [
                      const Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Estilo de texto llamativo.
                        ),
                      ),
                      const SizedBox(height: 20), // Espaciado entre el texto y el botón.
                      ElevatedButton(
                        onPressed: () {
                          // Acción del botón: iniciar el juego si ya está cargado.
                          if (game.isLoaded) {
                            game.iniciarJuego(); // Llamar al método para comenzar el juego.
                            game.overlays.remove('MenuInicio'); // Ocultar el menú de inicio.
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Color del botón.
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados del botón.
                          ),
                        ),
                        child: const Text(
                          'Iniciar Juego',
                          style: TextStyle(fontSize: 20), // Estilo del texto en el botón.
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          },

          // Builder que muestra un indicador de carga mientras se prepara el juego.
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(), // Animación circular de carga.
          ),

          // Builder que muestra un mensaje en caso de error durante la carga del juego.
          errorBuilder: (context, ex) => Center(
            child: Text('Error: ${ex.toString()}'), // Muestra el mensaje de error en pantalla.
          ),

          // Lista de overlays que estarán activos al inicio de la aplicación.
          initialActiveOverlays: const ['MenuInicio'],
        ),
      ),
    ),
  );
}
