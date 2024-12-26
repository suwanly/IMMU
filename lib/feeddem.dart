import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  AudioPlayer _audioPlayer = AudioPlayer();
  Uint8List _audioFile = Uint8List(0);
  String _selectedMusic='\0';


  Future<void> _loadAudioFile(String music) async {
    final response = await http.get(Uri.parse(music));
    if (response.statusCode == 200) {
      setState(() {
        _audioFile = response.bodyBytes;
      });
    } else {
      print('Failed to load audio file');
    }
  }

  Future<void> _playAudioFile(String music) async {
    if (_audioFile.isEmpty) {
      // if audio file is not loaded yet, load it.
      await _loadAudioFile(music);
    }

    await _audioPlayer.stop(); // stop any previous playback
    await _audioPlayer.play(UrlSource(music)); // play the audio from bytes
  }

  List<Map<String, dynamic>> _postCards = [
    {
      'image': 'https://source.unsplash.com/random/400x400',
      'likes': Random().nextInt(1000),
      'musicPlays': Random().nextInt(500),
      'music': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'image': 'https://source.unsplash.com/random/401x401',
      'likes': Random().nextInt(1000),
      'musicPlays': Random().nextInt(500),
      'music': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'image': 'https://source.unsplash.com/random/402x402',
      'likes': Random().nextInt(1000),
      'musicPlays': Random().nextInt(500),
      'music': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: _postCards.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    _postCards[index]['image'],
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.favorite_border),
                      Text('${_postCards[index]['likes']} likes'),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.black)),
                        onPressed:() async {
                          setState(() => _selectedMusic = _postCards[index]['music']); // 수정
                          await _playAudioFile(_selectedMusic);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 4.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text('- Never, or ever'),
                  const Divider(),
                  Text('${_postCards[index]['musicPlays']} music plays'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
