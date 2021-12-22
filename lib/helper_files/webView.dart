import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';

class WebViewEx extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewEx> {
  static var httpClient = new HttpClient();
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Media'),
        toolbarOpacity: 1.0,
        leading: Icon(const IconData(0xe094, fontFamily: 'MaterialIcons')),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor:Colors.blue ,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) =>
            [
              PopupMenuItem(child: ListTile(
                title: Text('Media', textAlign: TextAlign.left,),
                enabled: true,)),
              PopupMenuItem(child: ListTile(leading: Icon(const IconData(0xe26a, fontFamily: 'MaterialIcons')),
                title: Text('Download'),
                enabled: true,), value: "/chat"),


            ],

            onSelected: (route) {
              print(route);
              _downloadFile('https://aim.twixor.com/drive/docs/61c2d1345d9c40085df9a86c',"Rajini.mp4");
              // Note You must create respective pages for navigation
              // Navigator.pushNamed(context, route);
            },
          ),
        ],

      ),
      body: webviewwidget(),
    );
  }
  Widget webviewwidget()
  {
    return WebView(
      initialUrl: 'https://aim.twixor.com/drive/docs/61c2d1345d9c40085df9a86c',//https://aim.twixor.com/drive/docs/61c2d1345d9c40085df9a86c
    );
  }



    Future<File> _downloadFile(String url, String filename) async {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      print(dir);
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
    }



}