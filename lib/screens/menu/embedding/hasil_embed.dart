import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HasilEmbed extends StatefulWidget {
  const HasilEmbed({Key? key}) : super(key: key);

  @override
  State<HasilEmbed> createState() => _HasilEmbedState();
}

class _HasilEmbedState extends State<HasilEmbed> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? audioUrl;
  String? text;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? currentPosition;
  String? newMatFileUrl;

  @override
  void initState() {
    super.initState();
    loadAudioUrl();
    loadTextFile();
    loadNewMatFileUrl();
  }

  Future<String> loadTextFile() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final refText =
          storage.ref().child('hasil-embedding/${userId}_terwatermark/SNR.txt');
      final fileUrl = await refText.getDownloadURL();
      final file = await DefaultCacheManager().getSingleFile(fileUrl);
      final text = await file.readAsString();
      print('File downloaded and read: $text');
      return text;
    } catch (e) {
      print('Error loading text file: $e');
      return '';
    }
  }

  Future<void> loadAudioUrl() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String userId = user.uid;
        final refAudio = storage.ref().child(
            'hasil-embedding/${userId}_terwatermark/watermarked_audio.wav');
        final urlAudio = await refAudio.getDownloadURL();
        if (mounted) {
          setState(() {
            audioUrl = urlAudio;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          audioUrl = null;
        });
      }
      print('Error loading audio: $e');
    }
  }

  Future<void> downloadAudio() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If the user is not logged in, show a message and return
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Anda harus masuk terlebih dahulu untuk mendownload file.'),
        ),
      );
      return;
    }
    String userId = user.uid;
    String _filePath =
        'hasil-embedding/${userId}_terwatermark/watermarked_audio.wav';

    try {
      // Referensi ke file di Firebase Storage
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(_filePath);

      // Mendapatkan metadata file dari Firebase Storage
      final metadata = await ref.getMetadata();

      // Mendapatkan nama file dari metadata
      String filename =
          metadata.name; // Jika metadata.name null, gunakan 'default_audio.wav'

      // Mendownload file ke perangkat dengan nama sesuai di Firebase Storage
      File file = File('/storage/emulated/0/Download/$filename');
      await ref.writeToFile(file);

      // Mendapatkan timestamp saat ini
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Ganti nama file setelah didownload
      String newFileName = 'watermarked_audio_$timestamp.wav';
      File renamedFile =
          await file.rename('/storage/emulated/0/Download/$newFileName');

      // Tampilkan pesan jika download berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10),
              Text('Downloading watermarked_audio.wav'),
            ],
          ),
        ),
      );
    } catch (e) {
      // Tampilkan pesan jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mendownload file.'),
        ),
      );
    }
  }

  Future<void> loadNewMatFileUrl() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final refMatFile = FirebaseStorage.instance
          .ref()
          .child('hasil-embedding/${userId}_terwatermark/data.mat');
      final url = await refMatFile.getDownloadURL();
      setState(() {
        newMatFileUrl = url;
      });
    } catch (e) {
      setState(() {
        newMatFileUrl = null;
      });
      print('Error loading new .mat file: $e');
    }
  }

  Future<void> downloadAndSaveMatFile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If the user is not logged in, show a message and return
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Anda harus masuk terlebih dahulu untuk mendownload file.'),
        ),
      );
      return;
    }

    String userId = user.uid;
    String _filePath = 'hasil-embedding/${userId}_terwatermark/data.mat';

    try {
      // Referensi ke file di Firebase Storage
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(_filePath);

      // Mendapatkan metadata file dari Firebase Storage
      final metadata = await ref.getMetadata();

      // Mendapatkan nama file dari metadata
      String filename =
          metadata.name; // Jika metadata.name null, gunakan 'default_audio.wav'

      // Mendownload file ke perangkat dengan nama sesuai di Firebase Storage
      File file = File('/storage/emulated/0/Download/$filename');
      await ref.writeToFile(file);

      // Mendapatkan timestamp saat ini
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Ganti nama file setelah didownload
      String newFileName = 'data_$timestamp.mat';
      File renamedFile =
          await file.rename('/storage/emulated/0/Download/$newFileName');

      // Tampilkan pesan jika download berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10),
              Text('Downloading data.mat'),
            ],
          ),
        ),
      );
    } catch (e) {
      // Tampilkan pesan jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mendownload file.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (mounted) {
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await loadAudioUrl();
        await loadTextFile();
        await loadNewMatFileUrl();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("HASIL EMBEDDING",
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: const Color(0xFF93deff),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/wallpaper.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "Audio Terwatermark",
                    style: TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildAudioPlayer(),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: downloadAndSaveMatFile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF93deff)),
                    child: const Text(
                      'Unduh .mat File',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "SNR",
                    style: TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: loadTextFile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for data, show an empty Container
                      return Container();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error loading text file',
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasData) {
                      final text = snapshot.data as String;
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      // No data available, return the text here
                      return const Text(
                        'No data available',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return audioUrl == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position =
                      snapshot.data ?? currentPosition ?? Duration.zero;
                  final duration = audioPlayer.duration ?? Duration.zero;
                  final value = position.inMilliseconds.toDouble();
                  final max = duration.inMilliseconds.toDouble();
                  final sliderValue = value.clamp(0.0, max);
                  return Slider(
                    value: sliderValue,
                    min: 0.0,
                    max: max,
                    activeColor: const Color(0xFF93deff),
                    inactiveColor: Colors.white,
                    onChanged: (newValue) {
                      final newPosition =
                          Duration(milliseconds: newValue.round());
                      audioPlayer.seek(newPosition);
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFF93deff),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        if (currentPosition == null) {
                          audioPlayer.setUrl(audioUrl!);
                        }
                        audioPlayer.play();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.stop,
                      color: Color(0xFF93deff),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        audioPlayer.stop();
                        audioPlayer.seek(Duration.zero);
                        setState(() {
                          isPlaying = false;
                          currentPosition = Duration.zero;
                        });
                      } else {
                        audioPlayer.seek(Duration.zero);
                        setState(() {
                          currentPosition = Duration.zero;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.download,
                      color: Color(0xFF93deff),
                    ),
                    onPressed: downloadAudio,
                  )
                ],
              ),
            ],
          );
  }
}
