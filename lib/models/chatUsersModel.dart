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
    name = json["customerName"] != null ? json["customerName"].toString() : "";
    messageText =
        json["lastMessage"] != null ? json["lastMessage"].toString() : "";
    imageURL = json["customerIconUrl"] == null || json["customerIconUrl"] == ""
        ? 'asset/images/pp.png'
        : json["customerIconUrl"];
    time = json["lastModifiedOn"]["date"].toString();
    actionBy =
        json["handlingAgent"] != null ? json["handlingAgent"].toString() : "";
    chatId = json["chatId"] != null ? json["chatId"].toString() : "";
    eId = json["eId"] != null ? json["eId"].toString() : "";
    messages = <ChatMessage>[];
    json['messages'].forEach((v) {
      messages!.add(new ChatMessage.fromAPItoJson(v));
      print(v);
    });
    actionBy =
        json['handlingAgent'] != null ? json['handlingAgent'].toString() : "";
    chatId = json['chatId'] != null ? json["chatId"].toString() : "";
    ;
    eId = json['eId'] != null ? json["eId"].toString() : "";
  }

  ChatUsers.fromJson1(Map<String, dynamic> data) {
    imageURL = data['imageUrl'];
    name = data['name'];
    messageText = data['messageText'];
    msgindex = data['msgindex'];
    time = data['time'];
    actionBy = data['actionBy'];
    chatId = data['chatId'];
    eId = data['eId'];
    actionBy = data["actionBy"];
    messages = <ChatMessage>[];
    var temp = data["messages"];
    if (temp != null)
      temp.forEach((v) {
        print(v.toString());
        messages!.add(ChatMessage.fromLocaltoJson(v));
      });
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageURL;
    data['name'] = this.name;
    data['messageText'] = this.messageText;
    data['msgindex'] = this.msgindex;
    data['time'] = this.time;
    data["messages"] = this.messages;
    data['actionBy'] = this.actionBy;
    data['actionBy'] = this.actionBy;
    data['chatId'] = this.chatId;
    data['eId'] = this.eId as String;
    return data;
  }
}
