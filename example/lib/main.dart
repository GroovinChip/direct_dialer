import 'dart:io';

import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
      ),
      home: DirectDialerExample(),
    );
  }
}

class DirectDialerExample extends StatefulWidget {
  @override
  _DirectDialerExampleState createState() => _DirectDialerExampleState();
}

class _DirectDialerExampleState extends State<DirectDialerExample> {
  late DirectDialer dialer;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupDialer();
  }

  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DirectDialer Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (Platform.isAndroid ||
                      (Platform.isIOS && !DirectDialer.onIpad)) ...[
                    ElevatedButton.icon(
                      icon: Icon(Icons.phone),
                      label: Text('DIAL'),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          await dialer.dial(_controller.text);
                        }
                      },
                    )
                  ],
                  if (DirectDialer.onIpad || Platform.isMacOS) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: Icon(Icons.video_call),
                      label: Text('FACETIME VIDEO'),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          final dialer = await DirectDialer.instance;
                          await dialer.dialFaceTime(_controller.text, true);
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: Icon(Icons.phone_in_talk),
                      label: Text('FACETIME AUDIO'),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          final dialer = await DirectDialer.instance;
                          await dialer.dialFaceTime(_controller.text, false);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
