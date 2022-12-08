class CancelBookingResponse {
  String msg;
  String status;
  String payId;
  String transactionId;

  CancelBookingResponse(
      {this.msg, this.status, this.payId, this.transactionId});

  CancelBookingResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    payId = json['pay_id'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['pay_id'] = this.payId;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}
