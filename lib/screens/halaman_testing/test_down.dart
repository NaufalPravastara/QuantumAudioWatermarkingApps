import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class DetailLSB extends StatefulWidget {
  const DetailLSB({Key? key});

  @override
  State<DetailLSB> createState() => _DetailLSBState();
}

class _DetailLSBState extends State<DetailLSB> {
  void _downloadAndSaveFile() async {
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
    String _filePath = 'hasil-embedding/${userId}_terwatermark/watermarked_audio.wav';

    try {
      // Referensi ke file di Firebase Storage
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(_filePath);

      // Mendapatkan metadata file dari Firebase Storage
      final metadata = await ref.getMetadata();

      // Mendapatkan nama file dari metadata
      String filename = metadata.name; // Jika metadata.name null, gunakan 'default_audio.wav'

      // Mendownload file ke perangkat dengan nama sesuai di Firebase Storage
      File file = File('/storage/emulated/0/Download/$filename');
      await ref.writeToFile(file);

      // Mendapatkan timestamp saat ini
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Ganti nama file setelah didownload
      String newFileName = 'audio_$timestamp.wav';
      File renamedFile =
          await file.rename('/storage/emulated/0/Download/$newFileName');

      // Tampilkan pesan jika download berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'File berhasil didownload dan disimpan di perangkat dengan nama: $newFileName'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download dari Firebase Storage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _downloadAndSaveFile,
          child: Text('Download dan Simpan File'),
        ),
      ),
    );
  }
}
