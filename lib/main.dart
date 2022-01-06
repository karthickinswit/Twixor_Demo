import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twixor_demo/removedItems/Chatmain.dart';
import 'API/apidata-service.dart';
import 'helper_files/Websocket.dart';
import 'package:permission_handler/permission_handler.dart';

import 'removedItems/ChatPage.dart';
import 'Chat2Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  initState() {}

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }

  void checkServiceStatus(
      BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }
}

class LoginDemo extends StatefulWidget {
  late bool isLoading;
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 210,
                    height: 180,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/logo.png')),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User ID',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  //LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                  // sleep(const Duration(seconds: 5));

                  //Navigator.of(_LoaderDialog.currentContext,rootNavigator: true).pop();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => profilePage()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  //LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                  // sleep(const Duration(seconds: 5));

                  //Navigator.of(_LoaderDialog.currentContext,rootNavigator: true).pop();

                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => ChatUI()));
                },
                child: Text(
                  'Test Page',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
