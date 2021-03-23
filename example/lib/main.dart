import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:call_number/call_number.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter the Number',
            ),
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () async {
              if (_controller.text != null)
                await CallNumber.callNumber(_controller.text);
            },
          ),
        ]),
      ),
    );
  }
}
