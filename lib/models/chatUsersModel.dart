// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';

class ChatUsers {
  String? name;
  String? messageText;
  String? imageURL;
  String? time;
  int? msgindex;
  List<ChatMessage>? messages;
  String? actionBy;
  String? chatId;
  String? eId;
  ChatUsers(
      {required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time,
      required this.msgindex,
      required this.messages,
      required this.actionBy,
      required this.chatId,
      required this.eId});

  ChatUsers.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageUrl'];
    name = json['name'];
    // msgindex = json['msgindex'] as int?;
    //imageFile = json['imageFile'];
    if (json['messages'] != null) {
      messages = <ChatMessage>[];
      json['messages'].forEach((v) {
        messages!.add(new ChatMessage.fromJson(v));
      });
    }
    actionBy = json['actionBy'];
    chatId = json['chatId'];
    eId = json['eId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageURL;
    data['name'] = this.name;
    // data['msgindex'] = this.msgindex;
    //data['imageFile'] = this.imageFile;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['actionBy'] = this.actionBy;
    data['chatId'] = this.chatId;
    data['eId'] = this.eId;
    return data;
  }

  @override
  String toString() {
    return 'ChatUsers{name: $name, messageText: $messageText, imageURL: $imageURL, time: $time, msgindex: $msgindex}';
  }
}
