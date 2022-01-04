import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Scroll to bottom demo")),
        body: ChatUI(),
      ),
    );
  }
}

class ChatUI extends StatefulWidget {
  createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  List<String> _messages = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;
  static const List<String> _possibleMessages = [
    "Hi!",
    "Hello.",
    "Bye forever!",
    "I'd really like to talk to you.",
    "Have you heard the news?",
    "I see you're using our website. Can I annoy you with a chat bubble?",
    "I miss you.",
    "I never want to hear from you again.",
    "You up?",
    ":-)",
    "ok",
  ];
  final Random _random = Random();

  reassemble() {
    super.reassemble();
    _timer?.cancel();
    _startTimer();
  }

  initState() {
    super.initState();
    _startTimer();
  }

  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _addMessage() {
    _messages.add(_possibleMessages[_random.nextInt(_possibleMessages.length)]);
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      setState(() {
        _addMessage();
        _needsScroll = true;
      });
    });
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToEnd());
    return ListView(
      controller: _scrollController,
      children: _messages.map((msg) => ChatBubble(msg)).toList(),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;

  const ChatBubble(this.text, {Key? key}) : super(key: key);

  build(_) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        child: Text(text),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: 200,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(bottom: 10, right: 10),
      ),
    );
  }
}
