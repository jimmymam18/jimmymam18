class SendNotficationRequestModel {
  String sound;
  String priority;
  Notification notification;
  String to;

  SendNotficationRequestModel(
      {
        this.sound,
        this.priority,
        this.notification,
        this.to});

  SendNotficationRequestModel.fromJson(Map<String, dynamic> json) {
    sound = json['sound'];
    priority = json['priority'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

/*
  String type;
  String sender_emailid;
  String sender_profile;
  String reciver_token;
  String androidChannelId;
  String sender_token;
  String file_type;
*/

  Data(
      {this.sound,
        this.clickAction,
        this.title,
        this.body,
        /* this.type,
        this.sender_emailid,
        this.sender_profile,
        this.reciver_token,
        this.sender_token,
        this.file_type,
        this.androidChannelId*/});

  Data.fromJson(Map<String, dynamic> json) {
    sound = json['sound'];
    clickAction = json['click_action'];
    title = json['title'];
    body = json['body'];
    /* type = json['type'];
    sender_emailid = json['sender_emailid'];
    sender_profile = json['sender_profile'];
    reciver_token = json['reciver_token'];
    sender_token = json['sender_token'];
    androidChannelId = json['android_channel_id'];
    file_type = json['file_type'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['click_action'] = this.clickAction;
    data['title'] = this.title;
    data['body'] = this.body;
    /*data['type'] = this.type;
    data['sender_emailid'] = this.sender_emailid;
    data['sender_profile'] = this.sender_profile;
    data['reciver_token'] = this.reciver_token;
    data['sender_token'] = this.sender_token;
    data['android_channel_id'] = this.androidChannelId;
    data['file_type'] = this.file_type;*/
    return data;
  }
}

class Notification {
  String title;
  String body;
  String androidChannelId;
/*  String sound;
  bool contentAvailable;*/

  Notification(
      {this.title,
        this.body,
        this.androidChannelId
        /* this.sound,
        this.contentAvailable,*/});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    androidChannelId = json['android_channel_id'];
    /* sound = json['sound'];
    contentAvailable = json['content_available'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['android_channel_id'] = this.androidChannelId;

/*    data['sound'] = this.sound;
    data['content_available'] = this.contentAvailable;*/
    return data;
  }
}