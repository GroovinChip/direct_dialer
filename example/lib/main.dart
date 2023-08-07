import 'dart:io';

import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const DirectDialerExample(),
    );
  }
}

class DirectDialerExample extends StatefulWidget {
  const DirectDialerExample({Key? key}) : super(key: key);

  @override
  State<DirectDialerExample> createState() => _DirectDialerExampleState();
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
                decoration: const InputDecoration(
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
                      icon: const Icon(Icons.phone),
                      label: const Text('DIAL'),
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
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.video_call),
                      label: const Text('FACETIME VIDEO'),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          final dialer = await DirectDialer.instance;
                          await dialer.dialFaceTime(_controller.text, true);
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.phone_in_talk),
                      label: const Text('FACETIME AUDIO'),
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
