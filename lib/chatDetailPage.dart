import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twixor_demo/helper_files/FileUploadWithHttp.dart';
import 'package:twixor_demo/models/chatMessageModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ListView.dart';
import 'attachmentsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'Chat2Page.dart';
enum ImageSourceType { gallery, camera }
class ChatDetailPage extends StatefulWidget{
   String? imageUrl;
   String? name;
   int? msgindex;
  ChatDetailPage(this.imageUrl, this.name,this.msgindex);

  //ChatDetailPage(TextInputType text);

  //ChatDetailPageState(imageUrl);



  @override
  _ChatDetailPageState createState() => _ChatDetailPageState(this.imageUrl, this.name,this.msgindex);
}



class _ChatDetailPageState extends State<ChatDetailPage> {
   String? imageUrl;
   String? name;
   int? msgindex;
   String _url = '';
   var objFile = null;
   String? contents ;
   ImagePicker picker = ImagePicker();
   var imageFile;
   _getFromGallery() async {
     var pickedFile = (await picker.pickImage(
       source: ImageSource.gallery,
     ));
     if (pickedFile != null) {
       setState(() {
         imageFile = File(pickedFile.path);
       });
     }
   }

// Get first 500 characters or how many you want
  String? preview ;
  // bool isUrl=true;
   final ScrollController _controller=ScrollController(keepScrollOffset: true);
   final TextEditingController msgController = TextEditingController();

   _onUrlChanged(String updatedUrl) {
     setState(() {
       _url = updatedUrl;
     });
   }

  List<ChatMessage> messages = [
    // ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    // ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    // ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

  _ChatDetailPageState(this.imageUrl,this.name, this.msgindex);

 // _ChatDetailPageState({Key? key,required this.imageUrl,});

// print(imageUrl);
  @override
  Widget build(BuildContext context){
    // print("rcvd fdata ${rcvdData['name']}");
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
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imageUrl!),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${ widget.name}',style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),

                // IconButton(
                //   onPressed: (){
                //     Navigator.pop(context);
                //   },
                //   icon:  Icon(Platform.isAndroid ? Icons.more_vert : Icons.more_horiz,color: Colors.black,),
                // )
                PopupMenuButton(
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(child: ListTile(title: Text('Coversation',textAlign: TextAlign.left,),enabled:true,)),
                    PopupMenuItem(child: ListTile(leading:  Icon(const IconData(0xf006a, fontFamily: 'MaterialIcons')),title: Text('Invite Agents'),enabled:true,),value:"/chat"),
                    PopupMenuItem(child: ListTile(leading: Icon(const IconData(0xe20a, fontFamily: 'MaterialIcons')),title: Text('Transfer Chat'),enabled:true,),value:"/chat"),
                    PopupMenuItem(child: ListTile(leading: Icon(const IconData(0xf02a3, fontFamily: 'MaterialIcons')),title: Text('Chat History'),enabled:true,),value:"/chat"),
                    PopupMenuItem(child: ListTile(leading: Icon(const IconData(0xe312, fontFamily: 'MaterialIcons')),title: Text('Close Chat'),enabled:true,),value:"/chat"),
                    PopupMenuItem(child: ListTile(leading: Icon(const IconData(0xf271, fontFamily: 'MaterialIcons')),title: Text('Customer Details'),enabled:true,),value:"/chat"),

                  ],
                  onSelected: (route) {
                    print(route);
                    // Note You must create respective pages for navigation
                   // Navigator.pushNamed(context, route);
                  },
                ),
                // PopupMenuButton(
                //     color: Colors.yellowAccent,
                //     elevation: 20,
                //     enabled: true,
                //     onSelected: (value) {
                //       setState(() {
                //         //_value = value;
                //       });
                //     },
                //     itemBuilder:(context) => [
                //       PopupMenuItem(
                //         child: Text("First"),
                //         value: "first",
                //         enabled: false,
                //       ),
                //       PopupMenuItem(
                //         child: Text("Second"),
                //         value: "Second",
                //       ),
                //     ]
                // )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[


          ListView.builder(
            controller: _controller,
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 50),
           // physics: ClampingScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: messages[index].isUrl?  SimpleUrlPreview(
                        url: messages[index].messageContent,
                        onTap: () => _launchURL(messages[index].messageContent),
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
                        )

                    ):Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                  ),
                ),
              );

            },

          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          backgroundColor:
                          Colors.transparent,
                          context: context,
                          builder: (builder) =>
                              bottomSheet());

                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Icon(Icons.add, color: Colors.white, size: 20, ),


                    ),
                  ),
                  SizedBox(width: 15,),
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
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: ()
                    {
                    print(msgController.text);
                    if(msgController.text.isNotEmpty){
                    messages.add(new ChatMessage(messageContent: msgController.text, messageType: "sender",isUrl:Uri.parse(msgController.text).isAbsolute));
                    print(messages[messages.length-1].isUrl);
                    setState(() {});
                    }
                    msgController.clear();
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget bottomSheet() {
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
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document","document"),

                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(const IconData(0xe380, fontFamily: 'MaterialIcons'), Colors.pink, "Url","url"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery","gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  iconCreation(const IconData(0xe154, fontFamily: 'MaterialIcons'), Colors.orange, "Message","message"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(const IconData(0xe74e, fontFamily: 'MaterialIcons'), Colors.teal, "Upload","upload"),
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
  Widget iconCreation(IconData icons, Color color, String text,String type) {
    return InkWell(
      onTap: () async {
        print("IconCreation");
        print(this.msgindex);
        if(type=="gallery")
        {

            _getFromGallery();
            print(imageFile);

              await showDialog(
                  context: context,
                  builder: (_) => ImageDialog((imageFile.toString()))
              );

        }
        else if(type=="upload"){
          chooseFileUsingFilePicker();
          contents = await objFile.path.readAsString();

// Get first 500 characters or how many you want
          String preview = contents!.substring(0, 500);
          Text(preview);
          messages.add(new ChatMessage(messageContent:"file://"+objFile.path , messageType: "sender",isUrl:Uri.parse("file://"+objFile.path).isAbsolute));
        }
        else {Navigator.push(context, MaterialPageRoute(builder: (context)=>AttachmentsPage(widget.msgindex)));}
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
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
  _launchURL(urllink) async {
    String url = urllink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void chooseFileUsingFilePicker() async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
      withReadStream:
      true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
        print(objFile.name);
        print(objFile.bytes);
        print(objFile.size);
        print(objFile.extension);
        print(objFile.path);
      });
    }
  }


  //onTap() {}

}
class ImageDialog extends StatelessWidget {
    String fileUrl;
   ImageDialog(this.fileUrl);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        child: Image.file(File(fileUrl)),
      ),
    );
  }
}


