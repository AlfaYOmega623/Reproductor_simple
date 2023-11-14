## Implementación

Esta aplicación ocupa [`audioplayers`](https://pub.dev/packages/audioplayers) para reporducir el audio almacenado como asset.

Para poder llamarlo es necesario poner en 'pubsec.yaml' la carpeta que se usará para almacenar los assets.

Luego en el código, localizamos el archivo a reproducir con [`file_picker`](https://pub.dev/packages/file_picker), y lo transformamos a una fuente válida para reproducirlo con `audioplayers`.

El archivo se reproduce/pausa al ejecutar una función tras pulsar el botón de inicio/pausa, y se puede manipular el slider en la pantalla para la posición del audio.

## Arquitectura

Esta aplicación ocupa un modelo simple, donde todo se ejecutaa en un solo archivo de código `main.dart`
