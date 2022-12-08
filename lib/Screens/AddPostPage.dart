import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/HealthBeautyModel.dart';
import 'package:bizitme/Screens/DashboardCategoryPage.dart';
import 'package:bizitme/Utils/CustomPlacePicker/src/place_picker.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/entities/location_result.dart';
// import 'package:place_picker/widgets/place_picker.dart';

import '../global.dart';
import 'UploadPhotosPage.dart';

final List<String> healthBeautyList = [
  'Salons',
  'Barbers',
  'eyebrows',
  'Gyms and massage',
];

final List<String> workspaceList = [
  'Conference room',
  'flex space',
  'classroom & Co-office',
];

final List<String> studioList = [
  'Art gallery',
  'Recording studios & Dance studio',
];

final List<String> eventsList = [
  'Stage',
  'Wedding',
];

final List<String> hospitalityList = [
  'Restaurant',
  'Bars & Cafes',
];

final List<String> bioTechList = [
  'lab',
];




class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  bool hourslelectindex = false ;
  bool dayselectIndex = false;
  bool weekselectIndex = false;

  Color hourTextColor ,dayTextcolor, weekTextColor = Colors.black;

  Color hourbackgroundcolor  =  Color(0xffe2f1ff);
  Color dayBackgroundcolor  =  Color(0xffe2f1ff);
  Color weekBackgroundColor = Color(0xffe2f1ff);

  String clickAdd = "0";


  void hourtextcolorchange(){

    setState(() {
      if(hourslelectindex == true){
        hourTextColor = Colors.white;
        hourbackgroundcolor = Colors.blue;
        hourslelectindex = false;
        dayselectIndex =true;
        weekselectIndex=true;
      }else{
        hourTextColor = Colors.black;
        hourbackgroundcolor = Color(0xffe2f1ff);
        hourslelectindex = true;
        dayselectIndex =false;
        weekselectIndex=false;
      }
    });

  }


  void daycolorchange(){

    setState(() {
      if(dayselectIndex == true){
        dayTextcolor = Colors.white;
        dayBackgroundcolor = Colors.blue;
        dayselectIndex= false;
        hourslelectindex = true;
        weekselectIndex=true;

      }else{
        dayTextcolor = Colors.black;
        dayBackgroundcolor = Color(0xffe2f1ff);
        dayselectIndex = true;
        hourslelectindex = false;
        weekselectIndex=false;
      }
    });
  }


  void weekcolorchange(){
    setState(() {
      if(weekselectIndex == true){
        weekTextColor = Colors.white;
        weekBackgroundColor = Colors.blue;
        weekselectIndex = false;

      }else{
        weekTextColor = Colors.black;
        weekBackgroundColor = Color(0xffe2f1ff);
        weekselectIndex = true;
        dayselectIndex= false;
        hourslelectindex = false;
      }
    });

  }

  bool show_hour = false ;
  bool show_day = false ;
  bool show_week = false ;

  bool show_hour_color = true ;
  bool show_day_color = false ;
  bool show_week_color = false ;

  int hour_day_week = 1 ;

  TextEditingController priceController = new TextEditingController();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  String amountHour = "";
  String amountDay = "";
  String amountWeek = "";
  String latitude = "";
  String longitude = "";
  String latlng = "";
  String subCategorieSelect = "";
  List<HealthBeautyModel> subCatModels= new List();
  List<String> purposeNameList = new List();
  String purposeTextBracketRemove = "";
  String categoryName="";

  @override
  void initState() {
    // TODO: implement initState
    hour_day_week = 1 ;
    Future.delayed(Duration.zero, ()async{
      categoryName = await SHDFClass.readSharedPrefString(AppConstants.CategoryName, "");
      print(categoryName);
      addListToModel();
      setState(() {});
    });
    super.initState();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoardCategoryPage()));
      setState(() {});
    },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
            onPressed: (){
              SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashBoardCategoryPage()));
            },),
          title: Text('Add Post',style: TextStyle(fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,fontFamily: "Montserrat"),textAlign: TextAlign.center,),
          backgroundColor: Color(0xFFFAFAFA),
          centerTitle: true,

          actions: [
            Padding(padding: EdgeInsets.only(left: 20,right: 15,top: 15,bottom: 15),
                child: InkWell(
                  onTap: (){
                    refresh();
                    setState(() {});
                  },
                  child:  Image.asset('assets/Images/refresh.png')
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                subCatModels.isNotEmpty
               ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Sub Category",style: TextStyle(color: Colors.black,fontFamily: "Montserrat",
                        fontSize: 14.0,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                  ],
                ):Container(),

                subCatModels.isNotEmpty
              ? Container(
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height * 0.08,
                 child: listViewSubCategoriesList(),
               )
                :Container(),


                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    controller: titleController,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14),
                    decoration: InputDecoration(labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                        hintText: "",hintStyle: TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 14),

                        focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14),
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        hintText: "",
                        hintStyle: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.black,
                            fontSize: 13),


                        focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),

                /* Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 12),
                child: InkWell(
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location',
                      suffix: Image(image: AssetImage('assets/Images/add_location.png',),height: 16,width: 18,),
                      labelStyle: TextStyle(color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold),
                      hintText: "",hintStyle: TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 14),
                      focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),), ),

                    textCapitalization: TextCapitalization.words,
                  ),
                  onTap:() async {
                    showPlacePicker();
                  },
                )
              ),*/

                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 12),
                  child:InkWell(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        enabled: false,
                        maxLines: 2,
                        decoration: InputDecoration(
                          suffix: Image(image: AssetImage('assets/Images/add_location.png',),height: 16,width: 18,),
                          labelText: 'Location',
                          labelStyle: TextStyle(
                              color: Colors.grey,fontFamily: "Montserrat",fontSize: 12,fontWeight: FontWeight.bold
                          ),
                          focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),), ),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14),
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'Enter Location';
                          }
                          return null;
                        },
                        controller: locationController,
                      ),

                      onTap:() async {
                        showPlacePicker();
                      }
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width*0.26,
                          padding: EdgeInsets.only(left: 6),
                          child: TextFormField(
                            controller: priceController,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(labelText: 'Price',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,fontWeight: FontWeight.bold
                                ),
                                hintText: "\$",
                                hintStyle: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.black,
                                  fontSize: 12,),
                                focusedBorder:UnderlineInputBorder
                                  (borderSide: BorderSide(color: Colors.grey)) ),
                            keyboardType: TextInputType.number,
                          ),

                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top:8),
                          child:   Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                   margin: EdgeInsets.only(top: 14,bottom: 14),
                                    child:Text("Per",style: TextStyle(fontFamily: "Montserrat",fontSize: 10),),
                                    padding: EdgeInsets.only(left: 8),
                                  ),

                               /*   FlatButton(
                                    onPressed: () {
                                  *//*    clickAdd = "1";
                                      print("hour_day_week"+hour_day_week.toString());

                                      if(hour_day_week==1){
                                        amountHour = priceController.text;
                                        if(amountHour == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_hour=true;
                                          priceController.text = "";
                                        }
                                      }

                                      if(hour_day_week==2){
                                        amountDay = priceController.text;
                                        if(amountDay == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_day=true;
                                          priceController.text = "";
                                        }
                                      }

                                      if(hour_day_week==3){
                                        amountWeek = priceController.text;
                                        if(amountWeek == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_week=true;
                                          priceController.text = "";
                                        }
                                      }

                                      setState(() {});*//*
                                    },
                                    highlightColor: Colors.white,
                                    child: Text("Per",
                                      style: TextStyle(
                                          color: Colors.blue,
                                        fontFamily: "Montserrat",
                                          fontSize: 10),
                                    ),
                                  ),*/
                                ],
                              ),

                              Row(

                                children: [
                                  InkWell(
                                    onTap: (){
                                      /*  if(show_hour_color==true)
                                      {
                                        show_hour_color=false;
                                      }
                                      else
                                      {

                                      }*/
                                      show_hour_color=true;
                                      show_day_color = false ;
                                      show_week_color = false ;

                                      hour_day_week=1;
                                      //  priceController.text = amountHour ;
                                      setState(() {});
                                    },
                                    child:
                                    Container(
                                      height: 27.0,
                                      width: 42.0,
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
                                      /*  if(show_day_color==true)
                                      {
                                        show_day_color=false;
                                      }
                                      else
                                      {

                                      }*/
                                      show_day_color=true;
                                      show_hour_color = false ;
                                      show_week_color = false ;

                                      hour_day_week=2;
                                      // priceController.text = amountDay ;
                                      //amountDay = priceController.text;
                                      setState(() {});
                                    },
                                    child:
                                    Container(
                                      height: 27.0,
                                      width: 42.0,
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
                                      /* if(show_week_color==true)
                                      {
                                        show_week_color=false;
                                      }
                                      else
                                      {

                                      }*/
                                      show_week_color=true;
                                      show_day_color = false ;
                                      show_hour_color = false ;

                                      hour_day_week=3;

                                      // amountWeek = priceController.text;
                                      //  priceController.text = amountWeek;
                                      setState(() {});

                                    },
                                    child:
                                    Container(
                                      height: 27.0,
                                      width: 42.0,
                                      color:show_week_color?Colors.blue:hourbackgroundcolor,
                                      child:
                                      Center(
                                        child: Text("Week",style: TextStyle(fontFamily: "Montserrat",fontSize: 10 ,fontWeight: FontWeight.bold,
                                            color:show_week_color?Colors.white:Colors.black )),
                                      )
                                      ,),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      clickAdd = "1";
                                      print("hour_day_week"+hour_day_week.toString());

                                      if(hour_day_week==1){
                                        amountHour = priceController.text;
                                        if(amountHour == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_hour=true;
                                          priceController.text = "";
                                        }
                                      }

                                      if(hour_day_week==2){
                                        amountDay = priceController.text;
                                        if(amountDay == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_day=true;
                                          priceController.text = "";
                                        }
                                      }

                                      if(hour_day_week==3){
                                        amountWeek = priceController.text;
                                        if(amountWeek == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please enter price",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          show_week=true;
                                          priceController.text = "";
                                        }
                                      }

                                      setState(() {});
                                    },
                                    child:
                                    Container(
                                      height: 35.0,
                                      width: 70.0,
                                      margin: EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          color:Colors.blue,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Center(
                                        child: Text("Add Price",style: TextStyle(fontFamily: "Montserrat",fontSize: 11 ,fontWeight: FontWeight.bold,
                                            color:Colors.white )),
                                      )
                                      ,),
                                  ),


                                ],
                              ),

                              new SizedBox(
                                height: 25,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                show_hour?  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 4,),
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 0,top: 0,bottom: 0),
                          child: Text("Price",style: TextStyle(
                            fontFamily: "Montserrat",

                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15,right: 0,top:5,bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 2,),
                              Text("\$"+amountHour,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(width: 13.0,),
                              Text("per hour",style: TextStyle(fontFamily: "Montserrat", fontSize: 12),),
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
                                        amountHour = "";
                                        priceController.text = amountHour;
                                        setState(() {});

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

                show_day? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 4,),
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 0,top: 8,bottom: 0),
                          child: Text("Price",style: TextStyle(
                            fontFamily: "Montserrat",

                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15,right: 0,top: 5,bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 2,),
                              Text("\$"+amountDay,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(width: 13.0,),
                              Text("per Day",style: TextStyle(fontFamily: "Montserrat", fontSize: 12),),
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
                                      amountDay = "";
                                      priceController.text = amountDay;

                                      setState(() {});
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
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 0,top: 8,bottom: 0),
                          child: Text("Price",style: TextStyle(
                            fontFamily: "Montserrat",

                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15,right: 0,top: 5,bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 2,),
                              Text("\$"+amountWeek,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(width: 13.0,),
                              Text("per week",style: TextStyle(fontFamily: "Montserrat", fontSize: 12),),
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
                                      amountWeek = "";

                                      priceController.text = amountWeek;
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
                  padding: const EdgeInsets.only(top: 30.0,left: 40.0,right: 40.0),
                  child: MaterialButton(
                    onPressed: () {
                      if(titleController.text == ""){
                        Fluttertoast.showToast(
                            msg: "Please enter title",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(descriptionController.text == ""){
                          Fluttertoast.showToast(
                              msg: "Please enter description",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }else if(locationController.text == ""){
                        Fluttertoast.showToast(
                            msg: "Please enter location",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }/*else if(priceController.text == ""){
                        Fluttertoast.showToast(
                            msg: "Please enter price",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }*/else if(hour_day_week == 1 && amountHour == "" ){
                        Fluttertoast.showToast(
                            msg: "Please enter price for hour",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if(hour_day_week == 2 &&  amountDay == ""){
                        Fluttertoast.showToast(
                          //  msg: "Please click on add button to add price",
                            msg: "Please enter price for day",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(hour_day_week == 3 &&  amountWeek == ""){
                        Fluttertoast.showToast(
                            msg: "Please enter price for week",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            UploadPhotosPage(title: titleController.text, description: descriptionController.text,
                              location: locationController.text, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,
                              latitude:latitude, longitude: longitude,latlng: latlng,subCategories: purposeTextBracketRemove,)));
                      }
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
          ),
        ),
      ),);
  }


  void showPlacePicker() async {
   /* LatLng customLocation;
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(AppConstants.googleMapsAPIKey,
              displayLocation: customLocation,
            )));

    final tagName = result.latLng.toString();
    final split = tagName.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
     // {0: grubs, 1:  sheep}

    final value1 = values[0];
    final value2 = values[1];

    String myString = value1;
    String latString = myString.substring(7);

    String mylngString = value2;
    String lngString = mylngString.substring(1);

   String test = lngString.replaceAll(")", "");


    print(result.latLng);

    latitude = latString;
    longitude = test;
    latlng = result.latLng.toString();
    print(latitude);  // grubs
    print(longitude);  //  sheep

    // Handle the result in your way
    print(result.formattedAddress);

    setState(() {
      locationController.text = result.formattedAddress as String;
    });

*/

    String placeName = "";
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return PlacePicker(
          apiKey: AppConstants.googleMapsAPIKey,

          initialPosition: LatLng(global_lati, global_longi),

          useCurrentLocation: true,
          automaticallyImplyAppBarLeading: true,
          //usePlaceDetailSearch: true,
          hintText: "Choose Location",
          onGeocodingSearchFailed: (result) async {
            print("onGeocodingSearchFailed");
          },
          onAutoCompleteFailed: (result) async {
            print("onAutoCompleteFailed");
          },

          onPlacePicked: (result) async {
            try {

              latitude =  result
                  .geometry
                  .location
                  .lat.toString();

              longitude = result
                  .geometry
                  .location
                  .lng.toString();

              latlng = result.geometry.location.lat.toString()+","+result.geometry.location.lng.toString();

              placeName = result.formattedAddress.toString()?? "Null place name!";
              if (placeName == "") {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context1) => OKDialogBox(
                      title: 'Please drag the map to get address',
                      description: "",
                      my_context: context,
                    ));
              } else {
                Navigator.pop(context, true);
                setState(() {
                  locationController.text = placeName;
                });
              }
            } catch (e) {

            }
          },
        );
      },
    ));


  }


  void refresh(){
    titleController.text ="";
    descriptionController.text = "";
    locationController.text = "";
    priceController.text = "";
    hour_day_week = 1 ;
     amountHour = "";
     amountDay = "";
     amountWeek = "";
     show_hour = false ;
     show_day = false ;
     show_week = false ;
    show_hour_color=true;
    show_day_color = false ;
    show_week_color = false ;
  }


  ListView listViewSubCategoriesList() {
    return ListView.builder(
      itemCount: subCatModels.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.01,
              MediaQuery.of(context).size.height * 0.01,
              MediaQuery.of(context).size.height * 0.01,
              MediaQuery.of(context).size.height * 0.01),
          child: RaisedButton(
            onPressed: (){
              String name = subCatModels[position].subCatName;
              if( subCatModels[position].isSelected){
                subCatModels[position].isSelected = false;
                purposeNameList.remove(name);
              }else{
                subCatModels[position].isSelected = true;
                purposeNameList.add(name);
              }
              purposeTextBracketRemove = purposeNameList.toString().replaceAll("[","").replaceAll("]", "");
              print("DATA LIOST "+purposeTextBracketRemove);
              setState(() {});

            },
            color:subCatModels[position].isSelected? Colors.blue:Colors.white,
            // textColor: Colors.blue,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue,width: 2.0),
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(subCatModels[position].subCatName,style: TextStyle(fontFamily: "Montserrat",fontSize: 12,
              color: subCatModels[position].isSelected? Colors.white:Colors.blue,
            )),
          ),

        );
      },
    );
  }


  void addListToModel()async{
    categoryName = await SHDFClass.readSharedPrefString(AppConstants.CategoryName, "");


    if(categoryName == "Health & Beauty"){
      for(int i=0;i<healthBeautyList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=healthBeautyList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }else if(categoryName == "Workspace"){
      for(int i=0;i<workspaceList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=workspaceList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }else if(categoryName == "Studio"){
      for(int i=0;i<studioList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=studioList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }else if(categoryName == "Event"){
      for(int i=0;i<eventsList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=eventsList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }else if(categoryName == "Hospitality"){
      for(int i=0;i<hospitalityList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=hospitalityList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }else if(categoryName == "Bio-Tech"){
      for(int i=0;i<bioTechList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=bioTechList[i];
        subeme.isSelected=false;

        subCatModels.add(subeme);

      }
    }


  setState(() {});

  }


}
