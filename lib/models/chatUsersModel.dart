import 'package:flutter/cupertino.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';

class ChatUsers{
  String name;
  String messageText;
  String imageURL;
  String time;
  String msgindex;
  List<ChatMessage> messages=[];
  ChatUsers({required this.name,required this.messageText,required this.imageURL,required this.time, required this.msgindex,required this.messages});

  @override
  String toString() {
    return 'ChatUsers{name: $name, messageText: $messageText, imageURL: $imageURL, time: $time, msgindex: $msgindex}';
  }
}