import 'dart:io';

import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directDialer = await DirectDialer.init();
  runApp(
    MyApp(
      directDialer: directDialer,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.directDialer,
  }) : super(key: key);

  final DirectDialer directDialer;

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
      home: DirectDialerExample(
        directDialer: directDialer,
      ),
    );
  }
}

class DirectDialerExample extends StatefulWidget {
  const DirectDialerExample({
    Key? key,
    required this.directDialer,
  }) : super(key: key);

  final DirectDialer directDialer;
  @override
  _DirectDialerExampleState createState() => _DirectDialerExampleState();
}

class _DirectDialerExampleState extends State<DirectDialerExample> {
  final _controller = TextEditingController();

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
                    DialButton(
                      number: _controller.text,
                      dialer: widget.directDialer,
                    ),
                  ],
                  if (DirectDialer.onIpad || Platform.isMacOS) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: Icon(Icons.video_call),
                      label: Text('FACETIME VIDEO'),
                      onPressed: () async {
                        await widget.directDialer
                            .dialFaceTime(_controller.text, true);
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: Icon(Icons.phone_in_talk),
                      label: Text('FACETIME AUDIO'),
                      onPressed: () async {
                        await widget.directDialer
                            .dialFaceTime(_controller.text, false);
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

class DialButton extends StatelessWidget {
  const DialButton({
    Key? key,
    required this.number,
    required this.dialer,
  }) : super(key: key);

  final String number;
  final DirectDialer dialer;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.phone),
      label: Text('DIAL'),
      onPressed: () async {
        await dialer.dial(number);
      },
    );
  }
}
