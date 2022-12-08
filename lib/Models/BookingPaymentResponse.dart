class BookingPaymentResponse {
  String msg;
  String status;
  String transactionStatus;
  String transactionId;
  String bidId;

  BookingPaymentResponse(
      {this.msg,
        this.status,
        this.transactionStatus,
        this.transactionId,
        this.bidId});

  BookingPaymentResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    transactionStatus = json['transaction_status'];
    transactionId = json['transaction_id'];
    bidId = json['bid_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['transaction_status'] = this.transactionStatus;
    data['transaction_id'] = this.transactionId;
    data['bid_id'] = this.bidId;
    return data;
  }
}