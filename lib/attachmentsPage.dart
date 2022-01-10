// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twixor_demo/API/apidata-service.dart';
import 'package:twixor_demo/chatDetailPage.dart';
import 'package:twixor_demo/helper_files/Websocket.dart';

import 'ListView.dart';
import 'models/Attachmentmodel.dart';

void main() {
  String? jsonData;
  int? mediaType;
  // int? msgindex;
  // AttachmentData? attachments;

  //print(msgindex);
  runApp(AttachmentsPage(jsonData!, mediaType!));
}

class AttachmentsPage extends StatelessWidget {
  int? msgindex;
  int mediaType;
  List<Attachment> attachmentList = [];

  Attachment? attachments;

  String jsonData;

  AttachmentsPage(this.jsonData, this.mediaType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new MaterialApp(
        // Hide the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Attachments',
        theme: ThemeData.light(),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Attachments'),
              leading: new IconButton(
                icon: Icon(const IconData(0xe092,
                    fontFamily: 'MaterialIcons', matchTextDirection: true)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              bottom: TabBar(
                tabs: [Tab(text: 'Public'), Tab(text: 'Private')],
              ),
            ),
            body: TabBarView(
              children: [
                FutureBuilder(
                    builder: (context, snapshot) {
                      // print("Attachment data -> ${snapshot.data.toString()}");
                      if (snapshot.hasData) {
                        attachmentList = snapshot.data as List<Attachment>;
                        // print('receiver data -> ${messageList.length}');
                        return ListView.builder(
                          itemCount: attachmentList.length,
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 10),
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                                trailing: Text(
                                  attachmentList[index].desc.toString(),
                                ),
                                title: Text("${attachmentList[index].name}"),
                                onTap: () {
                                  jsonData;
                                  //  Navigator.of(context).pop(jsonData);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatDetailPage(
                                              jsonData,
                                              jsonEncode(
                                                  attachmentList[index]))));
                                });
                          },
                        );
                      } else
                        return Center(child: CircularProgressIndicator());
                    },
                    future: getAttachments(mediaType)),
                FutureBuilder(
                  builder: (context, snapshot) {
                    // print("Attachment data -> ${snapshot.data.toString()}");
                    if (snapshot.hasData) {
                      var messageList = snapshot.data as List<ListTileList>;
                      // print('receiver data -> ${messageList.length}');
                      return ListView.builder(
                        itemCount: messageList.length,
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(top: 10),
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                              trailing: Text(
                                messageList[index].id.toString(),
                              ),
                              title: Text("${messageList[index].text}"));
                        },
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                )
                //  ScreenA(), ScreenB()
              ],
            ),
          ),
        ),
      ),
    );
  }

//////////////////////////////
// Focus this section

  Widget ImageDialog(isFileUrl, content) {
    return AlertDialog(
      //contentPadding:,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      actions: <Widget>[
        Row(children: [
          MaterialButton(
            onPressed: () {},
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              const IconData(0xe16a, fontFamily: 'MaterialIcons'),
              size: 8,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder(),
          ),
          isFileUrl
              ? Container(
                  width: 120,
                  height: 100,
                  child: Image.file(File(content),
                      fit: BoxFit.contain, width: 300, height: 180))
              : Container(
                  width: 120,
                  height: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: content,
                    ),
                  ),
                ),
          MaterialButton(
            onPressed: () {
              //Navigator.of(context).pop();
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Icon(
              const IconData(0xe571,
                  fontFamily: 'MaterialIcons', matchTextDirection: true),
              size: 8,
            ),
            padding: EdgeInsets.all(8),
            shape: CircleBorder(),
          ),
        ]),

        // FlatButton(
        //   child: Text("NO"),
        //   onPressed: () {
        //     //Put your code here which you want to execute on No button click.
        //     Navigator.of(context).pop();
        //   },
        // ),
      ],
    );
    return Dialog(
      child: Container(
          width: 200,
          height: 200,
          child: Image.file(
            File(content),
          )),
    );
  }
}
