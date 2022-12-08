import 'package:flutter/material.dart';

class ShowMessagePage extends StatefulWidget {
  @override
  _ShowMessagePageState createState() => _ShowMessagePageState();
}

class _ShowMessagePageState extends State<ShowMessagePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(padding: EdgeInsets.only(left: 16,top: 18,bottom: 19),
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/Images/back.png',height: 18,width: 20,),),
          ),
        centerTitle: true,

        title: Text('Message',style: TextStyle(fontSize: 20,fontFamily: "Montserrat",fontWeight: FontWeight.w500)),
        backgroundColor:  Color(0xff4996f3),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/Images/message_page.png',height: 120,width: 120,),
          ),
          Text("Your Message is empty",style: TextStyle(fontSize: 18,color: Colors.black,
              fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}


