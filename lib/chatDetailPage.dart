import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twixor_demo/API/apidata-service.dart';
import 'package:twixor_demo/helper_files/FileUploadWithHttp.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:twixor_demo/models/chatUsersModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ListView.dart';
import 'attachmentsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'Chat2Page.dart';
import 'helper_files/Websocket.dart';
import 'helper_files/webView.dart';
import 'API/apidata-service.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'models/Attachmentmodel.dart';

enum ImageSourceType { gallery, camera }

class ChatDetailPage extends StatefulWidget {
  String? jsonData;
  List<ChatMessage> messages = [];

  Attachment? attachments;

  ChatDetailPage(this.jsonData, this.attachments);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState(
        jsonData!,
        attachments!,
      );
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with WidgetsBindingObserver {
  String? imageUrl;
  String? name;
  int? msgindex;
  String? actionBy;
  String? chatId;
  String? eId;
  String _url = '';
  String jsonData;
  Attachment attachments;

  var objFile = null;
  String? contents;

  var sendFileType;

  ImagePicker picker = ImagePicker();
  File? imageFile;
  bool _visible = false;
  double _overlap = 0;

  //File fileImg;
  _getFromGallery() async {
    //  picker.pickImage(source: source)
    var pickedFile = (await picker.pickImage(
      source: ImageSource.gallery,
    ));
    if (pickedFile != null) {
      setState(() {
        //fileImg=pickedFile as File;
        imageFile = File(pickedFile.path);
        //print("pickedFile");
        //print(pickedFile);
      });
    }
  }

  String? preview;

  final ScrollController _controller = ScrollController();
  final TextEditingController msgController = TextEditingController();

  _onUrlChanged(String updatedUrl) {
    setState(() {
      _url = updatedUrl;
      //fetchPost();
    });
  }

  _scrollToEnd() async {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
  }

  List<ChatMessage>? messages = [];
  // ScrollController _controller = ScrollController();

  _ChatDetailPageState(this.jsonData, this.attachments);
  @override
  initState() {
    super.initState();
    setState(() {
      var userdata =
          ChatUsers.fromJson(json.decode(jsonData)); //json.decode(jsonData);
      this.imageUrl = userdata.imageURL;
      this.name = userdata.name;
      this.msgindex = userdata.msgindex;
      this.messages = userdata.messages;
      this.actionBy = userdata.actionBy;
      this.chatId = userdata.chatId;
      this.eId = userdata.eId;
    });
    WidgetsBinding.instance?.addObserver(this);
    super.setState(() {});
    if (attachments.isAttachment == true) {
      if (attachments.type == "MSG") msgController.text = attachments.desc!;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("rcvd fdata ${rcvdData['name']}");
    var listView = ListView.builder(
      controller: _controller,
      itemCount: messages!.length,
      reverse: false,
      primary: false,
      addSemanticIndexes: true,
      padding: EdgeInsets.only(bottom: 60),
      itemBuilder: (context, index) {
        print(messages![0].isUrl);
        return Column(
          // alignment: (messages![index].messageType == "receiver"
          //     ? Alignment.topLeft
          //     : Alignment.topRight),
          children: <Widget>[
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (messages![index].messageType == "receiver"
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Text("Date"),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Align(
                alignment: (messages![index].messageType == "receiver"
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Container(
                  //width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (messages![index].messageType == "receiver"
                        ? Colors.grey.shade200
                        : Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all(14),
                  child: CheckType(index, messages![index].url),
                ),
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl!),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${name}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: Text(
                        'Coversation',
                        textAlign: TextAlign.left,
                      ),
                      enabled: true,
                    )),
                    PopupMenuItem(
                        child: ListTile(
                          leading: Icon(const IconData(0xf006a,
                              fontFamily: 'MaterialIcons')),
                          title: Text('Invite Agents'),
                          enabled: true,
                        ),
                        value: "/chat"),
                    PopupMenuItem(
                        child: ListTile(
                          leading: Icon(const IconData(0xe20a,
                              fontFamily: 'MaterialIcons')),
                          title: Text('Transfer Chat'),
                          enabled: true,
                        ),
                        value: "/chat"),
                    PopupMenuItem(
                        child: ListTile(
                          leading: Icon(const IconData(0xf02a3,
                              fontFamily: 'MaterialIcons')),
                          title: Text('Chat History'),
                          enabled: true,
                        ),
                        value: "/chat"),
                    PopupMenuItem(
                        child: ListTile(
                          leading: Icon(const IconData(0xe312,
                              fontFamily: 'MaterialIcons')),
                          title: Text('Close Chat'),
                          enabled: true,
                        ),
                        value: "/chat"),
                    PopupMenuItem(
                        child: ListTile(
                          leading: Icon(const IconData(0xf271,
                              fontFamily: 'MaterialIcons')),
                          title: Text('Customer Details'),
                          enabled: true,
                        ),
                        value: "/chat"),
                  ],
                  onSelected: (route) {
                    print(route);
                    // Note You must create respective pages for navigation
                    // Navigator.pushNamed(context, route);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // inspect(messages)

          listView,
          (attachments.isAttachment == true)
              ? alignList(
                  attachments.type, attachments.isAttachment, attachments.url)
              : alignList("text", false, ""),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget alignList(type, isFileUri, content) {
    var j = [
      modelSheet(context),
      SizedBox(
        width: 15,
      ),
      Expanded(
        child: TextField(
          onChanged: (newValue) => _onUrlChanged(newValue),
          controller: msgController,
          decoration: InputDecoration(
            hintText: "Write message...",
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
      FloatingActionButton(
        onPressed: () {
          print(msgController.text);
          if (msgController.text.isNotEmpty) {
            messages!.add(new ChatMessage(
                messageContent: msgController.text,
                messageType: "sender",
                isUrl: Uri.parse(msgController.text).isAbsolute,
                contentType: "text",
                url: '',
                actionBy: actionBy!,
                chatId: chatId!,
                eId: eId!));

            sendmsg(msgController.text, actionBy!, chatId!, eId!, false,
                Attachement("", "docType", "docFileUrl"));
            print(messages![messages!.length - 1].isUrl);
            setState(() {
              _scrollToEnd();
            });
          }
          msgController.clear();
        },
        child: Icon(
          Icons.send,
          color: Colors.white,
          size: 18,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
    ];
    var k = [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                const IconData(0xe16a, fontFamily: 'MaterialIcons'),
                size: 16,
              ),
              padding: EdgeInsets.all(20),
              elevation: 5,
              shape: CircleBorder(),
            ),
            Container(
              width: 200,
              height: 200,
              child: Container(
                  width: 120,
                  height: 200,
                  child: Image.network((content),
                      fit: BoxFit.contain, width: 300, height: 180)),
            ),
            MaterialButton(
              onPressed: () {
                messages!.add(new ChatMessage(
                    messageContent: content.toString(),
                    messageType: "sender",
                    isUrl: Uri.parse(msgController.text).isAbsolute,
                    contentType: "img",
                    url: content.toString(),
                    actionBy: actionBy!,
                    chatId: chatId!,
                    eId: eId!));
                print(messages![messages!.length - 1].isUrl);
                setState(() {});
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                const IconData(0xe571,
                    fontFamily: 'MaterialIcons', matchTextDirection: true),
                size: 16,
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
            ),
          ])
    ];
    var l = [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                const IconData(0xe16a, fontFamily: 'MaterialIcons'),
                size: 16,
              ),
              padding: EdgeInsets.all(20),
              elevation: 5,
              shape: CircleBorder(),
            ),
            Container(
              width: 200,
              height: 200,
              child: Container(
                width: 120,
                height: 200,
                child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.camera),
                    label: Text("Capture the camera")),
              ),
            ),
            MaterialButton(
              onPressed: () {
                messages!.add(new ChatMessage(
                    messageContent: content.toString(),
                    messageType: "sender",
                    isUrl: Uri.parse(msgController.text).isAbsolute,
                    contentType: "img",
                    url: content.toString(),
                    actionBy: actionBy!,
                    chatId: chatId!,
                    eId: eId!));
                print(messages![messages!.length - 1].isUrl);
                setState(() {});
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                const IconData(0xe571,
                    fontFamily: 'MaterialIcons', matchTextDirection: true),
                size: 16,
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
            ),
          ])
    ];
    if (type == "text") {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: (type == "text") ? 60 : 200,
          width: double.infinity,
          color: Colors.white,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: type == "text"
                  ? (j)
                  : type == "MSG"
                      ? (j)
                      : k),
        ),
      );
    } else if (type == "IMAGE") {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 20),
          height: (type == "text") ? 60 : 200,
          width: double.infinity,
          color: Colors.white,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: type == "text"
                  ? (j)
                  : type == "MSG"
                      ? (j)
                      : k),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: (type == "text") ? 60 : 200,
          width: double.infinity,
          color: Colors.white,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: type == "Doc"
                  ? (l)
                  : type == "MSG"
                      ? (j)
                      : k),
        ),
      );
    }
  }

  Widget modelSheet(context1) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isDismissible: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (builder) => bottomSheet(context1));
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  CheckType(index, url) {
    if (messages![index].contentType == "img") {
      if (messages![index].isUrl == "") {
        return (UrlPreview(index));
      } else {
        String? temp = messages![index].messageContent;
        return imagePreview(File(temp!), url);
      }
    }
    if (messages![index].contentType == "doc") {
      return docPreview(index, url);
    }

    if (messages![index].isUrl == "") {
      return (UrlPreview(index));
    } else
      return textPreview(index);
  }

  Widget bottomSheet(context1) {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(context1, Icons.insert_drive_file, Colors.indigo,
                      "Document", "document", 0),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      context1,
                      const IconData(0xe380, fontFamily: 'MaterialIcons'),
                      Colors.pink,
                      "Url",
                      "url",
                      3),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(context1, Icons.insert_photo, Colors.purple,
                      "Gallery", "gallery", 1),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      context1,
                      const IconData(0xe154, fontFamily: 'MaterialIcons'),
                      Colors.orange,
                      "Message",
                      "message",
                      7),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      context1,
                      const IconData(0xe74e, fontFamily: 'MaterialIcons'),
                      Colors.teal,
                      "Upload",
                      "upload",
                      9),
                  SizedBox(
                    width: 40,
                  ),
                  // iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  isFromAttachment(isFileUri, content) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) => ImageDialog(true, content));
  }

  Widget iconCreation(context1, IconData icons, Color color, String text,
      String type, int mediaType) {
    return InkWell(
      onTap: () async {
        if (type == "gallery1") {
          await _getFromGallery();
          var img1 = await imageFile!.path;
          var isImage = img1.isEmpty ? true : false;
          Navigator.pop(context);
          imageFile?.path == ""
              ? CircularProgressIndicator()
              : showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (builder) => ImageDialog(true, img1));
        } else if (type == "upload") {
          await chooseFileUsingFilePicker();
          print("Upload");
          print(sendFileType);
          if (sendFileType == "jpg") {
            print(objFile.path);
            messages!.add(new ChatMessage(
                messageContent: objFile.path.toString(),
                messageType: "sender",
                isUrl: true,
                contentType: sendFileType,
                url: objFile.path.toString(),
                actionBy: actionBy!,
                chatId: chatId!,
                eId: eId!));
          }
        } else {
          await Navigator.push(
              context1,
              MaterialPageRoute(
                  builder: (context) => AttachmentsPage(jsonData, mediaType)));
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  _launchURL(urllink) async {
    String url = urllink;
    print("LaunchUrl");
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  chooseFileUsingFilePicker() async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream: true,
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
        sendFileType = objFile.extension;
        print(objFile.name);
        print(objFile.bytes);
        print(objFile.size);
        print(objFile.extension);
        print(objFile.path);
      });
    }
  }

  Widget ImageDialog(isFileUrl, content) {
    return AlertDialog(
      //contentPadding:,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      actions: <Widget>[
        Row(children: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
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
                  child: Image.network((content),
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
              messages!.add(new ChatMessage(
                  messageContent: content.toString(),
                  messageType: "sender",
                  isUrl: Uri.parse(msgController.text).isAbsolute,
                  contentType: "img",
                  url: content.toString(),
                  actionBy: actionBy!,
                  chatId: chatId!,
                  eId: eId!));
              print(messages![messages!.length - 1].isUrl);
              setState(() {});
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
      ],
    );
  }

  Widget UrlPreview(index) {
    String? temp = messages![index].messageContent;
    return SimpleUrlPreview(
        url: temp!,
        onTap: () => _launchURL(messages![index].messageContent),
        bgColor: Theme.of(context).accentColor,
        isClosable: true,
        titleLines: 2,
        descriptionLines: 3,
        imageLoaderColor: Colors.white,
        previewHeight: 150,
        previewContainerPadding: EdgeInsets.all(10),
        //onTap: () => print('Hello Flutter URL Preview'),
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ));
  }

  Widget textPreview(index) {
    String? temp = messages![index].messageContent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(children: <Widget>[
          Text(
            temp!,
            //overflow: TextOverflow.clip,
            textAlign: TextAlign.right,
            softWrap: true,
          ),
        ]),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text("last seen"),
        ),
      ],
    );
  }

  NetworkImage getNetworkImage(String url, String authKey) {
    Map<String, String> header = Map();
    header["authentication-token"] = authKey;
    return NetworkImage(url, headers: header);
  }

  Widget imagePreview(_image, url) {
    // String _image1=_image;

    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => WebViewEx(url)));
      },
      child: Container(
        padding: const EdgeInsets.all(1.0),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: getNetworkImage(url, authToken), fit: BoxFit.cover)),
      ),
    );
  }

  Widget docPreview(index, url) {
    // String _image1=_image;
    String? temp = messages![index].messageContent;
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => WebViewEx(url)));
      },
      child: Text(
        temp!,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  fetchPost() async {
    await getChats().then((value) {
      this.messages = value;
    });
    // RestDemo obj1=new RestDemo();
    //.then((value) => value) as List<ChatMessage>;
  }

  @override
  Future<void> didChangeMetrics() async {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap >= 0) {
      setState(() {
        _overlap = overlap;
      });
    }
  }
}
