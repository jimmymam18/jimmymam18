class StripeDetailResponse {
  String status;
  String msg;
  Payload payload;

  StripeDetailResponse({this.status, this.msg, this.payload});

  StripeDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }
}

class Payload {
  String customerId;
  String clientSecret;
  String ephemeralKey;
  String paymentIntentId;

  Payload(
      {this.customerId,
        this.clientSecret,
        this.ephemeralKey,
        this.paymentIntentId});

  Payload.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    clientSecret = json['client_secret'];
    ephemeralKey = json['ephemeral_key'];
    paymentIntentId = json['payment_intent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['client_secret'] = this.clientSecret;
    data['ephemeral_key'] = this.ephemeralKey;
    data['payment_intent_id'] = this.paymentIntentId;
    return data;
  }
}
