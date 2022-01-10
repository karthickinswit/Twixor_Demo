import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twixor_demo/API/apidata-service.dart';
import 'package:twixor_demo/helper_files/FileUploadWithHttp.dart';
import 'package:twixor_demo/models/SendMessageModel.dart';
import 'package:twixor_demo/models/SocketResponseModel.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:twixor_demo/models/chatUsersModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
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
import 'package:intl/intl.dart';
import 'models/Attachmentmodel.dart';

enum ImageSourceType { gallery, camera }

class ChatDetailPage extends StatefulWidget {
  String? jsonData = "";
  String attachmentData = "";
  List<ChatMessage> messages = [];

  ChatDetailPage(this.jsonData, this.attachmentData);

  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState(jsonData!, attachmentData);
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
  String attachmentData;
  ChatUsers? userdata;
  Attachment? attachment;
  // Attachment? attachments;

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

  final ScrollController _controller =
      ScrollController(initialScrollOffset: 10);

  final TextEditingController msgController = TextEditingController();

  _onUrlChanged(String updatedUrl) {
    setState(() {
      _url = updatedUrl;
      //fetchPost();
    });
  }

  _scrollToEnd() async {
    _controller.animateTo(_controller.position.maxScrollExtent + 1000,
        duration: Duration(microseconds: 600), curve: Curves.fastOutSlowIn);
  }

  List<ChatMessage>? messages = [];
  // ScrollController _controller = ScrollController();

  _ChatDetailPageState(this.jsonData, this.attachmentData);
  @override
  initState() {
    super.initState();
    setState(() {
      var temp = jsonDecode(jsonData);
      var temp2 = attachmentData.length != 0 ? jsonDecode(attachmentData) : "";
      attachment = (attachmentData.isNotEmpty)
          ? Attachment.fromJson(jsonDecode(attachmentData))
          : Attachment();
      userdata = ChatUsers.fromJson1(temp);
      // print(userdata.toString());
      this.imageUrl = userdata!.imageURL;
      this.name = userdata!.name;
      this.msgindex = userdata!.msgindex;
      this.messages = userdata!.messages;
      this.eId = userdata!.eId;
      //var messages=
      // this.messages =
      //     ChatMessage.fromJson(userdata.messages) as List<ChatMessage>?;
      this.actionBy = userdata!.actionBy;

      this.chatId = userdata!.chatId;
      this.eId = userdata!.eId;
    });
    WidgetsBinding.instance?.addObserver(this);
    socketMsgReceive();
    super.setState(() {});
    // if (attachments.isAttachment == true) {
    //   if (attachments.type == "MSG") msgController.text = attachments.desc!;
    // }
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
      addSemanticIndexes: true,
      padding: EdgeInsets.only(bottom: 60),
      itemBuilder: (context, index) {
        // print(messages![index].actionType);

        return Column(
          children: <Widget>[
            messages![index].actionType != "3"
                ? ChatUtilMessage(messages![index].actionType.toString())
                : Container(),
            Container(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Align(
                alignment: (messages![index].actionType == "1"
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Container(
                  //width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (messages![index].actionType == "3"
                        ? Colors.grey.shade200
                        : Colors.blue[50]),
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
                    Navigator.pop(context, userdata as ChatUsers);
                    //setState(() {});
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
          //  alignList("text", false, "")
          (attachment!.url != null)
              ? alignList(attachment!.contentType, attachment!.isDocument,
                  attachment!.url)
              : alignList("text", false, ""),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  ChatUtilMessage(String text) {
    var utilMsg = "";
    if (text == "2")
      utilMsg = "joined chat";
    else if (text == "4")
      utilMsg = "transferred chat To You";
    else if (text == "5")
      utilMsg = "invited";
    else if (text == "6")
      utilMsg = "accepted chat invitation";
    else if (text == "8")
      utilMsg = "closed this chat";
    else if (text == "9") utilMsg = "left this chat";
    return utilMsg != ""
        ? Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (Colors.blue[200]),
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: Text(utilMsg),
          )
        : Container();
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
          // print(msgController.text);
          //Attachment attachment;

          if (msgController.text.isNotEmpty) {
            var temp = new ChatMessage(
                messageContent: msgController.text,
                messageType: "sender",
                isUrl: Uri.parse(msgController.text).isAbsolute,
                contentType: "TEXT",
                url: '',
                attachment: Attachment(),
                eId: eId,
                actionType: "3",
                actionBy: actionBy!,
                actedOn: new DateTime.now().toString());
            // ignore: unnecessary_new
            messages!.add(temp);
            print(actionBy);

            sendmessage(SendMessage(
                action: "agentReplyChat",
                actionBy: int.parse(actionBy!),
                actionType: 3,
                attachment: Attachment(),
                chatId: chatId!,
                contentType: "Text",
                eId: int.parse(eId!),
                message: msgController.text));
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
                setState(() {});
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
                print(actionBy);
                messages!.add(new ChatMessage(
                    messageContent: "",
                    messageType: "sender",
                    isUrl: Uri.parse(msgController.text).isAbsolute,
                    contentType: "IMAGE",
                    url: attachment!.url,
                    attachment: attachment,
                    eId: eId,
                    actionType: "3",
                    actionBy: actionBy!,
                    actedOn: new DateTime.now().toString()));
                print(messages![messages!.length - 1].isUrl);
                sendmessage(SendMessage(
                  action: "agentReplyChat",
                  actionBy: int.parse(actionBy!),
                  actionType: 3,
                  attachment: attachment,
                  chatId: chatId!,
                  contentType: "IMAGE",
                  eId: int.parse(eId!),
                ));
                setState(() {
                  attachment = new Attachment();
                  attachmentData = "";
                  _scrollToEnd();
                });
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
                  attachment: new Attachment(),
                  actionType: "3",
                  eId: eId,
                  actionBy: actionBy!,
                ));
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
              children: type == "text"
                  ? (j)
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
    if (messages![index].contentType == "TEXT") {
      return textPreview(index);
    }

    if (messages![index].contentType == "IMAGE") {
      return imagePreview(messages![index]);
      if (messages![index].isUrl == "") {
        return (UrlPreview(index));
      } else {
        String? temp = messages![index].messageContent;
        // return imagePreview(messages![index].attachment);
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
          // print(sendFileType);
          if (sendFileType == "jpg") {
            print(objFile.path);
            print(objFile.toString());
            // messages!.add(new ChatMessage(
            //   messageContent: objFile.path.toString(),
            //   messageType: "sender",
            //   isUrl: true,
            //   contentType: sendFileType,
            //   url: objFile.path.toString(),
            //   attachment: new Attachment(),
            //   actionType: "3",
            //   actionBy: actionBy!,
            // )
            // );
          }
        } else {
          Navigator.push(
                  context1,
                  MaterialPageRoute(
                      builder: (context) =>
                          AttachmentsPage(jsonData, mediaType)))
              .then((tempAttachment) {
            print(tempAttachment.toString());
            var temp = tempAttachment as Attachment;
          });
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
        print(objFile.bytes.toString());
        print(objFile.size);
        print(objFile.extension);
        print(objFile.path);
        uploadmage(attachment!, objFile);
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
              // messages!.add(new ChatMessage(
              //   messageContent: content.toString(),
              //   messageType: "sender",
              //   isUrl: Uri.parse(msgController.text).isAbsolute,
              //   contentType: "img",
              //   url: content.toString(),
              //   attachment: new Attachment(),
              //   actionType: "3",
              //   eId: ,
              //   actionBy: actionBy!,
              // ));
              // print(messages![messages!.length - 1].isUrl);
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
      crossAxisAlignment: messages![index].actionType == "1"
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Column(children: <Widget>[
          Text(
            temp!,
            //overflow: TextOverflow.clip,
            textAlign: messages![index].actionType == "1"
                ? TextAlign.left
                : TextAlign.right,
            softWrap: true,
            textScaleFactor: 1,
          ),
        ]),
        Container(
          margin: const EdgeInsets.only(top: 5.0, left: 10),
          child: Text(
            ConvertTime(messages![index].actedOn.toString()),
            textScaleFactor: 0.7,
            textAlign: messages![index].actionType == "1"
                ? TextAlign.left
                : TextAlign.right,
          ),
        ),
      ],
    );
  }

  NetworkImage getNetworkImage(String url) {
    Map<String, String> header = Map();
    // header["authentication-token"] = authKey;
    return NetworkImage(url);
  }

  Widget imagePreview(ChatMessage message) {
    // String _image1=_image;

    // ignore: unnecessary_new
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(children: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => WebViewEx(message.attachment)));
            },
            child: Container(
              padding: const EdgeInsets.all(1.0),
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image:
                          getNetworkImage(message.attachment!.url.toString()),
                      fit: BoxFit.cover)),
            ),
          ),
        ]),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(ConvertTime(message.actedOn.toString()),
              textScaleFactor: 0.7,
              textAlign:
                  message.actionType == "3" ? TextAlign.left : TextAlign.right),
        ),
      ],
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

  socketMsgReceive() async {
    IOWebSocketChannel? channel;
    try {
      Map<String, String> mainheader = {
        "Content-type": "application/json",
        "authentication-token": authToken
      };

      channel = await IOWebSocketChannel.connect("wss://aim.twixor.com/actions",
          headers: mainheader);
      channel.stream.listen(
        (message) {
          print(message.toString());
          var message1 = json.decode(message);
          if (message1["action"] == "onOpen") {
            // connected = true;

            print("Connection establised.");
          } else if (message1["action"] == "customerReplyChat") {
            print("Message sent Socket");
            var json = SocketResponse.fromJson(message1);
            List<ChatMessage> k = json.content![0].response!.chat!.messages!;
//ChatUsers h=

            setState(() {
              messages!.addAll(k);
              //attachmentData = "";
              //attachment = null;

              setState(() {});
              _scrollToEnd();
            });
            print("haai");
          } else if (message1 == "customerStartChat") {
            print("Customer Start Chat");
            //return message;
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
}

ConvertTime(String time) {
  // print(time);
  // var temp = DateTime.parse(time);
  // print(temp); //DateFormat('d/M/yyyy').parse(time);

  // return DateFormat('dd,  yy s:s').format(temp).toString();
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var now = DateTime.parse(time);
  var formatter = new DateFormat('dd-MM-yyyy');

  var month = now.month.toString().padLeft(2, '0');

  var day = now.day.toString().padLeft(2, '0');
  String formattedTime = DateFormat('kk:mm:a').format(now);
  String formattedDate = formatter.format(now);
  print(formattedTime);
  print(formattedDate);
  return '${months[now.month - 1]} $day, ${now.year} ' + ' ' + formattedTime;
}
