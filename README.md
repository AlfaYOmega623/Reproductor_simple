# Reproductor Audio Offline

## Equipo:

- Encargado de diseño: Claudio Guerrero
- Desarrollador principal: Vicente Castro
- Arquitecto de Software: Juan Pablo Gutiérrez

## Caso de Uso: Reproducir Archivo de Sonido
**Actor Principal:** Usuario

**Objetivo:** Reproducir un archivo de sonido almacenado localmente.

**Precondiciones:**
1. El usuario ha iniciado la aplicación de Reproductor de Sonidos Offline.
2. Existen archivos de sonido almacenados localmente en la biblioteca de la aplicación.

**Flujo Principal:**
1. El usuario abre la aplicación.
2. La aplicación muestra la interfaz de usuario con opciones para navegar por la biblioteca de sonidos.
3. El usuario selecciona la opción de "Seleccionar audio".
4. La aplicación muestra la lista de archivos de sonido disponibles.
5. El usuario selecciona un archivo de sonido específico que desea reproducir.
6. La aplicación carga y reproduce el archivo de sonido seleccionado.
7. Durante la reproducción, el usuario tiene la opción de pausar, reanudar, ajustar el volumen o detener la reproducción.

**Postcondiciones:**
1. El archivo de sonido se reproduce.
2. La aplicación vuelve a la interfaz principal.

![Reproductor de Sonidos](https://github.com/AlfaYOmega623/Reproductor_simple/blob/main/assets/Dise%C3%B1o.png?raw=true)

## Implementación

Esta aplicación ocupa [`audioplayers`](https://pub.dev/packages/audioplayers) para reporducir el audio almacenado como asset.

Para poder llamarlo es necesario poner en 'pubsec.yaml' la carpeta que se usará para almacenar los assets.

Luego en el código, localizamos el archivo a reproducir con [`file_picker`](https://pub.dev/packages/file_picker), y lo transformamos a una fuente válida para reproducirlo con `audioplayers`.

El archivo se reproduce/pausa al ejecutar una función tras pulsar el botón de inicio/pausa, y se puede manipular el slider en la pantalla para la posición del audio.

## Arquitectura

Esta aplicación ocupa un modelo simple, donde todo se ejecuta en un solo archivo de código `main.dart`
