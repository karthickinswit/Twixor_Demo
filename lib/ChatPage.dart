//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/widgets.dart';
import 'HomePage.dart';
import 'package:connectivity/connectivity.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar:
          AppBar(
            centerTitle: true,
            title: MyCustomAppBar(
              height: 100,
              isOnline:"True"
            ),
          ),

          endDrawer: Drawer(
            elevation: 16.0,
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("xyz"),
                  accountEmail: Text("xyz@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("xyz"),
                  ),
                  otherAccountsPictures: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("abc"),
                    )
                  ],
                ),
                ListTile(
                  title: new Text("All Inboxes"),
                  leading: new Icon(Icons.mail),
                ),
                Divider(
                  height: 0.1,
                ),
                ListTile(
                  title: new Text("Primary"),
                  leading: new Icon(Icons.inbox),
                ),
                ListTile(
                  title: new Text("Social"),
                  leading: new Icon(Icons.people),
                ),
                ListTile(
                  title: new Text("Promotions"),
                  leading: new Icon(Icons.local_offer),
                )
              ],
            ),
          ),

    ),
    );
  }
}

class MyCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, NamedIcon {
  final double height;
  final String isOnline;
  Future<String> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return "Online";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "Online";
    }
    return "Offline";
  }

  const MyCustomAppBar({
    Key? key,
    required this.height, required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: 800,
          child: Padding(
            padding: EdgeInsets.all(0),
            child:
            Container(
            child: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: Image.asset('asset/images/chatlogo.png'),
              title: Text('Chats',
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w300,
                      fontSize: 20.0),
                  textAlign: TextAlign.center),
              actions: [

                Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


               Image.asset('asset/images/online.png', width: 20.0, height: 20.0,),
                            Text(
                              //'check().then((intenet) { if (intenet != null && intenet) { return "Online";}return "Offline"});',
                              '${check()}',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

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
                  ),
                  onPressed: () {
                    //endDrawer;
                  },
                ),
                SizedBox(height: 50),
               


              ],
            ),
          ),

          ),

        ),


      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

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

// class CheckConnection extends StatefulWidget{
//   @override
//   State createState() {
//     return _CheckConnection();
//   }
// }
// class _CheckConnection extends State{
//   StreamSubscription? internetconnection;
//   bool isoffline = false;
//   //set variable for Connectivity subscription listiner
//
//   @override
//   void initState() {
//     internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       // whenevery connection status is changed.
//       if(result == ConnectivityResult.none){
//         //there is no any connection
//         setState(() {
//           isoffline = true;
//         });
//       }else if(result == ConnectivityResult.mobile){
//         //connection is mobile data network
//         setState(() {
//           isoffline = false;
//         });
//       }else if(result == ConnectivityResult.wifi){
//         //connection is from wifi
//         setState(() {
//           isoffline = false;
//         });
//       }
//     }); // using this listiner, you can get the medium of connection as well.
//
//     super.initState();
//   }
//
//   @override
//   dispose() {
//     super.dispose();
//     internetconnection!.cancel();
//     //cancel internent connection subscription after you are done
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title:Text("Check Connection")),
//         body:SingleChildScrollView(
//             child: Column(children: [
//
//               Container(
//                 child: errmsg("No Internet Connection Available", isoffline),
//                 //to show internet connection message on isoffline = true.
//               ),
//
//               Container(
//                 //this is your content
//                   margin: EdgeInsets.all(30),
//                   width:double.infinity,
//                   child: Center(
//                       child:Text("Check Connections",
//                           style:TextStyle(fontSize:20)
//                       )
//                   )
//               )
//
//             ],)
//         )
//     );
//   }
//
//   Widget errmsg(String text,bool show){
//     //error message widget.
//     if(show == true){
//       //if error is true then show error message box
//       return Container(
//         padding: EdgeInsets.all(10.00),
//         margin: EdgeInsets.only(bottom: 10.00),
//         color: Colors.red,
//         child: Row(children: [
//
//           Container(
//             margin: EdgeInsets.only(right:6.00),
//             child: Icon(Icons.info, color: Colors.white),
//           ), // icon for error message
//
//           Text(text, style: TextStyle(color: Colors.white)),
//           //show error message text
//         ]),
//       );
//     }else{
//       return Container();
//       //if error is false, return empty container.
//     }
//   }
// }

/*Children widgets with Multi Child's:
// children: <Widget>[
// Expanded(flex: 4, child: Container(color: Colors.brown,),),
// Expanded(flex: 1, child: Container(color: Colors.red,),),
// Expanded(flex: 1, child: Container(color: Colors.green,),),
// Expanded(flex: 4, child: Container(color: Colors.brown,),),
// ],
*/
