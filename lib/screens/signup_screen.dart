import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ta_capstone/entry_point.dart';
import 'package:ta_capstone/reusable_widget/reusable_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ta_capstone/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  bool _showPassword = false;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('users_regis_apps');
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
      'name_db': _usernameTextController.text,
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

  void _signUpButtonPressed() {
    if (_usernameTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter username, email, and password."),
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
    } else if (!_isValidEmail(_emailTextController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email address."),
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
    } else if(_passwordTextController.text.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Password must be at least six characters."),
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
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) {
        print("Created New Account");
        final userId = FirebaseAuth.instance.currentUser?.uid;
        _addUsers(userId ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInScreen()),
        );
      }).onError((error, stackTrace) {
        print("Error ${error.toString()}");
      });
    }
  }

  bool _isValidEmail(String email) {
  //format email
  final RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
  );
  return emailRegex.hasMatch(email);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/quantum.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 70,
                    ),
                    reusableTextField("Enter Username", Icons.person_outline,
                        false, _usernameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email", Icons.mail_outline, false,
                        _emailTextController),
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
                      height: 20,
                    ),
                    firebaseButton(context, "SIGN UP", _signUpButtonPressed),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
