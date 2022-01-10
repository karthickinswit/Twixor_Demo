import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:twixor_demo/API/apidata-service.dart';
import 'package:twixor_demo/models/Attachmentmodel.dart';
import 'package:twixor_demo/models/SendMessageModel.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:web_socket_channel/io.dart';

import '../chatDetailPage.dart';

class SocketDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<SocketDemo> {
  IOWebSocketChannel? channel; //channel varaible for websocket
  bool? connected; // boolean value to track connection status

  String myid = "222"; //my id
  String recieverid = "111"; //reciever id
  // swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];
  List<ChatMessage> messages = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    // channelconnect();
    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      Map<String, String> mainheader = {
        "Content-type": "application/json",
        "authentication-token": authToken
      };
      channel = IOWebSocketChannel.connect("wss://aim.twixor.com/actions",
          headers:
              mainheader); //channel IP : Port\\"ws://192.168.0.109:6060/$myid"
      channel?.stream.listen(
        (message) {
          print((message));
          setState(() {
            var message1 = json.decode(message);
            if (message1["action"] == "onOpen") {
              connected = true;

              setState(() {});
              print("Connection establised.");
            } else if (message1["action"] == "agentReplyChat") {
              print("Message send success");

              setState(() {
                msgtext.text = "";
              });
            } else if (message == "send:error") {
              print("Message send error");
            } else if (message.substring(0, 6) == "{'cmd'") {
              print("Message data");
              message = message.replaceAll(RegExp("'"), '"');
              var jsondata = json.decode(message);

              msglist.add(MessageData(
                //on message recieve, add data to model
                msgtext: jsondata["msgtext"],
                userid: jsondata["userid"],
                isme: false,
              ));
              setState(() {
                //update UI after adding data to message model
              });
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            //connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendmessage(String sendmsg, String actionId, String id) async {
    print('connected${connected}');
    if (connected == true) {
      String msg =
          "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
      });
      var data = {};
      data["action"] = "agentReplyChat";
      data["actionBy"] = 269;
      data["actionType"] = 3;
      data["attachment"] = {};
      data["chatId"] = "86a0e2402a9811eca98f9a4bbcc22257";
      data["contentType"] = "'TEXT'";
      data["eId"] = 103;
      data["message"] = sendmsg.toString();
      print(json.encode(data).toString());
      channel?.sink.add(json.encode(data)); //send message to reciever channel
    } else {
      // channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My ID: $myid - Chat App Example"),
          leading: Icon(Icons.circle,
              color: connected! ? Colors.greenAccent : Colors.redAccent),
          //if app is connected to node.js then it will be gree, else red.
          titleSpacing: 0,
        ),
        body: Container(
            child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 70,
                left: 0,
                right: 0,
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Container(
                          child: Text("Your Messages",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(
                            child: Column(
                          children: msglist.map((onemsg) {
                            return Container(
                                margin: EdgeInsets.only(
                                  //if is my message, then it has margin 40 at left
                                  left: onemsg.isme ? 40 : 0,
                                  right: onemsg.isme
                                      ? 0
                                      : 40, //else margin at right
                                ),
                                child: Card(
                                    color: onemsg.isme
                                        ? Colors.blue[100]
                                        : Colors.red[100],
                                    //if its my message then, blue background else red background
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(onemsg.isme
                                                  ? "ID: ME"
                                                  : "ID: " + onemsg.userid)),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Text(
                                                "Message: " + onemsg.msgtext,
                                                style: TextStyle(fontSize: 17)),
                                          ),
                                        ],
                                      ),
                                    )));
                          }).toList(),
                        ))
                      ],
                    )))),
            Positioned(
              //position text field at bottom of screen

              bottom: 0, left: 0, right: 0,
              child: Container(
                  color: Colors.black12,
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          controller: msgtext,
                          decoration:
                              InputDecoration(hintText: "Enter your Message"),
                        ),
                      )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: Icon(Icons.send),
                            onPressed: () {
                              if (msgtext.text != "") {
                                //send message with webspcket
                              } else {
                                print("Enter message");
                              }
                            },
                          ))
                    ],
                  )),
            )
          ],
        )));
  }
}

class Attachement {
  String? id;
  String? docType;
  String? docFileUrl;

  Attachement(this.id, this.docType, this.docFileUrl);
}

class MessageData {
  //message data model
  String msgtext, userid;
  bool isme;
  MessageData(
      {required this.msgtext, required this.userid, required this.isme});
}

channelconnect() {
  //function to connect
  IOWebSocketChannel? channel;
  bool connected = false;
  try {
    Map<String, String> mainheader = {
      "Content-type": "application/json",
      "authentication-token": authToken
    };

    channel = IOWebSocketChannel.connect("wss://aim.twixor.com/actions",
        headers: mainheader);

    //channel IP : Port\\"ws://192.168.0.109:6060/$myid"
    // channel.stream.listen(
    // (message) {
    //   print((message.toString()));
    //   var message1 = json.decode(message);
    //   if (message1["action"] == "onOpen") {
    //     connected = true;

    //     print("Connection establised.");
    //   } else if (message1["action"] == "agentReplyChat") {
    //     print("Message sent");
    //   } else if (message1 == "customerStartChat") {
    //     print("Customer Start Chat");
    //   } else if (message1 == "waitingInviteAccept") {
    //     print("waitingInviteAccept");
    //   } else if (message1 == "waitingTransferAccept") {
    //     print("waitingTransferAccept");
    //   }
    // },
    // onDone: () {
    //if WebSocket is disconnected
    // print("Web socket is closed");

  } catch (_) {
    print("error on connecting to websocket.");
  }
  // return connected;
}

getSocketResponse(String msgAction) async {
  IOWebSocketChannel? channel;
  try {
    Map<String, String> mainheader = {
      "Content-type": "application/json",
      "authentication-token": authToken
    };

    channel = IOWebSocketChannel.connect("wss://aim.twixor.com/actions",
        headers: mainheader);
    channel.stream.listen(
      (message) {
        var message1 = json.decode(message);
        if (message1["action"] == "onOpen") {
          // connected = true;

          print("Connection establised.");
        } else if (message1["action"] == "agentReplyChat") {
          print("Message sent");
        } else if (message1 == "customerStartChat") {
          print("Customer Start Chat");
          return message;
        } else if (message1 == "waitingInviteAccept") {
          print("waitingInviteAccept");
        } else if (message1 == "waitingTransferAccept") {
          print("waitingTransferAccept");
        }
      },
      onDone: () {
        //if WebSocket is disconnected
        print("Web socket is closed");
        // setState(() {
        //   //connected = false;
        // });
      },
      onError: (error) {
        print(error.toString());
      },
    );
  } catch (_) {
    print("SocketIO Error");
  }
}

Future<void> sendmessage(SendMessage sendMessage) async {
  IOWebSocketChannel? channel;
  bool connected = false;

  Map<String, String> mainheader = {
    "Content-type": "application/json",
    "authentication-token": authToken
  };
  channel = IOWebSocketChannel.connect("wss://aim.twixor.com/actions",
      headers: mainheader); //channel IP : Port\\"ws://192.168.0.109:6060/$myid"

  var data = {};
  data["action"] = "agentReplyChat";
  data["actionBy"] = sendMessage.actionBy;
  data["actionType"] = sendMessage.actionType;
  data["attachment"] =
      sendMessage.attachment!.url != null ? sendMessage.attachment : {};
  data["chatId"] = sendMessage.chatId;
  data["contentType"] = sendMessage.contentType;
  data["eId"] = sendMessage.eId;
  data["message"] = sendMessage.message;
  var temp = print(json.encode(data).toString());
  channel.sink.add(json.encode(data)); //send message to reciever channel
}
