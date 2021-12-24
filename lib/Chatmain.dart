import 'helper_files/Websocket.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChatSocket());
}

class ChatSocket extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SocketDemo(),
    );
  }
}