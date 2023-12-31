import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailWav extends StatefulWidget {
  @override
  _DetailWavState createState() => _DetailWavState();
}

class _DetailWavState extends State<DetailWav> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'assets/files/w1.jpg',
    'assets/files/w2.jpg',
    'assets/files/w3.jpg',
    'assets/files/w4.jpg',
    'assets/files/w5.jpg',
    'assets/files/w6.jpg',
    'assets/files/w7.jpg',
    'assets/files/w8.jpg',
    'assets/files/w9.jpg',
    'assets/files/w10.jpg',
    'assets/files/w11.jpg',
    'assets/files/w12.jpg',
    'assets/files/w13.jpg',
    'assets/files/w14.jpg',
    'assets/files/w15.jpg',
    'assets/files/w16.jpg',
    'assets/files/w17.jpg',
    'assets/files/w18.jpg',
    'assets/files/w19.jpg',
    'assets/files/w20.jpg',
    'assets/files/w21.jpg',
  ];

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _current = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Mengunci tampilan halaman ini ke orientasi potret saja
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Mengembalikan preferensi tampilan ke mode default setelah halaman ini dihapus
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Materi qWavelet",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF93deff),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: isPortrait ? height : height * 0.5,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
              ),
              items: imgList
                  .map((item) => Container(
                        child: Center(
                            child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          height: isPortrait ? height : height * 0.5,
                        )),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${_current + 1}/${imgList.length}",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

// Halaman lain yang tidak dikunci orientasinya (bisa berubah menjadi orientasi lanskap)
class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Lain"),
      ),
      body: Center(
        child: Text("Halaman lain dapat berubah menjadi orientasi lanskap."),
      ),
    );
  }
}



