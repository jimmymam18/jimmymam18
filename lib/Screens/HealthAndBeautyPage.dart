import 'package:flutter/material.dart';

import 'ListCursorSliderPage.dart';

class HealthAndBeautyPage extends StatefulWidget {
  @override
  _HealthAndBeautyPageState createState() => _HealthAndBeautyPageState();
}

class _HealthAndBeautyPageState extends State<HealthAndBeautyPage> {

  TextEditingController textEditingController= TextEditingController(text: "\$100");
  TextEditingController textEditingControllerone= TextEditingController(text: "\$250");
  TextEditingController editingControllertwo= TextEditingController(text: "\$1000");

  bool salon_color=false;
  bool barbor_color=false;
  bool eyebrows_color=false;
  bool gyms_color=false;
  bool message_color=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health & Beauty',style: TextStyle(fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,fontFamily: "montserrat"),textAlign: TextAlign.center,),
        backgroundColor:  Color(0xff4996f3),
        leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.white,size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:  Container(
          //color: Colors.black,
          child: Column(
            children: [
              Container(
                height: 00.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                   /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: 80.0,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: RaisedButton(
                            onPressed: (){
                              if(salon_color==true)
                              {
                                salon_color=false;

                              }
                              else
                              {
                                salon_color=true;

                                barbor_color = false ;
                                eyebrows_color = false ;
                                gyms_color = false ;
                                message_color=false;

                              }

                              //hour_day_week=1;
                              setState(() {

                              });

                            },
                            color: salon_color?Colors.blue:Colors.white,
                            // textColor: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Salons",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,
                              color: salon_color?Colors.white:Colors.blue,
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: 80.0,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: RaisedButton(
                            onPressed: (){
                              if(barbor_color==true)
                              {
                                barbor_color=false;

                              }
                              else
                              {
                                barbor_color=true;

                                salon_color = false ;
                                eyebrows_color = false ;
                                gyms_color = false ;
                                message_color=false;

                              }

                              //hour_day_week=1;
                              setState(() {

                              });
                            },
                            color:barbor_color?Colors.blue:Colors.white,
                            //textColor: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Barbers",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,
                              color: barbor_color?Colors.white:Colors.blue,
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: 95.0,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: RaisedButton(
                            onPressed: (){
                              if(eyebrows_color==true)
                              {
                                eyebrows_color=false;

                              }
                              else
                              {
                                eyebrows_color=true;

                                salon_color = false ;
                                barbor_color = false ;
                                gyms_color = false ;
                                message_color=false;

                              }

                              //hour_day_week=1;
                              setState(() {

                              });
                            },
                            color:eyebrows_color?Colors.blue:Colors.white,
                            //textColor: Colors.blue,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Eyebrows",style: TextStyle(fontFamily: "Montserrat",fontSize: 12,

                              color: eyebrows_color?Colors.white:Colors.blue,)),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),

                        Container(
                          width: 80.0,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: RaisedButton(
                            onPressed: (){

                              if(gyms_color==true)
                              {
                                gyms_color=false;

                              }
                              else
                              {
                                gyms_color=true;

                                salon_color = false ;
                                barbor_color = false ;
                                eyebrows_color = false ;
                                message_color=false;

                              }

                              //hour_day_week=1;
                              setState(() {

                              });
                            },
                            color:gyms_color?Colors.blue:Colors.white,
                            //textColor: Colors.blue,

                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Gym's",style: TextStyle(fontFamily: "Montserrat",fontSize: 12
                              ,color:gyms_color?Colors.white:Colors.blue,),),
                          ),
                        ),

                        SizedBox(
                          width: 5.0,
                        ),

                        Container(
                          width: 90.0,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: RaisedButton(
                            onPressed: (){

                              if(message_color==true)
                              {
                                message_color=false;

                              }
                              else
                              {
                                message_color=true;

                                salon_color = false ;
                                barbor_color = false ;
                                eyebrows_color = false ;
                                gyms_color = false ;

                              }

                              //hour_day_week=1;
                              setState(() {

                              });
                            },
                            color:message_color?Colors.blue:Colors.white,
                            //textColor: Colors.blue,

                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Text("Message",style: TextStyle(fontFamily: "Montserrat",fontSize: 12
                              ,color:message_color?Colors.white:Colors.blue,),),
                          ),
                        ),



                      ],
                    ),*/
                  ],
                ),

              ),

              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    SizedBox(height: 15,),

                    Padding(
                      padding: EdgeInsets.only(left: 6,right: 6),
                      child: GestureDetector(
                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          child:  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child:  Row(
                              children: [
                                Container(
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular((10.0))),
                                    image: DecorationImage(image: AssetImage('assets/Images/rv_2.png',),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 120.0,
                                  width: 120.0,
                                ),

                                Container(
                                  height: 120.0,
                                  width: 220.0,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child:
                                        Container(
                                          // width: MediaQuery.of(context).size.width*0.75,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6.0),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('2013 Fort Hunter',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black,
                                                          fontFamily: "MontSerrat_Medium"),),
                                                    SizedBox(width: 30.0,height: 10,),
                                                    Image.asset('assets/Images/favourite_off.png',height: 28,width: 28,),],
                                                ),
                                              ),


                                              Wrap(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontSize: 11,fontWeight: FontWeight.bold,
                                                                fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingController,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Hour",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,

                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 11,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingControllerone,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Day",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(9.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 10,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: editingControllertwo,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Week",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),

                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 40.0,
                                                width:272.8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(9.0)),
                                                  color: Color(0xffe2f1ff),
                                                ),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Text('2195 Sycamore Lake Road, Menasha',style: TextStyle(fontSize: 10,fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 2),
                                                    ),
                                                    Image.asset('assets/Images/location.png',height: 10,),
                                                  ],
                                                ),
                                              ),],
                                          ) ,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),



                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCusrsolPage()));
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 6,right: 6),
                      child: GestureDetector(
                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          child:  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child:  Row(
                              children: [
                                Container(
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular((10.0))),
                                    image: DecorationImage(image: AssetImage('assets/Images/rv_small.png',),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 120.0,
                                  width: 120.0,
                                ),

                                Container(
                                  height: 120.0,
                                  width: 220.0,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child:
                                        Container(
                                          // width: MediaQuery.of(context).size.width*0.75,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6.0),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('2013 Fort Hunter',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black,
                                                          fontFamily: "MontSerrat_Medium"),),
                                                    SizedBox(width: 30.0,height: 10,),
                                                    Image.asset('assets/Images/favourite_on.png',height: 28,width: 28,),],
                                                ),
                                              ),


                                              Wrap(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontSize: 11,fontWeight: FontWeight.bold,
                                                                fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingController,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Hour",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,

                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 11,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingControllerone,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Day",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(9.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 10,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: editingControllertwo,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Week",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),

                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 40.0,
                                                width:272.8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(9.0)),
                                                  color: Color(0xffe2f1ff),
                                                ),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Text('2195 Sycamore Lake Road, Menasha',style: TextStyle(fontSize: 10,fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 2),
                                                    ),
                                                    Image.asset('assets/Images/location.png',height: 10,),
                                                  ],
                                                ),
                                              ),],
                                          ) ,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),



                        ),
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCusrsolPage()));
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 6,right: 6),
                      child: GestureDetector(
                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          child:  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child:  Row(
                              children: [
                                Container(
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular((10.0))),
                                    image: DecorationImage(image: AssetImage('assets/Images/rv_2.png',),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 120.0,
                                  width: 120.0,
                                ),

                                Container(
                                  height: 120.0,
                                  width: 220.0,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child:
                                        Container(
                                          // width: MediaQuery.of(context).size.width*0.75,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6.0),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('2013 Fort Hunter',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black,
                                                          fontFamily: "MontSerrat_Medium"),),
                                                    SizedBox(width: 30.0,height: 10,),
                                                    Image.asset('assets/Images/favourite_off.png',height: 28,width: 28,),],
                                                ),
                                              ),


                                              Wrap(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontSize: 11,fontWeight: FontWeight.bold,
                                                                fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingController,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Hour",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,

                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 11,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: textEditingControllerone,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Day",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(9.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 6,),
                                                          height: 30,
                                                          width: 70,
                                                          child: TextField(
                                                            style: TextStyle(color: Color(0xff4996f3),fontWeight: FontWeight.bold,
                                                                fontSize: 10,fontFamily: "Montserrat_Medium"),textAlign: TextAlign.center,
                                                            enabled:false ,
                                                            controller: editingControllertwo,
                                                            decoration: InputDecoration(
                                                              enabled: false,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              labelText: "Per Week",
                                                              labelStyle: TextStyle(color: Colors.black87,fontSize: 10,fontFamily: "Montserrat"),
                                                              hoverColor: Colors.white,
                                                              fillColor: Colors.white,
                                                              filled:true,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Color(0xff4996f3),style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),

                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 40.0,
                                                width:272.8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(9.0)),
                                                  color: Color(0xffe2f1ff),
                                                ),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Text('2195 Sycamore Lake Road, Menasha',style: TextStyle(fontSize: 10,fontFamily: "Montserrat",
                                                        fontWeight: FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 2),
                                                    ),
                                                    Image.asset('assets/Images/location.png',height: 10,),
                                                  ],
                                                ),
                                              ),],
                                          ) ,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),



                        ),
                        onTap: (){
                         // Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCusrsolPage()));
                        },
                      ),
                    ),



                   
                  ],
                ),
                //color: Colors.yellow,
              ),
            ],
          ),
        ),

      ),

    );
  }
}
