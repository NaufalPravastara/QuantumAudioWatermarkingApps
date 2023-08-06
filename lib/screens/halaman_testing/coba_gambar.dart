import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CobaGambar extends StatefulWidget {
  const CobaGambar({Key? key}) : super(key: key);

  @override
  _CobaGambarState createState() => _CobaGambarState();
}

class _CobaGambarState extends State<CobaGambar> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? imageUrl1;
  String? imageUrl2;

  @override
  void initState() {
    super.initState();
    loadImageUrls();
  }

  Future<void> loadImageUrls() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user!.uid;
      final ref1 = storage.ref().child('coba_coba/coba_gambar/watermark_$userId.jpg');
      final ref2 = storage.ref().child('coba_coba/coba_gambar/watermark.jpg');
      final url1 = await ref1.getDownloadURL();
      final url2 = await ref2.getDownloadURL();
      setState(() {
        imageUrl1 = url1;
        imageUrl2 = url2;
      });
    } catch (e) {
      setState(() {
        imageUrl1 = null;
        imageUrl2 = null;
      });
      print('Error loading images: $e');
    }
  }

  Future<void> downloadImage1() async {
    await downloadImage(imageUrl1, 'Image 1');
  }

  Future<void> downloadImage2() async {
    await downloadImage(imageUrl2, 'Image 2');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coba Gambar',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF93deff),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: Container(
        margin: const EdgeInsets.fromLTRB(70, 100, 10, 0),
        child: Column(
          children: [
            const Text(
              'Citra Watermark',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7F7F7),
              ),
            ),
            const SizedBox(height: 20),
            imageUrl1 == null || imageUrl2 == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl1!,
                        width: 270,
                        height: 204,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: downloadImage1,
                        child: const Text('Download Image 1'),
                      ),
                      const SizedBox(height: 10,),
                      CachedNetworkImage(
                        imageUrl: imageUrl2!,
                        width: 270,
                        height: 204,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: downloadImage2,
              child: const Text('Download Image 2'),
            ),
          ],
        ),
      ),
    );
  }
}
