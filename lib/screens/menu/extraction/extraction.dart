import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ta_capstone/screens/menu/extraction/hasil_extract.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ExtractionPage extends StatefulWidget {
  @override
  State<ExtractionPage> createState() => _ExtractionPageState();
}

class _ExtractionPageState extends State<ExtractionPage> {
  TextEditingController controller = TextEditingController();
  PlatformFile? pickedFile1;
  // PlatformFile? pickedFile2;
  UploadTask? uploadTask;
  List<String> dropdownItems1 = [
    'Tanpa Serangan',
    'Pauli-X',
    'Pauli-Z',
    'Pauli-CNOT'
  ];
  List<String> dropdownItems2 = [
    '0.001',
    '0.005',
    '0.01',
    '0.05',
    '0.1',
    '0.5',
    '0.9',
  ];
  String? watermarkType1;
  String? watermarkType2;
  String? selectedEmbeddingMethod;
  bool showLoading = false;
  bool isFileSelected1 = false;
  // bool isFileSelected2 = false;
  bool isKeyVisible = false;

  Map<String, String> dropdownMapping1 = {
    'Tanpa Serangan': '0',
    'Pauli-X': '1',
    'Pauli-Z': '2',
    'Pauli-CNOT': '3'
  };

  Map<String, String> dropdownMapping2 = {
    '0.001': '1',
    '0.005': '5',
    '0.01': '10',
    '0.05': '50',
    '0.1': '100',
    '0.5': '500',
    '0.9': '900',
  };

  Future uploadFile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final inputKey = controller.text.trim();
    final newName1 = dropdownMapping1[watermarkType1];
    final newName2 = dropdownMapping2[watermarkType2];
    final newName3 = '100';
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
        selectedEmbeddingMethod == null ||
        watermarkType1 == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
                "Pilih Metode, Audio Terwatermark, Serangan dan Noise terlebih dahulu"),
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

    String path1;

    if (watermarkType1 == 'Tanpa Serangan') {
      path1 =
          'ekstraksi/${userId}_${selectedEmbeddingMethod}_${newName1}_ekstrak_$timestamp.${pickedFile1!.extension}';
    } else {
      path1 =
          'ekstraksi/${userId}_${selectedEmbeddingMethod}_${newName1}_${newName2}_ekstrak_$timestamp.${pickedFile1!.extension}';
    }
    final file1 = File(pickedFile1!.path!);

    final ref1 = FirebaseStorage.instance.ref().child(path1);
    final uploadTask1 = ref1.putFile(file1);

    await uploadTask1.whenComplete(() {});

    final snapshot1 = await ref1.getDownloadURL();
    final urlDownload1 = snapshot1.toString();
    print('Download Link File 1: $urlDownload1');

    final databaseReference = FirebaseDatabase.instance.ref();
    String probNoiseValue;

    if (watermarkType1 == 'Tanpa Serangan') {
      probNoiseValue = newName3;
    } else {
      probNoiseValue = newName2!;
    }

    String ekstrakFile;
    if (watermarkType1 == 'Tanpa Serangan') {
      ekstrakFile =
          '${userId}_${selectedEmbeddingMethod}_${newName1}_ekstrak_$timestamp.${pickedFile1!.extension}';
    } else {
      ekstrakFile =
          '${userId}_${selectedEmbeddingMethod}_${newName1}_${newName2}_ekstrak_$timestamp.${pickedFile1!.extension}';
    }
    const ekstrakPath = 'ekstraksi/';

    await databaseReference.child('file_terwatermark').child('$timestamp').set({
      'key': inputKey,
      'attack': newName1,
      'prob_noise': probNoiseValue,
      'metode': selectedEmbeddingMethod,
      'nama_file': ekstrakFile,
      'path_file': ekstrakPath,
      'status': 0,
      'timestamp': formattedTimestamp,
      'uid': userId,
    });

    setState(() {
      pickedFile1 = null;
      selectedEmbeddingMethod = null;
      watermarkType1 = null;
      watermarkType2 = null;
    });

    controller.text = '';

    const loadingDuration = Duration(seconds: 20);
    Timer(loadingDuration, () {
      setState(() {
        showLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HasilExtract()),
      );
    });
  }

  Future selectFile1() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;

    setState(() {
      pickedFile1 = result.files.first;
      watermarkType1 = 'Tanpa Serangan';
      isFileSelected1 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Extraction",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF93deff),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    "Proses ekstraksi adalah proses pengambilan kembali citra watermark yang telah disisipkan. Pada proses ini audio hasil embedding akan diubah kembali ke domain kuantum dan dilakukan pengambilan watermark. Pada proses ini juga dapat ditambahkan serangan dengan  tingkat kerusakan yang dapat diatur.",
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
                "Metode:",
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
                "Audio Terwatermark",
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
                            borderRadius: BorderRadius.circular(14)),
                        backgroundColor: const Color(0xFF93deff)),
                    child: const Text(
                      "Choose File",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                "Pilih Serangan",
                style: TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF93deff),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFF93deff),
                      ),
                      child: DropdownButton<String>(
                        value: watermarkType1,
                        items: dropdownItems1.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(item),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            watermarkType1 = newValue!;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        hint: const Text(
                          '  Pilih Serangan',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    // if (watermarkType1 == 'Pauli-X')
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(height: 16),
                    //       Container(
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.white,
                    //             width: 1.0,
                    //           ),
                    //         ),
                    //         child: const Text(
                    //           "Pauli-X adalah ",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 14),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // if (watermarkType1 == 'Pauli-Z')
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(height: 16),
                    //       Container(
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.white,
                    //             width: 1.0,
                    //           ),
                    //         ),
                    //         child: const Text(
                    //           "Pauli-Z adalah ",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 14),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // if (watermarkType1 == 'Pauli-CNOT')
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(height: 16),
                    //       Container(
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.white,
                    //             width: 1.0,
                    //           ),
                    //         ),
                    //         child: const Text(
                    //           "Pauli-CNOT adalah ",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 14),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    if (watermarkType1 != 'Tanpa Serangan')
                      const SizedBox(
                        height: 16,
                      ),
                    if (watermarkType1 != 'Tanpa Serangan')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Probabilitas Noise",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF93deff),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFF93deff),
                            ),
                            child: DropdownButton<String>(
                              value: watermarkType2,
                              items: dropdownItems2.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(item),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  watermarkType2 = newValue!;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              hint: const Text(
                                '  0,01',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
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
                    uploadFile();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      backgroundColor: const Color(0xFF93deff)),
                  child: const Text(
                    'Extract audio',
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
                            builder: (context) => const HasilExtract()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFF93deff)),
                  child: const Text(
                    'Lihat hasil >>',
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
