

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chatDetailPage.dart';
import 'models/chatUsersModel.dart';

class ListViewHome extends StatelessWidget {
    int msgindex;
  ListViewHome(this.msgindex);
  @override
  Widget build(BuildContext context) {
     List<ChatUsers> chatUsers = [
      ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "asset/images/pp.png", time: "Now",msgindex:0),
      ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "asset/images/pp.png", time: "Yesterday",msgindex:1),
      ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "asset/images/pp.png", time: "31 Mar",msgindex:2),
      ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "asset/images/pp.png", time: "28 Mar",msgindex:3),
      ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "asset/images/pp.png", time: "23 Mar",msgindex:4),
      ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "asset/images/pp.png", time: "17 Mar",msgindex:5),
      ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "asset/images/online.png", time: "24 Feb",msgindex:6),
      ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "asset/images/pp.png", time: "18 Feb",msgindex:7),
    ];
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile( title: Text("Battery Full"), onTap: () => {print("ListViewPage"),print(msgindex),Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailPage(chatUsers[msgindex].imageURL,chatUsers[msgindex].name,this.msgindex)))}),
        ListTile( title: Text("Anchor"),),
        ListTile( title: Text("Alarm"), ),
        ListTile( title: Text("Ballot"), )
      ],
    );
  }

  void gotoPrevious(String m)
  {

  }

}
