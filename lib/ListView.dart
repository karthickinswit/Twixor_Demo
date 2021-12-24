

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chatDetailPage.dart';
import 'models/chatUsersModel.dart';
import 'package:image_picker/image_picker.dart';
enum ImageSourceType { gallery, camera }
class ListViewHome extends StatelessWidget  {
    int msgindex;
  ListViewHome(this.msgindex);
    // File _image;
    // List<ChatUsers> chatUsers = [
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
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile( title: Text("Battery Full"), onTap: () => gotoPage(context,msgindex)),
        ListTile( title: Text("Anchor"),),
        ListTile( title: Text("Alarm"), ),
        ListTile( title: Text("Ballot"), ),
        MaterialButton(
          color: Colors.blue,
          child: Text(
            "Pick Image from Gallery",
            style: TextStyle(
                color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            _handleURLButtonPress(context, ImageSourceType.gallery);
          },
        ),
        MaterialButton(
          color: Colors.blue,
          child: Text(
            "Pick Image from Camera",
            style: TextStyle(
                color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            _handleURLButtonPress(context, ImageSourceType.camera);
          },
        ),
      ],
    );
  }
    void _handleURLButtonPress(BuildContext context, var type) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
    }
  void gotoPrevious(String m)
  {

  }
  void gotoPage(context,msgindex)
  {
    print("ListViewPage");
    print(msgindex);
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatDetailPage(chatUsers[msgindex].imageURL,chatUsers[msgindex].name,this.msgindex)));
  }



}


class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                  _image,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.red[200]),
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}