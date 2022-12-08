class OtpRequest {
  String phoneno;
  String userId;
  String email;

  OtpRequest({this.phoneno, this.userId, this.email});

  OtpRequest.fromJson(Map<String, dynamic> json) {
    phoneno = json['phoneno'];
    userId = json['user_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneno'] = this.phoneno;
    data['user_id'] = this.userId;
    data['email'] = this.email;
    return data;
  }
}