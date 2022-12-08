import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ListCursorSliderPage.dart';

//import 'CouserSliderPage.dart';

class NewListViewPAgeClass extends StatefulWidget {
  @override
  _NewListViewPAgeClassState createState() => _NewListViewPAgeClassState();
}

class _NewListViewPAgeClassState extends State<NewListViewPAgeClass> {
  TextEditingController textEditingController= TextEditingController(text: "\$100");
  TextEditingController textEditingControllerone= TextEditingController(text: "\$250");
  TextEditingController editingControllertwo= TextEditingController(text: "\$1000");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 2,
        leading: Padding(padding: EdgeInsets.only(left: 15,right: 0,bottom: 0,top: 0),
          child: IconButton(icon: Image.asset('assets/Images/back.png' ),
          onPressed: (){
            Navigator.pop(context);
          },),),
        centerTitle: true,
        title: Text('RV',style: TextStyle(fontSize: 20,fontFamily: "Montserrat"),textAlign: TextAlign.center),
        backgroundColor:  Color(0xff4996f3),

      ),


      body: ListView(
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
             //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCusrsolPage()));
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
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCusrsolPage()));
              },
            ),
          ),


        ],
      ),
    );
  }
}
