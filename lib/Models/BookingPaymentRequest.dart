class BookingPaymentRequest {
  String bidId;
  String amount;
  String destinationAccount;
  String source;

  BookingPaymentRequest(
      {this.bidId, this.amount, this.destinationAccount, this.source});

  BookingPaymentRequest.fromJson(Map<String, dynamic> json) {
    bidId = json['bid_id'];
    amount = json['amount'];
    destinationAccount = json['destination_account'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid_id'] = this.bidId;
    data['amount'] = this.amount;
    data['destination_account'] = this.destinationAccount;
    data['source'] = this.source;
    return data;
  }
}