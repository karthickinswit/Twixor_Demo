import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';

class WebViewEx extends StatefulWidget {
  String url;

  WebViewEx(this.url);
  @override

  WebViewExampleState createState() => WebViewExampleState(this.url);
}

class WebViewExampleState extends State<WebViewEx> {
  static var httpClient = new HttpClient();
   late String url;
  late String name;
   WebViewExampleState(this.url);
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
        leading: IconButton(
              icon: Icon(const IconData(0xe094, fontFamily: 'MaterialIcons'),), 
          onPressed: () { Navigator.pop(context); },
          
        ),

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
              _downloadFile('https://aim.twixor.com/drive/docs/61c304f45d9c40085df9be74',"Rajini.pdf");
              // Note You must create respective pages for navigation
              // Navigator.pushNamed(context, route);
            },
          ),
        ],

      ),
      body: webviewwidget(url),
    );
  }
  Widget webviewwidget(url)
  {
    return WebView(
      initialUrl: url,//'https://aim.twixor.com/drive/docs/61c2d1345d9c40085df9a86c',//https://aim.twixor.com/drive/docs/61c2d1345d9c40085df9a86c
    );
  }



    void _downloadFile(String url, String filename) async {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      final folderName="twixor_demo";
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      final path= Directory("storage/emulated/0/$folderName");
     // File file = new File('$path/$filename');
      //print(file);
      //await file.writeAsBytes(bytes);
      if ((await path.exists())){
        // TODO:
        print("exist");
        File file = new File('$path/$filename');
        print(file);
        await file.writeAsBytes(bytes);
      }else{
        // TODO:
        print("not exist");
        path.create();

      }
      // print(dir);
      // File file = new File('$dir/$filename');
      // print(file);
      // await file.writeAsBytes(bytes);
      // return file;
    }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

}