import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ta_capstone/screens/menu/embedding/hasil_embed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:mime_type/mime_type.dart';
import 'package:intl/intl.dart';

class EmbeddingPage extends StatefulWidget {
  @override
  _EmbeddingPageState createState() => _EmbeddingPageState();
}

class _EmbeddingPageState extends State<EmbeddingPage> {
  TextEditingController controller = TextEditingController();
  PlatformFile? pickedFile1;
  PlatformFile? pickedFile2;
  UploadTask? uploadTask;
  String? selectedItem;
  String? selectedEmbeddingMethod;
  bool isLoading = false;
  bool isFileSelected1 = false;
  bool isFileSelected2 = false;
  bool showLoading = false;
  bool isKeyVisible = false;

  Future uploadFiles() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final inputKey = controller.text.trim();
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final second = dateTime.second;
    final DateTime now = DateTime.now();
    final String formattedTimestamp =
        DateFormat('M/d/y, h:mm:ss a').format(now);

    if (pickedFile1 == null ||
        pickedFile2 == null ||
        selectedEmbeddingMethod == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
                "Pilih Metode, Audio Host, dan Citra Watermark terlebih dahulu"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (inputKey.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Masukkan kunci terlebih dahulu"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      showLoading = true;
    });

    final path1 =
        'audio-host/${userId}_${selectedEmbeddingMethod}_host_$timestamp.${pickedFile1!.extension}';
    final file1 = File(pickedFile1!.path!);

    final path2 =
        'citra-watermark/${userId}_${selectedEmbeddingMethod}_watermark_$timestamp.${pickedFile2!.extension}';
    final file2 = File(pickedFile2!.path!);

    final ref1 = FirebaseStorage.instance.ref().child(path1);
    final uploadTask1 = ref1.putFile(file1);

    final ref2 = FirebaseStorage.instance.ref().child(path2);
    final uploadTask2 = ref2.putFile(file2);

    await uploadTask1.whenComplete(() {});
    await uploadTask2.whenComplete(() {});

    final snapshot1 = await ref1.getDownloadURL();
    final urlDownload1 = snapshot1.toString();
    print('Download Link File 1: $urlDownload1');

    final snapshot2 = await ref2.getDownloadURL();
    final urlDownload2 = snapshot2.toString();
    print('Download Link File 2: $urlDownload2');

    final databaseReference = FirebaseDatabase.instance.ref();
    final hostFile =
        '${userId}_${selectedEmbeddingMethod}_host_$timestamp.${pickedFile1!.extension}';
    const hostPath = 'audio-host/';

    final watermarkFile =
        '${userId}_${selectedEmbeddingMethod}_watermark_$timestamp.${pickedFile2!.extension}';
    const watermarkPath = 'citra-watermark/';

    await databaseReference.child('file_host').child('$timestamp').set({
      'key': inputKey,
      'metode': selectedEmbeddingMethod,
      'nama_file': hostFile,
      'path_file': hostPath,
      'status': 0,
      'timestamp': formattedTimestamp,
      'uid': userId,
    });

    await databaseReference.child('file_watermark').child('$timestamp').set({
      'key': inputKey,
      'metode': selectedEmbeddingMethod,
      'nama_file': watermarkFile,
      'path_file': watermarkPath,
      'status': 0,
      'timestamp': formattedTimestamp,
      'uid': userId,
    });

    setState(() {
      pickedFile1 = null;
      pickedFile2 = null;
      selectedEmbeddingMethod = null;
    });

    controller.text = '';

    const loadingDuration = Duration(seconds: 40);
    Timer(loadingDuration, () {
      setState(() {
        showLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HasilEmbed()),
      );
    });
  }

  Future selectFile1() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;

    setState(() {
      pickedFile1 = result.files.first;
      isFileSelected1 = true;
    });
  }

  Future selectFile2() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedFile2 = result.files.first;
      isFileSelected2 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Embedding", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFF93deff),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: BlurryModalProgressHUD(
        inAsyncCall: showLoading,
        blurEffectIntensity: 4,
        progressIndicator: Stack(
          alignment: Alignment.center,
          children: [
            const SpinKitFadingCircle(
              color: Color(0xFF93deff),
              size: 90.0,
            ),
            if (showLoading)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 123),
                  Text(
                    'Please wait a moment',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
        dismissible: false,
        opacity: 0.4,
        color: Colors.black87,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wallpaper.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: <Widget>[
              const SizedBox(
                height: 35,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Proses embedding adalah proses penyisipan citra watermark terhadap audio host. Pada aplikasi ini audio host akan dipotong menjadi 3,5 detik dan citra watermark diubah menjadi citra BW (black-white) dengan ukuran 200x200. Data tersebut yang akan digunakan pada proses embedding.",
                    style: TextStyle(
                      color: Color(0xFFF7F7F7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Metode",
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 'lsb',
                    groupValue: selectedEmbeddingMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedEmbeddingMethod = value.toString();
                      });
                    },
                    activeColor: const Color(0xFFF7F7F7),
                    fillColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF7F7F7)),
                  ),
                  const Text(
                    "qLSB",
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                  Radio(
                    value: 'dct',
                    groupValue: selectedEmbeddingMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedEmbeddingMethod = value.toString();
                      });
                    },
                    activeColor: const Color(0xFFF7F7F7),
                    fillColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF7F7F7)),
                  ),
                  const Text(
                    "qDCT",
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                  Radio(
                    value: 'wavelet',
                    groupValue: selectedEmbeddingMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedEmbeddingMethod = value.toString();
                      });
                    },
                    activeColor: const Color(0xFFF7F7F7),
                    fillColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF7F7F7)),
                  ),
                  const Text(
                    "qWavelet",
                    style: TextStyle(color: Color(0xFFF7F7F7)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Audio Host",
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectFile1();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFF93deff),
                    ),
                    child: const Text(
                      "Choose File",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: pickedFile1 != null
                        ? Text(
                            _trimFilename(pickedFile1!.name, 30),
                            style: const TextStyle(color: Colors.white),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Citra Watermark",
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectFile2();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFF93deff),
                    ),
                    child: const Text(
                      "Choose File",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: pickedFile2 != null
                        ? Text(
                            _trimFilename(pickedFile2!.name, 30),
                            style: const TextStyle(color: Colors.white),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        icon: const Icon(
                          Icons.key,
                          size: 35,
                          color: Colors.white,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Masukkan Kunci antara 1 - 4",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: controller,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[1-4]')),
                        LengthLimitingTextInputFormatter(1),
                      ],
                      obscureText: !isKeyVisible,
                    ),
                    IconButton(
                      icon: Icon(
                        isKeyVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isKeyVisible = !isKeyVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    uploadFiles();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: const Color(0xFF93deff),
                  ),
                  child: const Text(
                    'Embed audio',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HasilEmbed(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: const Color(0xFF93deff),
                  ),
                  child: const Text(
                    "Lihat Hasil >>",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _trimFilename(String filename, int maxLength) {
    if (filename.length <= maxLength) {
      return filename;
    } else {
      return filename.substring(0, maxLength - 3) + '...';
    }
  }
}
