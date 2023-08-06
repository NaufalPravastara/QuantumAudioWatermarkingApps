import 'package:flutter/material.dart';
import 'package:ta_capstone/screens/dasar_teori/dct/details_dct.dart';
import 'package:ta_capstone/screens/dasar_teori/dct/quiz_dct.dart';

class MenuDct extends StatefulWidget {
  const MenuDct({Key? key}) : super(key: key);

  @override
  State<MenuDct> createState() => _MenuDctState();
}

class _MenuDctState extends State<MenuDct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "qDCT",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
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
                                  DetailDCT()));
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
                          MaterialPageRoute(builder: (context) => QuizDct()));
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
