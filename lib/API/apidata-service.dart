import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:twixor_demo/helper_files/Websocket.dart';
import 'package:twixor_demo/models/Attachmentmodel.dart';
import 'package:twixor_demo/models/ChatSummaryModel.dart';
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

// Future<List<Attachment>> getAttachments(int mediaType) async {
//   List<Attachment>? attachment = [];
//   final response = await http.get(
//       Uri.parse(url +
//           "artifacts?type=${mediaType.toString()}&from=0&perPage=10&desc=&visibility=public"),
//       headers: mainheader);
//   print(response.body.toString());

//   if (response.statusCode == 200) {
//     //print(response.body.toString());
//     //print(response.body.toString());
//     var obj = json.decode(response.body); //.replaceAll("\$", ""));
//     var messages = obj["response"]["artifacts"];
//     print(obj["response"]["artifacts"].length);
//     for (var obj1 = 0; obj1 < messages.length; obj1++) {
//       var obj2 = messages[obj1]["data"];
//       print(obj2.runtimeType);
//       attachment.add(Attachment.fromJson(obj2));

//       print(attachment.toString());
//     }
//     return attachment;
//   }
//   return attachment;
// }

Future<List<ChatUsers>> getChatUserLists() async {
  final response =
      await http.get(Uri.parse(url + 'chat/summary'), headers: mainheader);
  List<ChatUsers> chatUsersData = [];

  if (response.statusCode == 200) {
    //print(response.body.toString());
    var obj = json.decode(response.body.replaceAll("\$", ""));
    var chatUsers = obj["response"]["chats"];
    var oh = obj["response"];
    print(obj["response"]["chats"].runtimeType);

    for (var i = 0; i < chatUsers.length; i++) {
      var obj1 = chatUsers[i];
      List<ChatMessage> messages = [];

      if (obj1['chatId'] != null && obj1['chatId'] != "") {
        print("data inside for with if -> ${obj1.toString().substring(0, 50)}");
        var chatmessages = obj1["messages"];

        // for (var chatObj in chatmessages) {
        //   if (chatObj.containsKey('message')) {
        //     messages.add(ChatMessage.fromAPItoJson(chatObj));
        //   }
        // }
        var lastKnownTime = obj1["lastModifiedOn"];

        //print('return data $chatUsersData');
        chatUsersData.add(
          ChatUsers.fromJson(obj1),
        );
      }
    }

    // print('return data $chatUsersData');
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
