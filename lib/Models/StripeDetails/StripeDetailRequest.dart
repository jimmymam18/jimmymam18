class StripeDetailRequest {
  String user_id;
  String amount;
  String email;

  StripeDetailRequest({this.user_id, this.amount, this.email});

  StripeDetailRequest.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    amount = json['amount'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['amount'] = this.amount;
    data['email'] = this.email;
    return data;
  }
}
