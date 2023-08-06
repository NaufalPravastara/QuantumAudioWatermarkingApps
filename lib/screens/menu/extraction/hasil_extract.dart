import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';

class HasilExtract extends StatefulWidget {
  const HasilExtract({Key? key}) : super(key: key);

  @override
  State<HasilExtract> createState() => _HasilExtractState();
}

class _HasilExtractState extends State<HasilExtract> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? imageUrl;
  String? audioUrl;
  String? text;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? currentPosition;
  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    isMounted = true;
    loadImageUrls();
    loadTextFile();
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  Future<void> loadImageUrls() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final ref = storage
          .ref()
          .child('hasil-ekstraksi/${userId}_hekstrak/detected_watermark.jpg');

      final url1 = await ref.getDownloadURL();
      if (isMounted) {
        setState(() {
          imageUrl = url1;
        });
      }
    } catch (e) {
      if (isMounted) {
        setState(() {
          imageUrl = null;
        });
      }
      print('Error loading images: $e');
    }
  }

  Future<void> downloadImage(String? imageUrl, String imageName) async {
    if (imageUrl != null) {
      try {
        final file = await DefaultCacheManager().getSingleFile(imageUrl);
        await GallerySaver.saveImage(file.path);
        print('Image downloaded and saved to gallery: ${file.path}');
      } catch (e) {
        print('Error downloading image: $e');
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 10),
            Text('Downloading $imageName...'),
          ],
        ),
      ),
    );
  }

  Future<String> loadTextFile() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final refText =
          storage.ref().child('hasil-ekstraksi/${userId}_hekstrak/BER.txt');
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        await loadImageUrls();
        await loadTextFile();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("HASIL EXTRACTION",
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
                    "Citra Watermark",
                    style: TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                imageUrl == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              width: 270,
                              height: 204,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 5),
                          IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Color(0xFF93deff),
                            ),
                            onPressed: () => downloadImage(imageUrl, 'image.jpg'),
                          )
                        ],
                      ),
                const Center(
                  child: Text(
                    "BER",
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading text file');
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
                      return const Text('No data available');
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
}
