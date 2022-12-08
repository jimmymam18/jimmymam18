import 'package:flutter/material.dart';

class CancellationPolicyPage extends StatefulWidget {
  @override
  _CancellationPolicyPageState createState() => _CancellationPolicyPageState();
}

class _CancellationPolicyPageState extends State<CancellationPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancellation Policy',style: TextStyle(fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,fontFamily: "montserrat"),textAlign: TextAlign.center,),
        backgroundColor:  Color(0xff4996f3),
        leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },),
        centerTitle: true,
      ),
      body: Column(

        children: [
          SizedBox(
            height: 40.0,
          ),
          Image.asset('assets/Images/cancellation_policy.png',height: 140,width: 140,),
          SizedBox(
            height: 20.0,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Guests may cancel their Booking between 7 days"
                  "\nand 24 hours before the event start time and receive"
                  "\na 50% refund (excluding Fees) of their Booking Price."
                  "\nBooking cancellations submitted less than 24 hours"
                  "\nbefore the Event start time are not refundable.",
                style: TextStyle(fontSize: 12,color: Colors.black,
                fontFamily: "Montserrat",fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
            ],
          ),
        ],
      ),
    );
  }
}
