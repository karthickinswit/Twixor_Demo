class Attachment {
  bool? isDocument;
  String? name;
  String? id;
  String? type;
  String? contentType;
  String? url;
  String? desc;

  Attachment(
      {this.isDocument,
      this.name,
      this.id,
      this.type,
      this.contentType,
      this.url,
      this.desc});
//json["message"] != null ? json["message"] as String : "";
  Attachment.fromJson(Map<dynamic, dynamic> json) {
    isDocument =
        json['isDocument'] != null ? json["isDocument"] as bool : false;

    name = json['name'] != null ? json["name"] as String : "";

    id = json['id'] != null ? json["id"] as String : "";
    type = json['type'] != null ? json["type"] as String : "";
    contentType =
        json['contentType'] != null ? json["contentType"] as String : "";
    url = json['url'] != null ? json["url"] as String : "";
    desc = json['desc'] != null ? json["desc"] as String : "";
  }
  Attachment.fromAPItoJson(Map<dynamic, dynamic> json) {
    isDocument =
        json['isDocument'] != null ? json["isDocument"] as bool : false;

    name = json['name'] != null ? json["name"] as String : "";

    id = json['id'] != null ? json["id"] : "";
    type = json['type'] != null
        ? json["type"] == 1
            ? "IMAGE"
            : ""
        : "";
    contentType =
        json['contentType'] != null ? json["contentType"] as String : "";
    url = json['url'] != null ? json["url"] as String : "";
    desc = json['desc'] != null ? json["desc"] as String : "";
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['isDocument'] = this.isDocument as bool;
    data['name'] = this.name as String;
    data['id'] = this.id as String;
    data['type'] = this.type as String;
    data['contentType'] = this.contentType as String;
    data['url'] = this.url as String;
    data['desc'] = this.desc as String;
    return data;
  }
}
