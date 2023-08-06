import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CobaAudio extends StatefulWidget {
  const CobaAudio({Key? key}) : super(key: key);

  @override
  _CobaAudioState createState() => _CobaAudioState();
}

class _CobaAudioState extends State<CobaAudio> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? audioUrl;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? currentPosition;

  @override
  void initState() {
    super.initState();
    loadAudioUrls();
  }

  Future<void> loadAudioUrls() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final refAudio =
          storage.ref().child('coba_coba/coba_audio/host_$userId.wav');
      final urlAudio = await refAudio.getDownloadURL();
      setState(() {
        audioUrl = urlAudio;
      });
    } catch (e) {
      setState(() {
        audioUrl = null;
      });
      print('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coba Audio"),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Audio Host",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildAudioPlayer1(),
            const SizedBox(height: 40),
            const Text(
              "Audio Terwatermark",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer1() {
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
                ],
              ),
            ],
          );
        }

  /*Widget _buildAudioPlayer2() {
    return audioUrl2 == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Duration>(
                stream: audioPlayer2.positionStream,
                builder: (context, snapshot) {
                  final position =
                      snapshot.data ?? currentPosition2 ?? Duration.zero;
                  final duration = audioPlayer2.duration ?? Duration.zero;
                  final value = position.inMilliseconds.toDouble();
                  final max = duration.inMilliseconds.toDouble();
                  final sliderValue = value.clamp(0.0, max);
                  return Slider(
                    value: sliderValue,
                    min: 0.0,
                    max: max,
                    activeColor: Color(0xFF93deff),
                    inactiveColor: Colors.white,
                    onChanged: (newValue) {
                      final newPosition =
                          Duration(milliseconds: newValue.round());
                      audioPlayer2.seek(newPosition);
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying2 ? Icons.pause : Icons.play_arrow,
                      color: Color(0xFF93deff),
                    ),
                    onPressed: () {
                      if (isPlaying2) {
                        audioPlayer2.pause();
                        setState(() {
                          isPlaying2 = false;
                        });
                      } else {
                        if (currentPosition2 == null) {
                          audioPlayer2.setUrl(audioUrl2!);
                        }
                        audioPlayer2.play();
                        setState(() {
                          isPlaying2 = true;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: Color(0xFF93deff),
                    ),
                    onPressed: () {
                      if (isPlaying2) {
                        audioPlayer2.stop();
                        audioPlayer2.seek(Duration.zero);
                        setState(() {
                          isPlaying2 = false;
                          currentPosition2 = Duration.zero;
                        });
                      } else {
                        audioPlayer2.seek(Duration.zero);
                        setState(() {
                          currentPosition2 = Duration.zero;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
  }*/
}
