import 'package:flutter/cupertino.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  bool isUrl;
  ChatMessage({required this.messageContent, required this.messageType,required this.isUrl});
}