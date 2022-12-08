class CancelBookingRequest {
  String payId;
  String amount;
  String transactionId;

  CancelBookingRequest({this.payId, this.amount, this.transactionId});

  CancelBookingRequest.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['amount'] = this.amount;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}
