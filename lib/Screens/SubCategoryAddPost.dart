import 'package:flutter/material.dart';

class SubCategoryAddPost extends StatefulWidget {
  @override
  _SubCategoryAddPostState createState() => _SubCategoryAddPostState();
}

class _SubCategoryAddPostState extends State<SubCategoryAddPost> {


  bool hourslelectindex = false ;
  bool dayselectIndex = false;
  bool weekselectIndex = false;

  Color hourTextColor ,dayTextcolor, weekTextColor = Colors.black;

  Color hourbackgroundcolor  =  Color(0xffe2f1ff);
  Color dayBackgroundcolor  =  Color(0xffe2f1ff);
  Color weekBackgroundColor = Color(0xffe2f1ff);


  bool salon_color=false;
  bool barbor_color=false;
  bool eyebrows_color=false;
  bool gyms_color=false;

  int sal_bar_eye_gym =0;


  bool show_hour = false ;
  bool show_day = false ;
  bool show_week = false ;

  bool show_hour_color = false ;
  bool show_day_color = false ;
  bool show_week_color = false ;

  int hour_day_week = 0 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },),
        title: Text('Add Post',style: TextStyle(fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,fontFamily: "Montserrat"),textAlign: TextAlign.center,),
        backgroundColor: Color(0xFFFAFAFA),
        centerTitle: true,

        actions: [
          Padding(padding: EdgeInsets.only(left: 20,right: 15,top: 15,bottom: 15),
              child:  Image.asset('assets/Images/refresh.png')),
        ],
      ),

      body:Container(
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        child:  SingleChildScrollView(
          child: Container(
            //height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Sub Category",style: TextStyle(color: Colors.black,fontFamily: "Montserrat",
                        fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                  ],
                ),

                Container(
                  height: 60.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
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



                        ],
                      ),
                    ],
                  ),

                ),

                Container(

                  child: SingleChildScrollView(
                    child:  Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(labelText: 'Title',
                                labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                                hintText: "Title",hintStyle: TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 14),

                                focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                                hintText: "Write Something",
                                hintStyle: TextStyle(fontFamily: "Montserrat",
                                    color: Colors.black,fontSize: 14),

                                focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 12),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(labelText: 'Location',
                              suffix: Image(image: AssetImage('assets/Images/add_location.png',),height: 16,width: 18,),
                              labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                              hintText: "Add Location",hintStyle: TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 14),
                              focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),), ),

                            textCapitalization: TextCapitalization.words,
                          ),
                        ),


                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                height: 55.0,
                                width: MediaQuery.of(context).size.width*0.40,
                                padding: EdgeInsets.only(top: 0.0,left: 6),
                                child: TextFormField(
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(labelText: 'Price',
                                      labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                                      hintText: "\$",hintStyle: TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 12,),
                                      focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                                  keyboardType: TextInputType.number,
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.60,
                                child:   Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          child:Text("Per",style: TextStyle(fontFamily: "Montserrat",fontSize: 10),),
                                          padding: EdgeInsets.only(left: 8),
                                        ),

                                        FlatButton(
                                          onPressed: () {

                                            print("hour_day_week"+hour_day_week.toString());
                                            if(hour_day_week==1)
                                            {

                                              show_hour=true;

                                            }
                                            else   if(hour_day_week==2)
                                            {

                                              show_day=true;

                                            }
                                            else
                                            {
                                              show_week=true;
                                            }
                                            setState(() {

                                            });

                                          },
                                          highlightColor: Colors.white,
                                          child: Text("+Add",style: TextStyle(color: Colors.blue,
                                              fontFamily: "Montserrat",fontSize: 10),),),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: (){

                                            if(show_hour_color==true)
                                            {
                                              show_hour_color=false;

                                            }
                                            else
                                            {
                                              show_hour_color=true;

                                              show_day_color = false ;
                                              show_week_color = false ;

                                            }

                                            hour_day_week=1;
                                            setState(() {

                                            });

                                          },
                                          child:
                                          Container(
                                            height: 40.0,
                                            width: 70.0,
                                            color:show_hour_color?Colors.blue:hourbackgroundcolor,
                                            child:
                                            Center(
                                              child: Text("Hour",style: TextStyle(fontFamily: "Montserrat",fontSize: 10 ,fontWeight: FontWeight.bold,
                                                  color:show_hour_color?Colors.white:Colors.black )),
                                            )
                                            ,),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 1),
                                        ),


                                        InkWell(
                                          onTap: (){

                                            if(show_day_color==true)
                                            {
                                              show_day_color=false;
                                            }
                                            else
                                            {
                                              show_day_color=true;


                                              show_hour_color = false ;
                                              show_week_color = false ;
                                            }

                                            hour_day_week=2;
                                            setState(() {

                                            });

                                          },
                                          child:
                                          Container(
                                            height: 40.0,
                                            width: 70.0,
                                            color:show_day_color?Colors.blue:hourbackgroundcolor,
                                            child:
                                            Center(
                                              child: Text("Day",style: TextStyle(fontFamily: "Montserrat",fontSize: 10 ,fontWeight: FontWeight.bold,
                                                  color:show_day_color?Colors.white:Colors.black )),
                                            )
                                            ,),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 1),
                                        ),


                                        InkWell(
                                          onTap: (){

                                            if(show_week_color==true)
                                            {
                                              show_week_color=false;
                                            }
                                            else
                                            {
                                              show_week_color=true;

                                              show_day_color = false ;
                                              show_hour_color = false ;

                                            }

                                            hour_day_week=3;
                                            setState(() {

                                            });

                                          },
                                          child:
                                          Container(
                                            height: 40.0,
                                            width: 70.0,
                                            color:show_week_color?Colors.blue:hourbackgroundcolor,
                                            child:
                                            Center(
                                              child: Text("Week",style: TextStyle(fontFamily: "Montserrat",fontSize: 10 ,fontWeight: FontWeight.bold,
                                                  color:show_week_color?Colors.white:Colors.black )),
                                            )
                                            ,),
                                        ),

                                      ],
                                    ),

                                  ],

                                ),
                              ),
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 20.0,
                        ),


                        show_hour? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 4,),
                                Text("Price",style: TextStyle(fontFamily: "Montserrat"),),
                                Padding(
                                  padding: EdgeInsets.only(left: 0,right: 0,top: 10,bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4,),
                                      Text("\$100",style: TextStyle(fontSize: 16.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 30.0,),
                                      Text("per hour",style: TextStyle(fontFamily: "Montserrat"),),
                                      InkWell(
                                        onTap: (){
                                          hour_day_week=1;
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          child:

                                          InkWell(
                                              onTap:()
                                              {
                                                show_hour=false;
                                                setState(() {

                                                });

                                              },
                                              child:
                                              Image.asset('assets/Images/remove.png',height: 20,width: 20,)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),


                          ],
                        ):Container(),

                        show_day?  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 4,),
                                Text("Price",style: TextStyle(fontFamily: "Montserrat"),),
                                Padding(
                                  padding: EdgeInsets.only(left: 0,right: 0,top: 10,bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4,),
                                      Text("\$250",style: TextStyle(fontSize: 16.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 30.0,),
                                      Text("per Day",style: TextStyle(fontFamily: "Montserrat"),),
                                      InkWell(
                                        onTap: (){
                                          hour_day_week=2;

                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          child:  InkWell(
                                            child: Image.asset('assets/Images/remove.png',height: 20,width: 20,),
                                            onTap: (){
                                              show_day = false;
                                              setState(() {

                                              });
                                            },
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ):Container(),

                        show_week? Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 4,),
                                Text("Price",style: TextStyle(fontFamily: "Montserrat"),),
                                Padding(
                                  padding: EdgeInsets.only(left: 0,right: 0,top: 10,bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4,),
                                      Text("\$1000",style: TextStyle(fontSize: 16.0,color: Colors.black,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 30.0,),
                                      Text("per week",style: TextStyle(fontFamily: "Montserrat"),),
                                      InkWell(
                                        onTap: (){
                                          hour_day_week=3;
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          child: InkWell(
                                            child: Image.asset('assets/Images/remove.png',height: 20,width: 20,),
                                            onTap: (){
                                              show_week = false;
                                              setState(() {

                                              });
                                            },
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ):Container(),

                        Padding(
                          padding: EdgeInsets.only(left: 7,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Add Details",style: TextStyle(color: Colors.black,fontFamily: "Montserrat",
                                  fontSize: 16.0,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(labelText: 'How many types of spa available?',
                                labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                                hintText: "2",
                                hintStyle: TextStyle(fontFamily: "Montserrat",
                                    color: Colors.black,fontSize: 14),

                                focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 100.0,left: 40.0,right: 40.0),
                          child: MaterialButton(
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadPhotosPage()));
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                            ),

                            color: Color(0xff4996f3),
                            height: MediaQuery.of(context).size.height / 16,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
