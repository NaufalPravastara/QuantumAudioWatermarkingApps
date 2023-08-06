import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ta_capstone/screens/halaman_testing/coba_audio.dart';
import 'package:ta_capstone/screens/halaman_testing/coba_gambar.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:ta_capstone/screens/halaman_testing/test_down.dart';

class TeoriPage extends StatefulWidget {
  @override
  _TeoriPageState createState() => _TeoriPageState();
}

class _TeoriPageState extends State<TeoriPage> {
  PlatformFile? pickedFile1;
  PlatformFile? pickedFile2;
  UploadTask? uploadTask;
  bool isLoading = false;
  bool isFileSelected1 = false;
  bool isFileSelected2 = false;


  Future uploadFile() async {
    if (pickedFile1 != null) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final path = 'coba_coba/coba_audio/host_$userId.wav';
      final file = File(pickedFile1!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link $urlDownload');

      setState(() {
        uploadTask = null;
        isLoading = true;
        pickedFile1 = null;
      });
    }

    if (pickedFile2 != null) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final path = 'coba_coba/coba_gambar/watermark_$userId.jpg';
      final file = File(pickedFile2!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link $urlDownload');

      setState(() {
        uploadTask = null;
        isLoading = false;
        pickedFile2 = null;
      });
    }
  }

  Future selectFile1() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile1 = result.files.first;
      isFileSelected1 = true;
    });
  }

  Future selectFile2() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile2 = result.files.first;
      isFileSelected2 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('TEORI'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: selectFile1,
                      child: Text("Pick File 1"),
                    ),
                    SizedBox(height: 5),
                    pickedFile1 != null ? Text(pickedFile1!.name) : SizedBox(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectFile2,
                      child: Text("Pick File 2"),
                    ),
                    SizedBox(height: 5),
                    pickedFile2 != null ? Text(pickedFile2!.name) : SizedBox(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (pickedFile1 == null || pickedFile2 == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pilih kedua file terlebih dahulu'),
                            ),
                          );
                        } else{
                          final progress = ProgressHUD.of(context);
                          progress?.show(); // Menampilkan animasi loading
                          uploadFile().then((_) {
                            progress?.dismiss(); // Menyembunyikan animasi loading
                          });
                        }
                      },
                      child: Text("Upload File"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CobaAudio()),
                        );
                      },
                      child: Text("Next page Audio"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CobaGambar()),
                        );
                      },
                      child: Text("Next Page Gambar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailLSB()),
                        );
                      },
                      child: Text("Next Page download"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
