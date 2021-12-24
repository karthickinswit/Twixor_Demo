import 'package:flutter/material.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'chatDetailPage.dart';

class ConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  int msgindex;
  List<ChatMessage> messages;

  ConversationList({required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead,required this.msgindex,required this.messages});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //print();

          var imageUrl=widget.imageUrl;
  print("conversationPage");
  print(widget.msgindex);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailPage(imageUrl,widget.name,widget.msgindex,widget.messages)));

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}