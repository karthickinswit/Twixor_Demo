// import 'dart:convert';

// class ChatMessageS {
//   List<Chats>? chats;

//   ChatMessageS({this.chats});

//   ChatMessageS.fromJson(Map<dynamic, dynamic> json) {
//     if (json['chats'] != null) {
//       chats = <Chats>[];
//       json['chats'].forEach((v) {
//         chats!.add(new Chats.fromJson(v));
//       });
//     }
//   }

//   Map toJson() {
//     final Map data = new Map<dynamic, dynamic>();
//     if (this.chats != null) {
//       data['chats'] = this.chats!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Chats {
//   Id? iId;
//   String? chatId;
//   int? cId;
//   int? eId;
//   int? state;
//   String? customerName;
//   String? customerNumber;
//   String? customerIconUrl;
//   Client? client;
//   int? customerChatChannelType;
//   String? contextId;
//   Callback? callback;
//   Callback? customerChatChannelData;
//   StartedOn? startedOn;
//   String? lastContentType;
//   String? lastMessage;
//   StartedOn? lastModifiedOn;
//   bool? isRated;
//   Callback? customerInfo;
//   Callback? metadata;
//   Id? serviceId;
//   List<Messages>? messages;
//   List<int>? participants;
//   int? handlingAgent;
//   int? pickedUpInterval;
//   Id? handlingDept;
//   List<String>? tags;
//   String? agentNote;
//   List<String>? invitedAgents;
//   int? invitePickUpInterval;
//   List<int>? agentsLeft;
//   bool? isCalendarMissed;

//   Chats(
//       {this.iId,
//       this.chatId,
//       this.cId,
//       this.eId,
//       this.state,
//       this.customerName,
//       this.customerNumber,
//       this.customerIconUrl,
//       this.client,
//       this.customerChatChannelType,
//       this.contextId,
//       this.callback,
//       this.customerChatChannelData,
//       this.startedOn,
//       this.lastContentType,
//       this.lastMessage,
//       this.lastModifiedOn,
//       this.isRated,
//       this.customerInfo,
//       this.metadata,
//       this.serviceId,
//       this.messages,
//       this.participants,
//       this.handlingAgent,
//       this.pickedUpInterval,
//       this.handlingDept,
//       this.tags,
//       this.agentNote,
//       this.invitedAgents,
//       this.invitePickUpInterval,
//       this.agentsLeft,
//       this.isCalendarMissed});

//   Chats.fromJson(Map<String, dynamic> json) {
//     iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
//     chatId = json['chatId'];
//     cId = json['cId'];
//     eId = json['eId'];
//     state = json['state'];
//     customerName = json['customerName'];
//     customerNumber = json['customerNumber'];
//     customerIconUrl = json['customerIconUrl'];
//     client =
//         json['client'] != null ? new Client.fromJson(json['client']) : null;
//     customerChatChannelType = json['customerChatChannelType'];
//     contextId = json['contextId'];
//     callback = json['callback'] != null
//         ? new Callback.fromJson(json['callback'])
//         : null;
//     customerChatChannelData = json['customerChatChannelData'] != null
//         ? new Callback.fromJson(json['customerChatChannelData'])
//         : null;
//     startedOn = json['startedOn'] != null
//         ? new StartedOn.fromJson(json['startedOn'])
//         : null;
//     lastContentType = json['lastContentType'];
//     lastMessage = json['lastMessage'];
//     lastModifiedOn = json['lastModifiedOn'] != null
//         ? new StartedOn.fromJson(json['lastModifiedOn'])
//         : null;
//     isRated = json['isRated'];
//     customerInfo = json['customerInfo'] != null
//         ? new Callback.fromJson(json['customerInfo'])
//         : null;
//     metadata = json['metadata'] != null
//         ? new Callback.fromJson(json['metadata'])
//         : null;
//     serviceId =
//         json['serviceId'] != null ? new Id.fromJson(json['serviceId']) : null;
//     if (json['messages'] != null) {
//       messages = <Messages>[];
//       json['messages'].forEach((v) {
//         messages!.add(new Messages.fromJson(v));
//       });
//     }
//     participants = json['participants'].cast<int>();
//     handlingAgent = json['handlingAgent'];
//     pickedUpInterval = json['pickedUpInterval'];
//     handlingDept = json['handlingDept'] != null
//         ? new Id.fromJson(json['handlingDept'])
//         : null;
//     tags = json['tags'].cast<String>();
//     agentNote = json['agentNote'];
//     if (json['invitedAgents'] != null) {
//       invitedAgents = <String>[];
//       json['invitedAgents'].forEach((v) {
//         invitedAgents!.add((v.toString()));
//       });
//     }
//     invitePickUpInterval = json['invitePickUpInterval'];
//     agentsLeft = json['agentsLeft'].cast<int>();
//     isCalendarMissed = json['isCalendarMissed'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.iId != null) {
//       data['_id'] = this.iId!.toJson();
//     }
//     data['chatId'] = this.chatId;
//     data['cId'] = this.cId;
//     data['eId'] = this.eId;
//     data['state'] = this.state;
//     data['customerName'] = this.customerName;
//     data['customerNumber'] = this.customerNumber;
//     data['customerIconUrl'] = this.customerIconUrl;
//     if (this.client != null) {
//       data['client'] = this.client!.toJson();
//     }
//     data['customerChatChannelType'] = this.customerChatChannelType;
//     data['contextId'] = this.contextId;
//     if (this.callback != null) {
//       data['callback'] = this.callback!.toJson();
//     }
//     if (this.customerChatChannelData != null) {
//       data['customerChatChannelData'] = this.customerChatChannelData!.toJson();
//     }
//     if (this.startedOn != null) {
//       data['startedOn'] = this.startedOn!.toJson();
//     }
//     data['lastContentType'] = this.lastContentType;
//     data['lastMessage'] = this.lastMessage;
//     if (this.lastModifiedOn != null) {
//       data['lastModifiedOn'] = this.lastModifiedOn!.toJson();
//     }
//     data['isRated'] = this.isRated;
//     if (this.customerInfo != null) {
//       data['customerInfo'] = this.customerInfo!.toJson();
//     }
//     if (this.metadata != null) {
//       data['metadata'] = this.metadata!.toJson();
//     }
//     if (this.serviceId != null) {
//       data['serviceId'] = this.serviceId!.toJson();
//     }
//     if (this.messages != null) {
//       data['messages'] = this.messages!.map((v) => v.toJson()).toList();
//     }
//     data['participants'] = this.participants;
//     data['handlingAgent'] = this.handlingAgent;
//     data['pickedUpInterval'] = this.pickedUpInterval;
//     if (this.handlingDept != null) {
//       data['handlingDept'] = this.handlingDept!.toJson();
//     }
//     data['tags'] = this.tags;
//     data['agentNote'] = this.agentNote;
//     if (this.invitedAgents != null) {
//       data['invitedAgents'] = this.invitedAgents!.map((v) => v).toList();
//     }
//     data['invitePickUpInterval'] = this.invitePickUpInterval;
//     data['agentsLeft'] = this.agentsLeft;
//     data['isCalendarMissed'] = this.isCalendarMissed;
//     return data;
//   }
// }

// class Id {
//   String? oid;

//   Id({this.oid});

//   Id.fromJson(Map<String, dynamic> json) {
//     oid = json['$oid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$oid'] = this.oid;
//     return data;
//   }
// }

// class Client {
//   String? os;
//   String? ipAddr;
//   String? country;
//   String? countryCode;
//   String? state;
//   String? city;
//   String? zip;
//   String? lat;
//   String? lng;

//   Client(
//       {this.os,
//       this.ipAddr,
//       this.country,
//       this.countryCode,
//       this.state,
//       this.city,
//       this.zip,
//       this.lat,
//       this.lng});

//   Client.fromJson(Map<String, dynamic> json) {
//     os = json['os'];
//     ipAddr = json['ipAddr'];
//     country = json['country'];
//     countryCode = json['countryCode'];
//     state = json['state'];
//     city = json['city'];
//     zip = json['zip'];
//     lat = json['lat'];
//     lng = json['lng'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['os'] = this.os;
//     data['ipAddr'] = this.ipAddr;
//     data['country'] = this.country;
//     data['countryCode'] = this.countryCode;
//     data['state'] = this.state;
//     data['city'] = this.city;
//     data['zip'] = this.zip;
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     return data;
//   }
// }

// class Callback {
//   Callback.fromJson(Map<String, dynamic> json) {}

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     return data;
//   }
// }

// class StartedOn {
//   int? date;

//   StartedOn({this.date});

//   StartedOn.fromJson(Map<String, dynamic> json) {
//     date = json['$date'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$date'] = this.date;
//     return data;
//   }
// }

// class Messages {
//   String? message;
//   String? contentType;
//   String? imageUrl;
//   StartedOn? postedOn;
//   int? actionType;
//   int? actionBy;
//   int? status;
//   String? actionId;
//   String? actedOn;
//   StartedOn? actedDateTime;
//   Attachment? attachment;
//   int? invitedAgent;
//   String? comment;

//   Messages(
//       {this.message,
//       this.contentType,
//       this.imageUrl,
//       this.postedOn,
//       this.actionType,
//       this.actionBy,
//       this.status,
//       this.actionId,
//       this.actedOn,
//       this.actedDateTime,
//       this.attachment,
//       this.invitedAgent,
//       this.comment});

//   Messages.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     contentType = json['contentType'];
//     imageUrl = json['imageUrl'];
//     postedOn = json['postedOn'] != null
//         ? new StartedOn.fromJson(json['postedOn'])
//         : null;
//     actionType = json['actionType'];
//     actionBy = json['actionBy'];
//     status = json['status'];
//     actionId = json['actionId'];
//     actedOn = json['actedOn'];
//     actedDateTime = json['actedDateTime'] != null
//         ? new StartedOn.fromJson(json['actedDateTime'])
//         : null;
//     attachment = json['attachment'] != null
//         ? new Attachment.fromJson(json['attachment'])
//         : null;
//     invitedAgent = json['invitedAgent'];
//     comment = json['comment'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['contentType'] = this.contentType;
//     data['imageUrl'] = this.imageUrl;
//     if (this.postedOn != null) {
//       data['postedOn'] = this.postedOn!.toJson();
//     }
//     data['actionType'] = this.actionType;
//     data['actionBy'] = this.actionBy;
//     data['status'] = this.status;
//     data['actionId'] = this.actionId;
//     data['actedOn'] = this.actedOn;
//     if (this.actedDateTime != null) {
//       data['actedDateTime'] = this.actedDateTime!.toJson();
//     }
//     if (this.attachment != null) {
//       data['attachment'] = this.attachment!.toJson();
//     }
//     data['invitedAgent'] = this.invitedAgent;
//     data['comment'] = this.comment;
//     return data;
//   }
// }

// class Attachment {
//   bool? isDocument;
//   String? name;
//   String? id;
//   String? type;
//   String? contentType;
//   String? url;
//   String? desc;
//   bool? isImage;

//   Attachment(
//       {this.isDocument,
//       this.name,
//       this.id,
//       this.type,
//       this.contentType,
//       this.url,
//       this.desc,
//       this.isImage});

//   Attachment.fromJson(Map<String, dynamic> json) {
//     isDocument = json['isDocument'];
//     name = json['name'];
//     id = json['id'];
//     type = json['type'];
//     contentType = json['contentType'];
//     url = json['url'];
//     desc = json['desc'];
//     isImage = json['isImage'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['isDocument'] = this.isDocument;
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['contentType'] = this.contentType;
//     data['url'] = this.url;
//     data['desc'] = this.desc;
//     data['isImage'] = this.isImage;
//     return data;
//   }
// }
