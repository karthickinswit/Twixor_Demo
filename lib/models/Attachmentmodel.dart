class Attachment {
  bool? isAttachment;
  String? name;
  String? id;
  String? url;
  String? desc;
  String? contentType;
  String? type;

  Attachment(
      {this.isAttachment,
      this.name,
      this.id,
      this.url,
      this.desc,
      this.contentType,
      this.type});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
        isAttachment: true,
        name: json['name'],
        id: json['id'],
        url: json['url'],
        desc: json['desc'],
        contentType: json['contentType'],
        type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAttachment'] = this.isAttachment;
    data['name'] = this.name;
    data['id'] = this.id;
    data['url'] = this.url;
    data['desc'] = this.desc;
    data['contentType'] = this.contentType;
    data['type'] = this.type;
    return data;
  }
}
