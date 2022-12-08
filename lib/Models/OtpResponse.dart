class OtpResponse {
  String status;
  String msg;
  String otp;
  String userId;
  String email;

  OtpResponse({this.status, this.msg, this.otp, this.userId, this.email});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    otp = json['otp'];
    userId = json['user_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['otp'] = this.otp;
    data['user_id'] = this.userId;
    data['email'] = this.email;
    return data;
  }
}