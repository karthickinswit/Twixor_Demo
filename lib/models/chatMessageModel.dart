import 'package:flutter/cupertino.dart';

class ChatMessage {
  String? messageContent;
  String? messageType;
  bool? isUrl;
  String? contentType;
  String? url;
  String? actionBy;

  String? actionType;
  String? actedOn;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.isUrl,
      required this.contentType,
      required this.url,
      required this.actionBy,
      required this.actionType,
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
    url = json['url'] != null ? json['url'] : "" as String;

    actionType =
        json["actionType"] != null ? json['actionType'].toString() : "";
    actedOn = json["actedOn"] != null ? json['actedOn'].toString() : "";
  }
  ChatMessage.fromLocaltoJson(Map<String, dynamic> json) {
    ///eId = json['eId'] as String;
    messageContent = json["messageContent"];
    messageType = json["messageType"];
    isUrl = json["isUrl"];
    contentType = json["contentType"];
    url = json["url"];
    actionBy = json["actionBy"];
    actionType = json["actionType"];
    actedOn = json["actedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageContent'] = this.messageContent;
    data['messageType'] = this.messageType;
    data['isUrl'] = this.isUrl;
    data['contentType'] = this.contentType;
    data['url'] = this.url;
    data['actionBy'] = this.actionBy;
    data["actionType"] = this.actionType;
    data["actedOn"] = this.actedOn;
    return data;
  }
}
