import 'package:flutter/cupertino.dart';
import 'package:twixor_demo/helper_files/Websocket.dart';

import 'Attachmentmodel.dart';

class ChatMessage {
  String? messageContent;
  String? messageType;
  bool? isUrl;
  String? contentType;
  String? url;
  String? actionBy;

  String? actionType;
  String? eId;
  String? actedOn;
  Attachment? attachment;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.isUrl,
      required this.contentType,
      required this.url,
      required this.actionBy,
      required this.attachment,
      required this.actionType,
      required this.eId,
      this.actedOn});

  ChatMessage.fromAPItoJson(Map<String, dynamic> json) {
    messageContent = json["message"] != null ? json["message"] as String : "";
    messageType = json["status"] != null
        ? json["status"] == 0
            ? "sender"
            : "receiver" as String
        : "";
    isUrl = json['isUrl'] == null ? false : true;
    contentType =
        json['contentType'] != null ? json["contentType"] as String : "";
    attachment = (json['attachment'] != null && json['attachment'].length != 0
        ? Attachment.fromJson(json['attachment'])
        : null);
    url = json['url'] != null ? json['url'] : "" as String;
    eId = json["eId"] != null ? json['eId'].toString() : "";
    actionType =
        json["actionType"] != null ? json['actionType'].toString() : "";
    actedOn = json["actedOn"] != null ? json['actedOn'].toString() : "";
  }
  ChatMessage.fromLocaltoJson(Map<String, dynamic> json) {
    ///eId = json['eId'] as String;
    messageContent = json["messageContent"] != null
        ? json["messageContent"]
        : json["message"] != null
            ? json["message"]
            : "";
    messageType = json["messageType"];
    isUrl = json["isUrl"];
    contentType = json["contentType"];
    attachment = (json['attachment'] != null && json['attachment'].length != 0
        ? Attachment.fromJson(json['attachment'])
        : null);
    url = json["url"];
    actionBy = json["actionBy"].toString();
    eId = json["eId"].toString();
    actionType = json["actionType"].toString();
    actedOn = json["actedOn"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageContent'] = this.messageContent;
    data['messageType'] = this.messageType;
    data['isUrl'] = this.isUrl;
    data['contentType'] = this.contentType;
    data['url'] = this.url;
    if (this.attachment != null && this.attachment!.url != "") {
      data['attachment'] = this.attachment!.toJson();
    }
    data['eId'] = this.eId;
    data['actionBy'] = this.actionBy;
    data["actionType"] = this.actionType;
    data["actedOn"] = this.actedOn;
    return data;
  }
}
