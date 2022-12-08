class ChatMessageModel {
  String message = "";
  String sender_email = "";
  String date = "";
  String time = "";
  String key = "";
  String file_type = "";
  String instrument_id = "";
  bool isContainsFile= false;
  bool isPlaying= false;

  ChatMessageModel({this.message, this.sender_email, this.date, this.time, this.file_type, this.instrument_id, this.key });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sender_email'] = this.sender_email;
    data['date'] = this.date;
    data['key'] = this.key;
    data['time'] = this.time;
    data['file_type'] = this.file_type;
    data['instrument_id'] = this.instrument_id;

    return data;
  }

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sender_email = json['sender_email'];
    date = json['date'];
    time = json['time'];
    key = json['key'];
    file_type = json['file_type'];
    instrument_id = json['instrument_id'];
   }
}
