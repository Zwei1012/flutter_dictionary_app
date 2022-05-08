// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable
//liet ke chi tiet cua conversation

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dictionary_app/dbHelper/moor_database.dart';
import 'package:flutter_dictionary_app/modules/conversation.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';

class ConversationListDetail extends StatefulWidget {
  static String routeName = "/conversation-detail";
  @override
  State<ConversationListDetail> createState() => _ConversationListDetailState();
}

class _ConversationListDetailState extends State<ConversationListDetail> {
  final audioPlayer = AudioPlayer();

  bool isPlaying =false;

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  @override
  void initState(){
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) { 
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) { 
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) { 
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async{
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load('audio/00 - Vocabulary');
    audioPlayer.setUrl(url.path, isLocal: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final ConversationArgument conversationArgument =
        ModalRoute.of(context)!.settings.arguments as ConversationArgument;
    return Scaffold(
        appBar: AppBar(
          title: Text(conversationArgument.conversation.name),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5F72BE), Color(0xFF9921E8)])),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(conversationArgument.conversation.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 350,
                ),
              ),
              const SizedBox(height: 32),
              Text(conversationArgument.conversation.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(), 
                value: position.inSeconds.toDouble(), 
                onChanged: (value) async{
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  await audioPlayer.resume();
                },
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // children: [
                //   Text(formatTime(position)),
                //   Text(formatTime(duration - position)),
                // ],
              ),
              ),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  iconSize: 50,
                  onPressed: () async{
                    if(isPlaying){
                      await audioPlayer.pause();
                    } else{
                      String url ='assets/audio/00 - Vocabulary.mp3';
                      await audioPlayer.play(url);
                    }
                  },
                ),
              ),
              Text(conversationArgument.conversation.content)
            ],
          ),
        ));
  }
}

class ConversationArgument {
  ConversationData conversation;
  ConversationArgument({required this.conversation});
}
