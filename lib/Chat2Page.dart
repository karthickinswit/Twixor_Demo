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
  List<ChatUsers> chatUsers = [];
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
    channelconnect();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 130,
          elevation: 16.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          flexibleSpace: MyCustomAppBar(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: TabBar(
              indicatorColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: [
                Container(
                  height: 30.0,
                  //alignment: Tex,
                  child: Tab(text: 'Active Chats'),
                ),
                new Container(
                  height: 30.0,
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
                        return ConversationList(
                          name: name!,
                          messageText: messageText!,
                          imageUrl: imageURL!,
                          time: a.toString(),
                          isMessageRead:
                              (index == 0 || index == 3) ? true : false,
                          msgindex: index,
                          messages: messages!,
                          actionBy: actionBy!,
                          chatId: chatId!,
                          eId: eId!,
                          attachments: Attachment(isAttachment: false),
                        );
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
                  return ConversationList(
                    name: name!,
                    messageText: messageText!,
                    imageUrl: imageURL!,
                    time: a.toString(),
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                    msgindex: index,
                    messages: messages!,
                    actionBy: actionBy!,
                    chatId: chatId!,
                    eId: eId!,
                    attachments: Attachment(isAttachment: false),
                  );
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class MyCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, NamedIcon {
  // final double height;

  //final bool connected = connectivity != ConnectivityResult.none;

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
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
                Icon(iconData),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
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
