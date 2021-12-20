import 'package:flutter/material.dart';

import 'ListView.dart';


void main(msgindex) {
  int? msgindex;
  print("Attachments");
  print(msgindex);
  runApp(AttachmentsPage(msgindex));
}

class AttachmentsPage extends StatelessWidget {
  int? msgindex;
  AttachmentsPage(this.msgindex);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Attachments',
      theme: ThemeData.light(),
      home: TabsScreen((this.msgindex)),
    );
  }
}

//////////////////////////////
// Focus this section
class TabsScreen extends StatelessWidget {
  int? msgindex;
  TabsScreen(this.msgindex);
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attachments'),
          bottom: TabBar(
            tabs: [
              Tab( text: 'Private'),
              Tab( text: 'Public')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListViewHome(msgindex!),ListViewHome(msgindex!)
          //  ScreenA(), ScreenB()
          ],
        ),
      ),
    );
  }
}