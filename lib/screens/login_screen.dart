import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ta_capstone/entry_point.dart';
import 'package:ta_capstone/reusable_widget/reusable_widget.dart';
import 'package:ta_capstone/reusable_widget/square_tile.dart';
import 'package:ta_capstone/screens/reset_password.dart';
import 'package:ta_capstone/screens/signup_screen.dart';
import 'package:ta_capstone/services/firebase_services.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _showPassword = false;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('users_login_apps');
  }

  void _addUsers(String userID) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final DateTime dateTime =
        DateTime.fromMicrosecondsSinceEpoch(timestamp);
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final second = dateTime.second;
    Map<String, String> users = {
      'email_db': _emailTextController.text,
      'password_db': _passwordTextController.text,
      'userId': userId ?? '',
      'timestamp': '$year-$month-$day $hour:$minute:$second',
    };

    dbRef.child(userID).set(users).then((_) {
      print("Data pengguna berhasil ditambahkan.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EntryPoint()),
      );
    }).catchError((error) {
      print("Terjadi kesalahan saat menambahkan data pengguna: $error");
    });
  }

  void _loginButtonPressed() {
    if (_emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter email and password."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      )
          .then((value) {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        _addUsers(userId ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EntryPoint()),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Invalid Email or Password, please try again."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/quantum.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/log.png",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField(
                    "Enter Email",
                    Icons.mail_outline,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordTextController,
                    obscureText: !_showPassword,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      filled: true,
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.grey.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                              color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  firebaseButton(context, "LOGIN", _loginButtonPressed),
                  signUpOption(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await FirebaseServices().signInWithGoogle();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntryPoint()));
                        },
                        child: const SquareTile(
                          imagePath: 'assets/images/google.png',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Lupa Password?",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPassword()));
        },
      ),
    );
  }
}
