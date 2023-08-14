import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailDCT extends StatefulWidget {
  @override
  _DetailDCTState createState() => _DetailDCTState();
}

class _DetailDCTState extends State<DetailDCT> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'assets/files/dct1.jpg',
    'assets/files/dct2.jpg',
    'assets/files/dct3.jpg',
    'assets/files/dct4.jpg',
    'assets/files/dct5.jpg',
    'assets/files/dct6.jpg',
    'assets/files/dct7.jpg',
    'assets/files/dct8.jpg',
    'assets/files/dct9.jpg',
    'assets/files/dct10.jpg',
    'assets/files/dct11.jpg',
    'assets/files/dct12.jpg',
    'assets/files/dct13.jpg',
    'assets/files/dct14.jpg',
    'assets/files/dct15.jpg',
    'assets/files/dct16.jpg',
    'assets/files/dct17.jpg',
    'assets/files/dct18.jpg',
    'assets/files/dct19.jpg',
    'assets/files/dct20.jpg',
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
          "Materi qDCT",
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
