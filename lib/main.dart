import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:mime/mime.dart';
import 'package:metadata_god/metadata_god.dart';


void main() {
  MetadataGod.initialize();
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Color.fromARGB(255, 214, 209, 185)
      ),
      home: AudioPlayerDemo(),
    );
  }
}

class AudioPlayerDemo extends StatefulWidget {
  @override
  _AudioPlayerDemoState createState() => _AudioPlayerDemoState();
}

class _AudioPlayerDemoState extends State<AudioPlayerDemo> {
  final audioPlayer = AudioPlayer();
  String audioFilePath = '';
  Metadata? metadata;
  FilePickerResult? filePickerResult;
  bool isPlaying = false;
  int currentIndex = 0;
  List<String> playList = [];
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  String formatTime(int seconds) {return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8,'0');
  }


  Future<void> pickAudio() async {
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );                            

    if (filePickerResult != null) {
      final fileMetadata = await MetadataGod.readMetadata(
        file: filePickerResult!.files.first.path!);
      setState(() {
        metadata = fileMetadata;
        playList = filePickerResult!.files
            .map(
              (file) => file.path!,
            )
            .toList();
        currentIndex = 0;
        
      });
    }
  }
    @override
  void initState(){
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) { 
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    
    audioPlayer.onPositionChanged.listen((newPosition) {
     setState(() {
       position = newPosition;
     }); 
    });

  }

  void playAudio() {
    if (isPlaying == false) {
      if (playList.isNotEmpty){
        debugPrint("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1");
        audioFilePath = playList[currentIndex];
        audioPlayer.play(UrlSource(audioFilePath));
        debugPrint('reproducionedo cancion: $currentIndex');
      }else{
        audioPlayer.play(AssetSource('audio_misterioso.mp3'));
      }
      isPlaying = true;
      setState(() {});
    } else {
      pauseAudio();
    }
    setState(() {});
  }

  void pauseAudio() {
    audioPlayer.pause();
    isPlaying = false;
    setState(() {});
  }

  void stopAudio() {
    audioPlayer.stop();
    isPlaying = false;
    setState(() {});
  }

  void playNext() {
    if (currentIndex < playList.length - 1) {
      currentIndex++;
      isPlaying = false;
      playAudio();
      debugPrint('Cambiando a la siguiente cancion: $currentIndex');
    }
    setState(() async {
       metadata = await MetadataGod.readMetadata(
          file: audioFilePath);
    });
  }

//cancion previa

  void playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      isPlaying = false;
      playAudio();
    }
    setState(() async {
       metadata = await MetadataGod.readMetadata(
          file: audioFilePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reproductor de Audio con Selector de Archivos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (audioFilePath != '')
              Text("Título: ${metadata!.title}"),
            if(metadata != null)
              metadata!.picture?.data != null
                ? Image.memory(metadata!.picture!.data)
                : Image.asset('assets/default.png'),
            ElevatedButton(
              onPressed: pickAudio,
              child: Text('Seleccionar Audio'),
            ),
            Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) { 
                      final newPosition=Duration(seconds: value.toInt());
                      audioPlayer.seek(newPosition);
                    },
                    ),
                    Container(padding: EdgeInsets.all(20),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(position.inSeconds)),
                          Text(formatTime((duration-position).inSeconds)),
                        ],
                      ),
                    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.skip_previous_rounded),
                    iconSize: 70,
                    onPressed: playPrevious),
                SizedBox(height: 20),
                IconButton(
                    icon: (isPlaying)
                        ? Icon(Icons.pause_circle_filled)
                        : Icon(Icons.play_circle_outline),
                    iconSize: 70,
                    onPressed: playAudio),
                SizedBox(height: 20),
                //skip
                IconButton(
                    icon: Icon(Icons.stop_circle_rounded),
                    iconSize: 70,
                    onPressed: stopAudio),
                SizedBox(height: 20),
                IconButton(
                    icon: Icon(Icons.skip_next_rounded),
                    iconSize: 70,
                    onPressed: playNext),
                SizedBox(height: 20),
              ],
            ),
            //PLAY/PAUSE CAMBIO

            Text(
              'Archivo seleccionado: ${filePickerResult != null ? "${metadata!.title}" : "Ninguno"}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
