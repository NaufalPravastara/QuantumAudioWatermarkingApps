import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_capstone/screens/halaman_testing/teori.dart';
import 'package:ta_capstone/screens/menu/embedding/embedding.dart';
import 'package:ta_capstone/screens/menu/extraction/extraction.dart';
import 'package:ta_capstone/screens/dasar_teori/dct/menu_dct.dart';
import 'package:ta_capstone/screens/dasar_teori/lsb/menu_lsb.dart';
import 'package:ta_capstone/screens/dasar_teori/wavelet/menu_wav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Methods",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: const Color(0xFFF7F7F7),
                          fontWeight: FontWeight.w600)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MenuDct()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            height: 280,
                            width: 260,
                            decoration: const BoxDecoration(
                              color: Color(0xFF93deff),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("qDCT",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 12, bottom: 8),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Discrete Cosine Transform adalah salah satu teknik yang digunakan untuk mengubah sinyal domain klasik menjadi domain frekuensi, begitu juga sebaliknya domain frekuensi dapat dikembalikan menjadi domain klasik menggunakan invers DCT (IDCT).",
                                            style:
                                                TextStyle(color: Colors.black),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      const Text(
                                        "Tap to see details >>>",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset("assets/images/profile_img.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MenuLsb()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            height: 280,
                            width: 260,
                            decoration: const BoxDecoration(
                              color: Color(0xFF93deff),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("qLSB",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 12, bottom: 8),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Least Significant Bits (LSB) adalah salah satu metode watermarking yang paling sering digunakan. Dalam metode klasik,metode LSB cukup populer dan sering digunakan, karena memiliki algoritma yang sederhana dan komputasi yang rendah.",
                                            style:
                                                TextStyle(color: Colors.black),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      const Text(
                                        "Tap to see details >>>",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset("assets/images/profile_img.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MenuWave()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            height: 280,
                            width: 260,
                            decoration: const BoxDecoration(
                              color: Color(0xFF93deff),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("qWavelet",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 12, bottom: 8),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Discrete Wavelet Transform (DWT) adalah suatu teknik pemrosesan sinyal yang digunakan untuk menganalisis dan mengubah sinyal menjadi komponen frekuensi dan waktu. ",
                                            style:
                                                TextStyle(color: Colors.black),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 58),
                                      const Text(
                                        "Tap to see details >>>",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset("assets/images/profile_img.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Menu",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmbeddingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      primary: const Color(0xFF93deff),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Embedding",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SvgPicture.asset(
                          "assets/images/embed.svg",
                          width: 48,
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExtractionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      primary: const Color(0xFF93deff),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Extraction",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          "assets/images/extract.png",
                          width: 48,
                          height: 36,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30, right: 30),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context, MaterialPageRoute(builder: (context) => TeoriPage()),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                //       primary: const Color(0xFF93deff),
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(20)),
                //       ),
                //     ),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: Column(
                //             children: [
                //               Text(
                //                 "Manual Book",
                //                 style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                //               ),
                //             ],
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 40,
                //           child: VerticalDivider(
                //             color: Colors.black,
                //           ),
                //         ),
                //         const SizedBox(width: 8,),
                //         Image.asset("assets/images/book.png", width: 48, height: 50,)
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<bool> onBackPressed() {
    // Disable the back button functionality by doing nothing.
    // Return 'true' to indicate that the back button is handled and no further action should be taken.
    return Future.value(true);
  }
}
