import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:ta_capstone/screens/login_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(
                      CupertinoIcons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "WELCOME",
                    style: TextStyle(color: Colors.white),
                  ),
                  // subtitle: Text(
                  //   "Users",
                  //   style: TextStyle(color: Colors.white),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Browse".toUpperCase(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white70),
                  ),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Divider(
                        color: Colors.white,
                        height: 12,
                      ),
                    ),
                    const ListTile(
                      leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: RiveAnimation.asset(
                          "assets/RiveAssets/icons.riv",
                          artboard: "HOME",
                        ),
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Divider(
                        color: Colors.white,
                        height: 12,
                      ),
                    ),
                    // const ListTile(
                    //   leading: SizedBox(
                    //     height: 34,
                    //     width: 34,
                    //     child: RiveAnimation.asset(
                    //       "assets/RiveAssets/icons.riv",
                    //       artboard: "HOME",
                    //     ),
                    //   ),
                    //   title: Text(
                    //     "Home",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 15),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     height: 12,
                    //   ),
                    // ),
                    // const ListTile(
                    //   leading: SizedBox(
                    //     height: 34,
                    //     width: 34,
                    //     child: RiveAnimation.asset(
                    //       "assets/RiveAssets/icons.riv",
                    //       artboard: "HOME",
                    //     ),
                    //   ),
                    //   title: Text(
                    //     "Home",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 15),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     height: 12,
                    //   ),
                    // ),
                    // const ListTile(
                    //   leading: SizedBox(
                    //     height: 34,
                    //     width: 34,
                    //     child: RiveAnimation.asset(
                    //       "assets/RiveAssets/icons.riv",
                    //       artboard: "HOME",
                    //     ),
                    //   ),
                    //   title: Text(
                    //     "Home",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    // const SizedBox(height: 240),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 15),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     height: 12,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 150),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          FirebaseAuth.instance.signOut().then((value) {
                            print("Signed Out");
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const LogInScreen()));
                          });
                        },
                        icon: const SizedBox(
                          height: 34,
                          width: 34,
                          child: RiveAnimation.asset(
                            "assets/RiveAssets/icons.riv",
                            artboard: "EXIT",
                          ),
                        ),
                        label: const Text(
                          " Logout",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
