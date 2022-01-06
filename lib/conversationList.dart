import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:twixor_demo/models/chatUsersModel.dart';
import 'chatDetailPage.dart';
import 'models/Attachmentmodel.dart';

class ConversationList extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  int msgindex;
  String actionBy;
  String chatId;
  String eId;
  List<ChatMessage> messages;
  Attachment attachments;
  ChatUsers jsonData;

  ConversationList(
      {required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.msgindex,
      required this.messages,
      required this.actionBy,
      required this.chatId,
      required this.eId,
      required this.attachments,
      required this.jsonData});

  setState() {}
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print();

        var imageUrl = widget.imageUrl;
        print("conversationPage");
        print(widget.msgindex);
        ChatUsers? userData;
        String userDetails = jsonEncode(widget.jsonData);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailPage(
                    userDetails, Attachment(isAttachment: false))));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
