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

Future<List<Attachment>> getAttachments(int mediaType) async {
  List<Attachment>? attachments = [];
  final response = await http.get(
      Uri.parse(url +
          "artifacts?type=${mediaType.toString()}&from=0&perPage=10&desc=&visibility=public"),
      headers: mainheader);
  print(response.body.toString());

  if (response.statusCode == 200) {
    //print(response.body.toString());
    //print(response.body.toString());
    var obj = json.decode(response.body); //.replaceAll("\$", ""));
    var obj1 = obj["response"]["artifacts"];
    for (var i = 0; i < obj1.length; i++) {
      attachments.add(Attachment.fromAPItoJson(obj1[i]["data"]));
    }
    print(obj1.runtimeType);

    return attachments;
  }
  return attachments;
}

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

uploadmage(
  Attachment attachment,
  objFile,
) async {
  var headers = {
    'authentication-token':
        'D+hsmfpocX0zksWgM8BC+5JI8xHugmxj/+LYQc521vwfXZJCEMLuKFgxM9RtZPcl'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://aim.twixor.com/e/drive/upload'));
  request.fields.addAll({'message': 'Cat03.jpg', 'multipart': 'image/jpeg'});
  request.files
      .add(await http.MultipartFile.fromPath('file', objFile.path.toString()));
  request.headers.addAll(headers);

  var response = await request.send();

  if (response.statusCode == 200) {
    var temp = await response.stream.asBroadcastStream();
    print(temp.toString());
  } else {
    print(response.reasonPhrase);
  }
}
