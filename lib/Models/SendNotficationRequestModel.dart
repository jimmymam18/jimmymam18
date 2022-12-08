class SendNotficationRequestModel {
  Data data;
  String androidChannelId;
  bool contentAvailable;
  String sound;
  String priority;
  Notification1 notification;
  String to;

  SendNotficationRequestModel({this.data, this.androidChannelId, this.contentAvailable, this.sound, this.priority, this.notification, this.to});

  SendNotficationRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    androidChannelId = json['android_channel_id'];
    contentAvailable = json['content_available'];
    sound = json['sound'];
    priority = json['priority'];
    notification = json['notification'] != null ? new Notification1.fromJson(json['notification']) : null;
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['android_channel_id'] = this.androidChannelId;
    data['content_available'] = this.contentAvailable;
    data['sound'] = this.sound;
    data['priority'] = this.priority;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    data['to'] = this.to;
    return data;
  }
}

class Data {
  String sound;
  String clickAction;
  String title;
  String body;
  String type;
  String sender_emailid;
  String sender_profile;
  String reciver_token;
  String androidChannelId;
  String sender_token;
  String group_doc_id;
  String file_type;
  String date;

  Data(
      {this.sound,
        this.clickAction,
        this.title,
        this.body,
        this.type,
        this.sender_emailid,
        this.sender_profile,
        this.reciver_token,
        this.sender_token,
        this.group_doc_id,
        this.file_type,
        this.androidChannelId,
        this.date});

  Data.fromJson(Map<String, dynamic> json) {
    sound = json['sound'];
    clickAction = json['click_action'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    sender_emailid = json['sender_mobile'];
    sender_profile = json['sender_profile'];
    reciver_token = json['reciver_token'];
    sender_token = json['sender_token'];
    group_doc_id = json['group_doc_id'];
    androidChannelId = json['android_channel_id'];
    file_type = json['file_type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['click_action'] = this.clickAction;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['sender_mobile'] = this.sender_emailid;
    data['sender_profile'] = this.sender_profile;
    data['reciver_token'] = this.reciver_token;
    data['sender_token'] = this.sender_token;
    data['android_channel_id'] = this.androidChannelId;
    data['group_doc_id'] = this.group_doc_id;
    data['file_type'] = this.file_type;
    data['date'] = this.date;
    return data;
  }
}

class Notification1 {
  String title;
  String body;
  String sound;
  bool contentAvailable;
  String androidChannelId;
  String clickAction;

  Notification1({this.title, this.body, this.sound, this.contentAvailable, this.clickAction, this.androidChannelId});

  Notification1.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
    contentAvailable = json['content_available'];
    clickAction = json['clickAction'];
    androidChannelId = json['android_channel_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['sound'] = this.sound;
    data['content_available'] = this.contentAvailable;
    data['clickAction'] = this.clickAction;
    data['android_channel_id'] = this.androidChannelId;
    return data;
  }
}