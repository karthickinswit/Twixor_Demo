import 'chatMessageModel.dart';

class SocketResponse {
  String? action;
  List<Content>? content;

  SocketResponse({this.action, this.content});

  SocketResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int? eId;
  Response? response;
  Message? message;
  bool? status;

  Content({this.eId, this.response, this.message, this.status});

  Content.fromJson(Map<String, dynamic> json) {
    eId = json['eId'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eId'] = this.eId;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Response {
  Chat? chat;
  List<Users>? users;

  Response({this.chat, this.users});

  Response.fromJson(Map<String, dynamic> json) {
    chat = json['chat'] != null ? new Chat.fromJson(json['chat']) : null;
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chat != null) {
      data['chat'] = this.chat!.toJson();
    }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  String? chatId;
  List<ChatMessage>? messages;

  Chat({this.chatId, this.messages});

  Chat.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    if (json['messages'] != null) {
      messages = <ChatMessage>[];
      json['messages'].forEach((v) {
        messages!.add(new ChatMessage.fromLocaltoJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? uId;
  String? name;
  int? id;
  String? iconUrl;
  String? type;
  int? cId;

  Users({this.uId, this.name, this.id, this.iconUrl, this.type, this.cId});

  Users.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    id = json['id'];
    iconUrl = json['iconUrl'];
    type = json['type'];
    cId = json['cId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['name'] = this.name;
    data['id'] = this.id;
    data['iconUrl'] = this.iconUrl;
    data['type'] = this.type;
    data['cId'] = this.cId;
    return data;
  }
}

class Message {
  int? code;
  String? message;

  Message({this.code, this.message});

  Message.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
