import 'package:flutter/material.dart';
import 'package:ta_capstone/screens/dasar_teori/wavelet/details_wav.dart';
import 'package:ta_capstone/screens/dasar_teori/wavelet/quiz_wav.dart';

class MenuWave extends StatefulWidget {
  const MenuWave({Key? key}) : super(key: key);

  @override
  State<MenuWave> createState() => _MenuWaveState();
}

class _MenuWaveState extends State<MenuWave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("qWavelet",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF93deff),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wallpaper.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailWav()));
                    },
                    child: Column(
                      children: const [
                        Image(
                          image: AssetImage("assets/images/teori.png"),
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Lihat Materi",
                          style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7F7F7)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => QuizWav()));
                    },
                    child: Column(
                      children: const [
                        Image(
                          image: AssetImage("assets/images/quiz.png"),
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Quiz",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7F7F7)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
