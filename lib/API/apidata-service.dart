import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:twixor_demo/helper_files/Websocket.dart';
import 'package:twixor_demo/models/Attachmentmodel.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:twixor_demo/models/chatUsersModel.dart';

import '../ListView.dart';

String url = 'https://aim.twixor.com/e/enterprise/';
String authToken =
    "D+hsmfpocX0zksWgM8BC+5JI8xHugmxj/+LYQc521vwfXZJCEMLuKFgxM9RtZPcl";
Map<String, String> mainheader = {
  "Content-type": "application/json",
  "authentication-token": authToken
};

getChats() async {
  final response =
      await http.get(Uri.parse(url + "chat/summary"), headers: mainheader);
  List<ChatMessage> messages = [];
  if (response.statusCode == 200) {
    //print(response.body.toString());
    var obj = json.decode(response.body);
    var chatmessages = obj["response"]["chats"][0]["messages"];

    for (var obj1 in chatmessages) {
      // print(obj1.toString());
      if (obj1.containsKey('message')) {
        // print()
        messages.add(ChatMessage(
            messageContent: obj1["message"],
            messageType: obj1["status"] == 0 ? "sender" : "receiver",
            isUrl: false,
            contentType: "text",
            url: '',
            actionBy: obj1["handlingAgent"],
            chatId: obj1["chatId"],
            eId: obj1["eId"]));
      }
    }
    return messages;
  }
  return messages;
}

Future<List<Attachment>> getAttachments(int mediaType) async {
  List<Attachment>? attachment = [];
  final response = await http.get(
      Uri.parse(url +
          "artifacts?type=${mediaType.toString()}&from=0&perPage=10&desc=&visibility=public"),
      headers: mainheader);
  print(response.body.toString());

  if (response.statusCode == 200) {
    //print(response.body.toString());
    //print(response.body.toString());
    var obj = json.decode(response.body); //.replaceAll("\$", ""));
    var messages = obj["response"]["artifacts"];
    print(obj["response"]["artifacts"].length);
    for (var obj1 = 0; obj1 < messages.length; obj1++) {
      var obj2 = messages[obj1]["data"];
      print(obj2.runtimeType);
      attachment.add(Attachment.fromJson(obj2));

      print(attachment.toString());
    }
    return attachment;
  }
  return attachment;
}

Future<List<ChatUsers>> getChatUserLists() async {
  final response =
      await http.get(Uri.parse(url + 'chat/summary'), headers: mainheader);
  List<ChatUsers> chatUsersData = [];

  if (response.statusCode == 200) {
    //print(response.body.toString());
    var obj = json.decode(response.body.replaceAll("\$", ""));
    var chatUsers = obj["response"]["chats"];
//print("chatUser data -> $chatUsers");
    for (var i = 0; i < chatUsers.length; i++) {
      var obj1 = chatUsers[i];
      List<ChatMessage> messages = [];

      if (obj1['chatId'] != null && obj1['chatId'] != "") {
        print("data inside for with if -> ${obj1.toString().substring(0, 50)}");
        var chatmessages = obj1["messages"];
        for (var chatObj in chatmessages) {
          //print(chatObj.toString());
          if (chatObj.containsKey('message')) {
            // print()
            if (chatObj["contentType"] == "TEXT") {
              if (chatObj["message"] != "" || chatObj["message"] != null) {
                messages.add(ChatMessage(
                    messageContent: chatObj["message"],
                    messageType: chatObj["status"] == 0 ? "sender" : "receiver",
                    isUrl: false,
                    contentType: "text",
                    url: '',
                    actionBy: obj1["handlingAgent"].toString(),
                    chatId: obj1["chatId"],
                    eId: obj1["eId"].toString()));
              }
            } else if (chatObj["contentType"] == "IMAGE") {
              var obj3 = chatObj["attachment"];
              //  print(obj3.toString());
              //var obj3=chatObj["attachment"];
              // print("/////////////${obj3.toString()}");
              messages.add(ChatMessage(
                  messageContent: obj3["name"],
                  messageType: chatObj["status"] == 0 ? "sender" : "receiver",
                  isUrl: false,
                  contentType: "img",
                  url: obj3["url"],
                  actionBy: obj1["handlingAgent"].toString(),
                  chatId: obj1["chatId"],
                  eId: obj1["eId"].toString()));
            } else if (chatObj["contentType"] == "DOC") {
              var obj3 = chatObj["attachment"];
              //print(obj3.toString());
              //var obj3=chatObj["attachment"];
              //print("/////////////${obj3.toString()}");
              messages.add(ChatMessage(
                  messageContent: obj3["name"],
                  messageType: chatObj["status"] == 0 ? "sender" : "receiver",
                  isUrl: false,
                  contentType: "doc",
                  url: obj3["url"],
                  actionBy: obj1["handlingAgent"].toString(),
                  chatId: obj1["chatId"],
                  eId: obj1["eId"].toString()));
            }
          }
        }

        // print()ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "asset/images/pp.png", time: "Now",msgindex:0)
        var lastKnownTime = obj1["lastModifiedOn"];
        // var lastKnownTime2 = lastKnownTime.replaceAll("\$", "");
        // var lastKnownTime3 = ""; //jsonDecode(lastKnownTime2);

        // print(lastKnownTime2);
        chatUsersData.add(
          ChatUsers(
              name: obj1["customerName"],
              messageText: obj1["lastMessage"],
              imageURL: obj1["customerIconUrl"] == null ||
                      obj1["customerIconUrl"] == ""
                  ? 'asset/images/pp.png'
                  : obj1["customerIconUrl"],
              time: lastKnownTime["date"].toString(),
              msgindex: i,
              messages: messages,
              actionBy: obj1["handlingAgent"].toString(),
              chatId: obj1["chatId"],
              eId: obj1["eId"].toString()),
        );
      }
    }
    print('return data $chatUsersData');
    return chatUsersData;
  }
  print('return data $chatUsersData');
  return chatUsersData;
}

class ChatData {
  late String message;
  late String contentType;
  late String imageUrl;

  late String actionType;
  late String actionBy;
  late String status;
  late String actionId;
  late String actedOn;
  //ChatData()
  getChatData(obj) {
    this.message = obj["message"];

    this.contentType = obj["contentType"];
    this.imageUrl = obj["contentType"];

    this.actionType = obj["actionType"];
    this.actionBy = obj["actionBy"];
    this.status = obj["status"];
    this.actionId = obj["actionId"];
    this.actedOn = obj["actedOn"];
  }
}
