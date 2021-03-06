import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:twixor_demo/chatDetailPage.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'conversationList.dart';
import 'helper_files/Websocket.dart';
import 'models/Attachmentmodel.dart';
import 'models/chatUsersModel.dart';
import 'API/apidata-service.dart';
import 'package:connectivity/connectivity.dart';

//var connectivityResult = (Connectivity().checkConnectivity());
List<ChatUsers> chatUsers = [];

class profilePage extends StatefulWidget {
  //File fileImg;
  //ChatDetailPage(this.imageUrl, this.name,this.msgindex);
  //fetchPost()

  //ChatDetailPage(TextInputType text);

  //ChatDetailPageState(imageUrl);

  @override
  _profilePage createState() => _profilePage();
}

class _profilePage extends State<profilePage>
    with SingleTickerProviderStateMixin {
  // late ConnectivityResult _previousResult;
  // late ConnectivityResult connectivityResult;

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Attachments',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      home: TabsScreen(),
    );
  }

  @override
  initState() {
    super.initState();
    // UsersList();
    // connectivityResult =        Connectivity().checkConnectivity() as ConnectivityResult;
    // print(connectivityResult.toString());
    _tabController = TabController(vsync: this, length: 2);
    super.setState(() {});
  }

  // static List<ChatUsers> chatUsers = [
  //   ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "asset/images/pp.png", time: "Now",msgindex:0),
  //   ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "asset/images/pp.png", time: "Yesterday",msgindex:1),
  //   ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "asset/images/pp.png", time: "31 Mar",msgindex:2),
  //   ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "asset/images/pp.png", time: "28 Mar",msgindex:3),
  //   ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "asset/images/pp.png", time: "23 Mar",msgindex:4),
  //   ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "asset/images/pp.png", time: "17 Mar",msgindex:5),
  //   ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "asset/images/online.png", time: "24 Feb",msgindex:6),
  //   ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "asset/images/pp.png", time: "18 Feb",msgindex:7),
  // ];

  @override
  Widget TabsScreen() {
    // channelconnect();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 1.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          flexibleSpace: MyCustomeHeader(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: TabBar(
              indicatorColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: [
                Container(
                  height: 40.0,
                  //alignment: Tex,
                  child: Tab(text: 'Active Chats'),
                ),
                new Container(
                  height: 40.0,
                  child: Tab(text: 'Closed Chats'),
                ),
                //   Tab( text: 'Active Chats'),
                //   Tab( text: 'Closed Chats')
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          elevation: 20.0,
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              ListTile(
                title: new Text("Agent"),
              ),
              ListTile(
                title: new Text("Chat"),
                leading: new Icon(Icons.mail),
              ),
              Divider(
                height: 0.1,
              ),
              ListTile(
                title: new Text("Logout"),
                leading: new Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder(
                builder: (context, snapshot) {
                  print("snapChat data -> ${snapshot.data.toString()}");
                  if (snapshot.hasData) {
                    chatUsers = snapshot.data as List<ChatUsers>;
                    print('receiver data -> $chatUsers');
                    return ListView.builder(
                      itemCount: chatUsers.length,
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 10),
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        String? time = chatUsers[index].time;
                        String? name = chatUsers[index].name;
                        String? messageText = chatUsers[index].messageText;
                        String? imageURL = chatUsers[index].imageURL;
                        List<ChatMessage>? messages = chatUsers[index].messages;
                        String? actionBy = chatUsers[index].actionBy;
                        String? chatId = chatUsers[index].chatId;
                        String? eId = chatUsers[index].eId;

                        var a = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(time!),
                                isUtc: true)
                            .toString();
                        ////////////////////////////////
                        return GestureDetector(
                          onTap: () {
                            //print();

                            var imageUrl = imageURL;
                            print("conversationPage");

                            ChatUsers? userData;
                            String userDetails = jsonEncode(chatUsers[index]);

                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatDetailPage(userDetails, "")))
                                .then((value) {
                              // chatUsers.forEach((v) {
                              //   print("ValueChat Id ${value.runtimeType}");
                              //   if (v.chatId == value.chatId) {
                              //     v = value;
                              //     print("Updated");
                              //   }
                              // })

                              chatUsers[chatUsers.indexWhere((element) =>
                                      element.chatId == value.chatId)]
                                  .messages = value.messages;
                              setState(() {});
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage(imageURL.toString()),
                                        maxRadius: 30,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                name.toString(),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                messages![messages.length - 1]
                                                    .messageContent
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                    fontWeight: time != null
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
                                  time.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: time != null
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        );
                        ///////////////////////////////
                      },
                    );
                  } else
                    return Center(child: CircularProgressIndicator());
                },
                future: getChatUserLists()),

            ListView.builder(
              itemCount: chatUsers.length,

              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 16),
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                String? time = chatUsers[index].time;
                String? name = chatUsers[index].name;
                String? messageText = chatUsers[index].messageText;
                String? imageURL = chatUsers[index].imageURL;
                List<ChatMessage>? messages = chatUsers[index].messages;
                String? actionBy = chatUsers[index].actionBy;
                String? chatId = chatUsers[index].chatId;
                String? eId = chatUsers[index].eId;
                if (chatUsers.length > 0) {
                  var a = DateTime.fromMillisecondsSinceEpoch(int.parse(time!),
                          isUtc: true)
                      .toString();
                  return ConversationList(context, chatUsers[index]);
                }
                return CircularProgressIndicator();
              },
            ) //ListViewHome()
            //  ScreenA(), ScreenB()
          ],
        ),
      ),
    );
  }

  getBack(dynamic value) {
    print("Getback");
    var temp = value as ChatUsers;
    //jsonData = temp;
    print(chatUsers.length);
    chatUsers.asMap().forEach((key, value) {
      print(value.chatId);
    });
    chatUsers.forEach((v) {
      if (v.chatId == temp.chatId) {
        v = temp;
        print("Updated");
      }
    });

    print(temp.chatId);
    // return value;

//    ChatMessage.fromLocaltoJson(value);
  }
}

Widget ConversationList(BuildContext context, ChatUsers chatUser) {
  return Container();
}

// getBack(dynamic value) {
//   print("Getback");
//   var temp = value as ChatUsers;
//   //jsonData = temp;
//   print(chatUsers.length);
//   chatUsers.asMap().forEach((key, value) {
//     print(value.chatId);
//   });
//   chatUsers.forEach((v) {
//     if (v.chatId == temp.chatId) {
//       v = temp;
//       print("Updated");
//     }
//   });

//   print(temp.chatId);
//   // return value;

// //    ChatMessage.fromLocaltoJson(value);
// }

Widget MyCustomeHeader() {
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: AppBar(
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
          child: Container(), preferredSize: Size.fromHeight(10.0)),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('asset/images/chatlogo.png'),
                  Text('Chats',
                      style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0),
                      textAlign: TextAlign.center),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'asset/images/online.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  Text(
                    "Online",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ]),
            SizedBox(
              width: 80,
            ),
          ],
        ),
        NamedIcon(
          text: '',
          iconData: Icons.notifications,
          notificationCount: 11,
          onTap: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

class MyCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, NamedIcon {
  const MyCustomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          width: 400,
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: AppBar(
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                    child: Container(
                        // color: Colors.grey,
                        // height: 0.0,
                        ),
                    preferredSize: Size.fromHeight(1.0)),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: Image.asset('asset/images/chatlogo.png'),
                title: Text('Chats',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.center),
                actions: [
                  SizedBox(
                    width: 10,
                  ),
                  Positioned(
                    top: 85,
                    left: 20,
                    child: Image.asset(
                      'asset/images/online.png',
                      width: 10.0,
                      height: 10.0,
                    ),
                  ),
                  Positioned(
                    top: 35,
                    left: 3,
                    child: Text(
                      "Online",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  NamedIcon(
                    text: '',
                    iconData: Icons.notifications,
                    notificationCount: 11,
                    onTap: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(200);

  @override
  // TODO: implement iconData
  IconData get iconData => throw UnimplementedError();

  // @override
  // // TODO: implement notificationCount
  // int get notificationCount => throw UnimplementedError();

  @override
  // TODO: implement onTap
  VoidCallback get onTap => throw UnimplementedError();

  @override
  // TODO: implement text
  String get text => throw UnimplementedError();

  @override
  // TODO: implement notificationCount
  int get notificationCount => 6;
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final int notificationCount;
  const NamedIcon({
    Key? key,
    required this.onTap,
    required this.text,
    required this.iconData,
    required this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  size: 30,
                  color: Colors.grey,
                ),
              ],
            ),
            Positioned(
              top: 25,
              left: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text('$notificationCount'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
