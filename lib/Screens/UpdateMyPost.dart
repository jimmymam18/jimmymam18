import 'package:bizitme/Models/OkDialog.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/MyPostPage.dart';
import 'package:bizitme/Screens/UpdatePhotoPage.dart';
import 'package:bizitme/Utils/CustomPlacePicker/src/place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/DashboardCategoryPage.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/entities/location_result.dart';
// import 'package:place_picker/widgets/place_picker.dart';
import 'package:bizitme/Models/HealthBeautyModel.dart';


import '../global.dart';
import 'UploadPhotosPage.dart';
import 'global.dart';

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


class UpdateMyPost extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String priceHour;
  final String priceDay;
  final String priceWeek;
  final String categoryName;
  final String documnetId;
  final String postingDate;
  final String latitude;
  final String longitude;
  final String latlng;
  final String userId;
  final String stripeAccountLink;
  final String deviceToken;
  final String subCategories;
  final List<String> names;

  UpdateMyPost({Key key, this.title, this.description, this.location, this.priceDay
    ,this.priceWeek, this.priceHour, this.categoryName, this.names, this.documnetId, this.postingDate,
    this.latitude, this.latlng, this.longitude, this.userId, this.stripeAccountLink, this.deviceToken,
      this.subCategories}) : super(key: key);

  @override
  _UpdateMyPostState createState() => _UpdateMyPostState();
}

class _UpdateMyPostState extends State<UpdateMyPost> {
  bool hourslelectindex = false ;
  bool dayselectIndex = false;
  bool weekselectIndex = false;

  Color hourTextColor ,dayTextcolor, weekTextColor = Colors.black;

  Color hourbackgroundcolor  =  Color(0xffe2f1ff);
  Color dayBackgroundcolor  =  Color(0xffe2f1ff);
  Color weekBackgroundColor = Color(0xffe2f1ff);

  ProgressDialog _progressDialog = new ProgressDialog();


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

  bool show_hour_color = false ;
  bool show_day_color = false ;
  bool show_week_color = false ;

  int hour_day_week = 0 ;

  TextEditingController priceController = new TextEditingController();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  String amountHour = "";
  String amountDay = "";
  String amountWeek = "";
  List<String> names = new List();
  String latitude = "";
  String longitude = "";
  String latlng = "";

  String subCategorieSelect = "";
  List<HealthBeautyModel> subCatModels= new List();
  List<String> purposeNameList = new List();
  List<String> dummyList = new List();
  List<String> dummyList1 = new List();
  String purposeTextBracketRemove = "";
  String categoryName="";


  void getImage()async{
    names.clear();
    for(int i=0; i< widget.names.length; i++){
      print("IMAGES NAME "+widget.names[i]);
      names.add(widget.names[i]);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    locationController.text = widget.location;
    if(widget.priceHour != ""){
      show_hour = true;
      amountHour = widget.priceHour;
      priceController.text = amountHour;
      hour_day_week = 1;
      show_hour_color=true;
      show_day_color = false ;
      show_week_color = false ;
    }
    if(widget.priceDay != ""){
      show_day = true;
      amountDay = widget.priceDay;
      priceController.text = amountDay;
      hour_day_week = 2;
      show_hour_color=false;
      show_day_color = true;
      show_week_color = false ;
    }
    if(widget.priceWeek != ""){
      show_week = true;
      amountWeek = widget.priceWeek;
      priceController.text = amountWeek;
      hour_day_week = 3;
      show_hour_color=false;
      show_day_color = false ;
      show_week_color = true ;
    }
    getImage();
    latitude = widget.latitude;
    longitude = widget.longitude;
    latlng = widget.latlng;

    addListToModel();
    super.initState();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyPostPage()));
      setState(() {});
    },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(icon: new Icon(Icons.arrow_back,color:Colors.black,size: 30,),
            onPressed: (){
              SHDFClass.saveSharedPrefValueString(AppConstants.CategoryName, null);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyPostPage()));
            },),
          title: Text('Update Post',style: TextStyle(fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,fontFamily: "Montserrat"),textAlign: TextAlign.center,),
          backgroundColor: Color(0xFFFAFAFA),
          centerTitle: true,

         /* actions: [
            Padding(padding: EdgeInsets.only(left: 20,right: 15,top: 15,bottom: 15),
                child:  Image.asset('assets/Images/refresh.png')),
          ],*/
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
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width*0.26,
                          padding: EdgeInsets.only(top: 0.0,left: 6),
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
                          child:   Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 14,bottom: 14),
                                    child:Text("Per",style: TextStyle(fontFamily: "Montserrat",fontSize: 10),),
                                    padding: EdgeInsets.only(left: 8),
                                  ),

                                /*  FlatButton(
                                    onPressed: () {

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
                                    highlightColor: Colors.white,
                                    child: Text("+Add",style: TextStyle(color: Colors.blue,
                                        fontFamily: "Montserrat",fontSize: 10),),),*/
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
                                      // priceController.text = amountHour;
                                      //amountHour = priceController.text;
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

                                      // priceController.text = amountDay;
                                      hour_day_week=2;
                                      // amountDay = priceController.text;
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
                                      {}*/

                                      //   priceController.text = amountWeek;
                                      show_week_color=true;
                                      show_day_color = false ;
                                      show_hour_color = false ;

                                      hour_day_week=3;
                                      // amountWeek = priceController.text;
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
                                height: 18,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10.0,
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
                             InkWell(
                               onTap: (){
                                 if(widget.priceHour != ""){
                                   priceController.text = widget.priceHour;
                                 }
                                 setState(() {});
                               },
                               child:  Text("\$"+amountHour,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                             ),
                              SizedBox(width: 13.0,),
                              Text("per hour",style: TextStyle(fontFamily: "Montserrat", fontSize: 12),),
                              InkWell(
                                onTap: (){
                                  hour_day_week=1;
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  child: InkWell(
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
                             InkWell(
                               onTap: (){
                                 if(widget.priceDay != ""){
                                   priceController.text = widget.priceDay;
                                 }
                                 setState(() {});
                               },
                               child:  Text("\$"+amountDay,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                             ),
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
                            InkWell(
                              onTap: (){
                                if(widget.priceWeek != ""){
                                  priceController.text = widget.priceWeek;
                                }
                                setState(() {});
                              },
                              child:   Text("\$"+amountWeek,style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
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
                      }else{

                        if(purposeNameList.isNotEmpty){
                          purposeTextBracketRemove = purposeNameList.toString().replaceAll("[","").replaceAll("]", "");
                        }


                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            UpdatePhotoPage(title: titleController.text, description: descriptionController.text,
                              location: locationController.text, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,names: names,
                            categoryName: widget.categoryName,documenttId:widget.documnetId, postingDate:widget.postingDate,
                            latitude:latitude, longitude: longitude,latlng: latlng,userId:widget.userId,stripeAccountLink:widget.stripeAccountLink,
                                deviceToken:widget.deviceToken,subCategories:purposeTextBracketRemove
                            )));
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
  /*  LatLng customLocation;
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

    print(latString);  // grubs
    print(test);  //  sheep
    print(result.latLng);

    latitude = latString;
    longitude = test;
    latlng = result.latLng.toString();



    // Handle the result in your way
    print(result.formattedAddress);

    setState(() {
      locationController.text = result.formattedAddress as String;
    });*/

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
    HealthBeautyModel  subeme;

    if(widget.categoryName == "Health & Beauty"){
      for(int i=0;i<healthBeautyList.length;i++)
      {
        subeme=new HealthBeautyModel();

        subeme.subCatName=healthBeautyList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(healthBeautyList[i])){
          subeme.isSelected=true;
          purposeNameList.add(healthBeautyList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());

        /*healthBeautyList.forEach((element) {
          if(dummyList.contains(element)){
            subeme.isSelected=true;
            purposeNameList.add(element);
            print("FITNESS LIST "+purposeNameList.toString());
          }else{
            subeme.isSelected=false;
          }

        });*/



      /*  for (int i = 0; i < values.length; i++){
          if(values[i]==healthBeautyList[i]){
            subeme.isSelected=true;
            purposeNameList.add(healthBeautyList[i]);
          }else{
            subeme.isSelected=false;
          }
        }*/



      }



    }else if(widget.categoryName == "Workspace"){
      for(int i=0;i<workspaceList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=workspaceList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(workspaceList[i])){
          subeme.isSelected=true;
          purposeNameList.add(workspaceList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());

       /* if(values[i]==workspaceList[i]){
          subeme.isSelected=true;
          purposeNameList.add(workspaceList[i]);
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);*/

      }
    }else if(widget.categoryName == "Studio"){
      for(int i=0;i<studioList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=studioList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(studioList[i])){
          subeme.isSelected=true;
          purposeNameList.add(studioList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());

       /* if(values[i]==studioList[i]){
          subeme.isSelected=true;
          purposeNameList.add(studioList[i]);
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);*/

      }
    }else if(widget.categoryName == "Event"){
      for(int i=0;i<eventsList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=eventsList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(eventsList[i])){
          subeme.isSelected=true;
          purposeNameList.add(eventsList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());

       /* if(values[i]==eventsList[i]){
          subeme.isSelected=true;
          purposeNameList.add(eventsList[i]);
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);*/

      }
    }else if(widget.categoryName == "Hospitality"){
      for(int i=0;i<hospitalityList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=hospitalityList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(hospitalityList[i])){
          subeme.isSelected=true;
          purposeNameList.add(hospitalityList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());


       /* if(values[i]==hospitalityList[i]){
          subeme.isSelected=true;
          purposeNameList.add(hospitalityList[i]);
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);*/

      }
    }else if(widget.categoryName == "Bio-Tech"){
      for(int i=0;i<bioTechList.length;i++)
      {
        HealthBeautyModel subeme=new HealthBeautyModel();

        subeme.subCatName=bioTechList[i];
        print(widget.subCategories);
        final split = widget.subCategories.split(','' ');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        dummyList.addAll(values.values);

        if(dummyList.contains(bioTechList[i])){
          subeme.isSelected=true;
          purposeNameList.add(bioTechList[i]);
          print("FITNESS LIST "+purposeNameList.toString());
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);
        print("FINAL LIST :"+subCatModels.toString());

       /* if(values[i]==bioTechList[i]){
          subeme.isSelected=true;
          purposeNameList.add(bioTechList[i]);
        }else{
          subeme.isSelected=false;
        }

        subCatModels.add(subeme);*/

      }
    }


    setState(() {});

  }


}