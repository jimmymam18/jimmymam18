class Notification {
  String title;
  String body;
  String sound;
  bool contentAvailable;
  String androidChannelId;
  String clickAction;

  Notification({this.title, this.body, this.sound, this.contentAvailable, this.clickAction, this.androidChannelId});

  Notification.fromJson(Map<String, dynamic> json) {
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