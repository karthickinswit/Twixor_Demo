import 'Attachmentmodel.dart';

class SendMessage {
  String? action;
  int? actionBy;
  int? actionType;
  Attachment? attachment;
  String? chatId;
  String? contentType;
  int? eId;
  String? message;

  SendMessage(
      {this.action,
      this.actionBy,
      this.actionType,
      this.attachment,
      this.chatId,
      this.contentType,
      this.eId,
      this.message});

  SendMessage.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    actionBy = json['actionBy'];
    actionType = json['actionType'];
    attachment = json['attachment'] != null
        ? new Attachment.fromJson(json['attachment'])
        : null;
    chatId = json['chatId'];
    contentType = json['contentType'];
    eId = json['eId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['actionBy'] = this.actionBy;
    data['actionType'] = this.actionType;
    if (this.attachment != null) {
      data['attachment'] = this.attachment!.toJson();
    }
    data['chatId'] = this.chatId;
    data['contentType'] = this.contentType;
    data['eId'] = this.eId;
    data['message'] = this.message;
    return data;
  }
}
