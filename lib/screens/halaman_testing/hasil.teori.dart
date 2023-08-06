import 'package:flutter/material.dart';

class HasilTeori extends StatefulWidget {
  const HasilTeori({super.key});

  @override
  State<HasilTeori> createState() => _HasilTeoriState();
}

class _HasilTeoriState extends State<HasilTeori> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('HASIL TEORI'),
        ),
        
    );
  }
}