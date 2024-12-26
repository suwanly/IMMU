import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';


class SNSUploadPage extends StatefulWidget {
  @override
  _SNSUploadPageState createState() => _SNSUploadPageState();
}

class _SNSUploadPageState extends State<SNSUploadPage> {
  List<File> _selectedImages = []; //여기에 저장된 사진을 업로드 해야함 -> firebase -> lavis -> riffusion -> firebase(음악) -> 기기
  String _selectedMusic='\0';
  String _description='\0';
  AudioPlayer _audioPlayer = AudioPlayer();
  Uint8List _audioFile = Uint8List(0);
  String mulink = "https://firebasestorage.googleapis.com/use_your_own_key";
  String musicname = "a";
  List<String> genre = ['','',''];
  final _controller = TextEditingController();

  Future<void> _pickImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

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

  Future<void> setgenre(String genredata, int a) async {
    genre[a] = genredata;
  }
  
  Future<void> _playAudioFile(String music) async {
    if (_audioFile.isEmpty) {
      // if audio file is not loaded yet, load it.
      await _loadAudioFile(music);
    }
    await _audioPlayer.stop(); // stop any previous playback
    await _audioPlayer.play(UrlSource(music)); // play the audio from bytes
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedImages.isNotEmpty
                      ? GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    shrinkWrap: true,
                    children: _selectedImages
                        .map((file) => Image.file(file, fit: BoxFit.cover))
                        .toList(),
                  )
                      : Icon(Icons.photo, size: 70),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: Text('Select Photos',style: TextStyle(fontFamily: 'EIKOBOLD')),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 5),
            Text(
              'Select Music',
               style: TextStyle(fontFamily: 'EIKOBOLD'),
            ),
            SizedBox(height: 8),
            if (_selectedMusic != '\0')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => setState(() => _selectedMusic = '\0'),
                  ),
                ],
              ),
            if (_selectedMusic == '\0')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      setState(() => _selectedMusic = mulink); // 수정
                      musicname = genre[0];
                      await _playAudioFile(_selectedMusic);
                    },
                    child: Text('Music A',style: TextStyle(fontFamily: 'EIKOBOLD')),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      setState(() => _selectedMusic = "https://www.riffusion.com/about/funky_sax.mp3");
                      musicname = genre[1];
                      await _playAudioFile(_selectedMusic);
                    },
                    child: Text('Music B',style: TextStyle(fontFamily: 'EIKOBOLD')), // AppBar에서만 이 폰트 사용fontSize: 30,color: Colors.white,),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      setState(() => _selectedMusic = "https://www.riffusion.com/about/funky_sax.mp3");
                      musicname = genre[2];
                      await _playAudioFile(_selectedMusic);
                    },
                    child: Text('Music C',style: TextStyle(fontFamily: 'EIKOBOLD')),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1),
            TextField(
              onChanged: (value) => setState(() => _description = value),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Enter a description of the photo(s)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: _selectedImages.isNotEmpty &&
                  _selectedMusic != '\0' &&
                  _description.isNotEmpty == true
                  ? _uploadImages
                  : null,
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  // Upload the selected images and add them to the profile and feed
  Future<void> _uploadImages() async {
    for (File imageFile in _selectedImages) {
      // TODO: Upload the image to the server and get the image URL
      String imageUrl = 'https://unsplash.com/photos/BPa51nyK1_U';

      // TODO: Add the uploaded image to the profile
      addToProfile(imageUrl);

      // TODO: Add the uploaded image to the feed, along with the selected music and description
      addToFeed(imageUrl, _selectedMusic, _description);

      // TODO: Show a success message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('The photo has been uploaded successfully.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    // TODO: Clear the selected images, music, and description
    setState(() {
      _controller.clear();
      _selectedImages.clear();
      _selectedMusic = "\0";
      _description = "\0";
    });
  }

  // TODO: Implement these two methods to add the uploaded images to the profile and feed
  void addToProfile(String imageUrl) {}
  void addToFeed(String imageUrl, String music, String description) {}
}
