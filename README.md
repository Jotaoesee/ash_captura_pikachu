⚡ Ash Captura Pikachu ⚡
Descripción del Proyecto
Ash Captura Pikachu es un dinámico juego de plataformas 2D competitivo, desarrollado con la potencia de Flutter y el versátil motor de juegos Flame. Sumérgete en un vibrante mundo donde tú y un amigo podréis encarnar a los legendarios entrenadores Pokémon, Ash y Maya.

En este arcade de recolección, el objetivo es simple pero desafiante: capturar la mayor cantidad de Pikachus dispersos por un ingenioso mapa de plataformas antes de que el implacable temporizador llegue a cero. Cada Pikachu capturado suma puntos a tu marcador, y al final de la partida, ¡solo uno podrá alzarse con la victoria! El juego ofrece una experiencia rápida, divertida y adictiva, perfecta para dos jugadores que deseen poner a prueba su agilidad, reflejos y estrategia de recolección en una carrera contra el tiempo.

El Problema que Resuelve
En un mundo de juegos complejos, Ash Captura Pikachu regresa a la esencia de la diversión arcade. Ofrece una experiencia de juego multijugador local intuitiva y fácil de aprender, ideal para sesiones rápidas de entretenimiento entre amigos o para aquellos que buscan un desafío de un solo jugador. Su simplicidad lo hace accesible, pero su naturaleza competitiva asegura que cada partida sea única y emocionante.

¿Para Quién es Útil?
Este proyecto es ideal para:

Jugadores ocasionales: Amantes de los juegos sencillos y divertidos para compartir.

Fans de Pokémon: Una nueva forma de interactuar con el universo de Ash y Pikachu.

Desarrolladores de Flutter/Flame: Sirve como un excelente ejemplo práctico y bien estructurado de un juego de plataformas 2D. Podrás aprender sobre:

Gestión de personajes y animaciones.

Detección precisa de colisiones.

Integración de interfaz de usuario (UI Overlays) con Flutter.

Control de la física (gravedad, saltos).

Manejo de estados de juego (inicio, fin, reinicio).

Carga de mapas creados con Tiled.

Gestión de audio en juegos.

✨ Características Clave
🎮 Doble Jugador Competitivo: Compite directamente contra un amigo controlando a Ash o a Maya en una emocionante carrera por los Pikachus.

🏃‍♂️ Mecánicas de Plataformas 2D: Disfruta de un movimiento fluido con saltos precisos y una física de gravedad realista para una jugabilidad clásica y dinámica.

⚡ Colección de Objetos: Atrapa Pikachus dispersos por todo el mapa simplemente colisionando con ellos. ¡Cada captura te acerca a la victoria!

📊 Interfaz de Usuario Reactiva (UI Overlays):

Menú de Inicio: Una pantalla de bienvenida clara para comenzar tu aventura.

Contadores en Tiempo Real: Mantente al tanto de los Pikachus capturados por Ash y Maya, visibles en todo momento.

Temporizador de Juego: Una Pokébola animada te muestra el tiempo restante de la partida.

Pantalla de Resultados: Descubre quién se ha coronado como el Maestro Pokémon al finalizar el juego, o si la contienda terminó en un emocionante empate.

🔊 Sonidos y Animaciones Vibrantes: Sumérgete en el juego con una cautivadora música de fondo, efectos de sonido distintivos para cada captura de Pikachu, y animaciones fluidas que dan vida a los personajes.

💥 Detección de Colisiones Precisa: Interacciones realistas y justas entre los personajes, los Pikachus y el entorno de plataformas.

🚀 Desarrollado con Flame: Construido sobre la base de Flame, un potente motor de juegos para Flutter, garantizando un rendimiento óptimo.

🗺️ Mapeado con Tiled: El diseño de los niveles y la estratégica ubicación de los elementos se gestionan fácilmente utilizando mapas creados con Tiled, lo que facilita la creación de nuevos desafíos.

🛠️ Tecnologías Utilizadas
Lenguaje de Programación: Dart

Framework de Aplicación: Flutter

Motor de Juegos: Flame (con sus módulos clave):

flame/components

flame/events

flame/game

flame/parallax

flame/collisions

flame_tiled

flame_audio

Diseño de Mapas: Tiled

Gestión de Estado (UI): ValueNotifier (para la actualización reactiva de los contadores)

🚀 Cómo Instalar y Ejecutar
Para poner en marcha Ash Captura Pikachu en tu entorno de desarrollo local, sigue estos sencillos pasos:

Prerrequisitos
Asegúrate de tener instalados los siguientes elementos:

Flutter SDK: Se recomienda utilizar una versión estable.

Un editor de código compatible con Flutter, como VS Code (con la extensión de Flutter) o Android Studio.

Un dispositivo o emulador configurado y listo para ejecutar aplicaciones Flutter (Android, iOS, web o escritorio).

Pasos de Instalación
Clona el repositorio: Abre tu terminal o línea de comandos y ejecuta:

git clone https://github.com/tu_usuario/ash_captura_pikachu.git
cd ash_captura_pikachu

(Nota: Reemplaza https://github.com/tu_usuario/ash_captura_pikachu.git con la URL real de tu repositorio si es diferente).

Instala las dependencias de Flutter: Dentro del directorio del proyecto clonado, ejecuta:

flutter pub get

Esto descargará todas las librerías y paquetes necesarios para el proyecto.

Configura los Assets del Juego:
Es crucial que todas las imágenes y archivos de audio del juego estén correctamente ubicados y declarados.

Asegúrate de que tus imágenes (por ejemplo, AshAndando.png, Summer6.png, PIKACHU.png, maya.png, pikachulogo.png, pokeboll.png) estén en la carpeta assets/images/.

Asegúrate de que tus archivos de audio (por ejemplo, musica_fondo.mp3, pikachu_sound.mp3) estén en la carpeta assets/audio/.

Luego, verifica que tu archivo pubspec.yaml tenga la siguiente sección bajo flutter::

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/audio/

(Es vital mantener la indentación correcta en pubspec.yaml).

Cómo Ejecutar el Juego
Una vez que los pasos anteriores se hayan completado, puedes iniciar el juego:

Ejecuta la aplicación:

flutter run

El juego se lanzará en el dispositivo o emulador que tengas configurado. Si tienes varios, puedes seleccionar uno con flutter run -d <device_id>.

🎮 Cómo Jugar
Ash Captura Pikachu es una carrera contra el tiempo y contra tu oponente para ver quién es el mejor cazador de Pikachus.

Objetivo del Juego
El objetivo principal es capturar la mayor cantidad de Pikachus posibles antes de que el temporizador global, visible en la parte inferior central de la pantalla (¡en una Pokébola!), llegue a cero.

Controles
Ambos jugadores controlan a sus personajes de forma independiente:

Ash (Jugador 1):

➡️ Mover a la izquierda: Presiona la tecla A

⬅️ Mover a la derecha: Presiona la tecla D

⬆️ Saltar: Presiona la tecla Espacio

Maya (Jugador 2):

➡️ Mover a la izquierda: Presiona la Flecha Izquierda

⬅️ Mover a la derecha: Presiona la Flecha Derecha

⬆️ Saltar: Presiona la tecla Numpad . (Punto decimal del teclado numérico)

Mecánica de Juego
Inicio de la Partida: Al iniciar la aplicación, serás recibido por un amigable menú de inicio. Haz clic en el botón "Iniciar Juego" para sumergirte en la acción.

La Caza de Pikachus: Los adorables Pikachus están estratégicamente distribuidos por todo el mapa de plataformas. Para capturar uno, simplemente haz que tu personaje colisione con él. ¡Escucharás un satisfactorio sonido de captura, tu contador se actualizará y el Pikachu desaparecerá para siempre!

Exploración y Movimiento: Utiliza tus habilidades de plataformas para navegar por el nivel. Salta sobre obstáculos, alcanza plataformas más elevadas y explora cada rincón para encontrar más Pikachus.

Física de Plataformas: La gravedad es tu amiga (y a veces tu enemiga). Tus personajes se comportarán de forma realista al caer y aterrizar en las superficies.

El Fin de la Cuenta Regresiva: La emoción aumenta a medida que el tiempo se agota. La partida concluye automáticamente cuando el temporizador llega a cero.

Resultados Finales: Una vez que el tiempo se detiene, una pantalla de resultados emergerá para revelar al campeón. Se mostrará quién ganó (Ash o Maya) basándose en la cantidad final de Pikachus capturados. Si ambos tienen la misma cantidad, ¡será un glorioso empate! Desde esta pantalla, podrás elegir "Reiniciar Juego" para una nueva partida.

Cuidado con las Caídas: Si Ash o Maya caen fuera de los límites inferiores de la pantalla, la partida se dará por terminada prematuramente (Game Over). ¡Mantén tus ojos en el mapa y tus pies en las plataformas!

