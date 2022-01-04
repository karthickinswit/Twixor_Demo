import 'package:flutter/cupertino.dart';

class ChatMessage {
  String? messageContent;
  String? messageType;
  bool? isUrl;
  String? contentType;
  String? url;
  String? actionBy;
  String? chatId;
  String? eId;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.isUrl,
      required this.contentType,
      required this.url,
      required this.actionBy,
      required this.chatId,
      required this.eId});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    messageContent = json['messageContent'];
    messageType = json['messageType'];
    isUrl = json['isUrl'];
    contentType = json['contentType'];
    url = json['url'];
    actionBy = json['actionBy'];
    chatId = json['chatId'];
    eId = json['eId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageContent'] = this.messageContent;
    data['messageType'] = this.messageType;
    data['isUrl'] = this.isUrl;
    data['contentType'] = this.contentType;
    data['url'] = this.url;
    data['actionBy'] = this.actionBy;
    data['chatId'] = this.chatId;
    data['eId'] = this.eId;
    return data;
  }
}
