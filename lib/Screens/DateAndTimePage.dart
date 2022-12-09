import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:bizitme/Screens/BankAccountPage.dart';
import 'package:intl/intl.dart';

import 'global.dart';

class DateAndTimePage extends StatefulWidget {
  final String priceText;
  final String documentId;
  final String title;
  final String description;
  final String location;
  final String priceHour;
  final String priceDay;
  final String priceWeek;
  final String categoryName;
  final String postingDate;
  final String latitude;
  final String longitude;
  final String latlng;
  final String addPostUserId;
  final String stripeAccountLink;
  final String deviceToken;
  final String receiverDeviceToken;
  final String documentIdAdd;
  final String userId;
  final String subCategories;
  final List<String> names;


  DateAndTimePage({Key key, this.priceText, this.documentId,this.title, this.description, this.location, this.priceDay
    ,this.priceWeek, this.priceHour, this.categoryName, this.names, this.postingDate, this.latitude,
    this.longitude, this.latlng,this.addPostUserId, this.stripeAccountLink, this.deviceToken, this.receiverDeviceToken,
  this.documentIdAdd, this.userId, this.subCategories}) : super(key: key);


  @override
  _DateAndTimePageState createState() => _DateAndTimePageState();
}

class _DateAndTimePageState extends State<DateAndTimePage> {

  int hournumber = 1;

  String fromDate = '';
  String toDate = '';
  String noOfHour = '1';


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String Hour, minute, _time;
  String showStartTime = "";
  String showEndTime  ="";
  ProgressDialog _progressDialog = new ProgressDialog();
  DateTime startDate;
  DateTime endDate;
  List<String> stringDays = [];
  String calculatedAmount = "";
  String price = "";
  bool showToast = false;
  String value = "0";


  Future<void> _selectFromDate(BuildContext context) async {
    startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2032),
    );
    if (d != null)
      setState(() {
       String Date1 = DateFormat("MM/dd/yyyy").format(startDate);

       if(BookedDate.isNotEmpty){
         for(int i = 0; i<BookedDate.length; i++){
           String date = BookedDate[i];
           if(date == Date1){
             if(value == "0"){
               Fluttertoast.showToast(
                   msg: "Date is not available, Please select another date",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.CENTER,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.blue,
                   textColor: Colors.white,
                   fontSize: 14.0
               );
             }
             fromDate = "";
           }else{
             fromDate = DateFormat("MM/dd/yyyy").format(startDate);
           }
         }
         value = "0";
         getDaysValidation(startDate, endDate);
       }else{
         fromDate = DateFormat("MM/dd/yyyy").format(startDate);
       }

      });
  }

  Future<void> _selectToDate(BuildContext context) async {
    endDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2032),
    );
    if (d != null)
      setState(() {
        // toDate = DateFormat("MM/dd/yyyy").format(endDate);
        String Date2 = DateFormat("MM/dd/yyyy").format(endDate);

         if(startDate.isAfter(endDate)){
        Fluttertoast.showToast(
        msg: "Invalid date selection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 14.0
        );
        toDate ="";
        calculatedAmount = "";
        }else{
           print("checking ");
           bool flag = false;

           if(BookedDate.isNotEmpty){
             for(int i = 0; i<BookedDate.length; i++){
               String date = BookedDate[i];
               if(date == Date2){
                 flag = true;
                 break;
               }else{
                 toDate = DateFormat("MM/dd/yyyy").format(endDate);
               }
             }
             value = "0";
             getDaysValidation(startDate, endDate);
             if (flag == true) {
               Fluttertoast.showToast(
                   msg: "Date is not available, Please select another date",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.CENTER,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.blue,
                   textColor: Colors.white,
                   fontSize: 14.0
               );
             }
           }
           else{

             getDaysValidation(startDate, endDate);

           }
         }

      });
  }


  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff4996f3),
            accentColor: const Color(0xff4996f3),
            colorScheme: ColorScheme.light(primary: const Color(0xff4996f3),
            ),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        Hour = selectedTime.hour.toString();
        minute = selectedTime.minute.toString();
        _time = Hour + ' : ' + minute;
        showStartTime = _time;
        showStartTime = formatDate(
            DateTime(2020, 08, 1, int.parse(Hour), selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();

        if(widget.priceText == "Hour"){
          showEndTime = formatDate(
              DateTime(2020, 08, 1, int.parse(Hour)+int.parse(noOfHour), selectedTime.minute),
              [hh, ':', nn, " ", am]).toString();
        }

      });
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff4996f3),
            accentColor: const Color(0xff4996f3),
            colorScheme: ColorScheme.light(primary: const Color(0xff4996f3),
            ),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        Hour = selectedTime.hour.toString();
        minute = selectedTime.minute.toString();
        _time = Hour + ' : ' + minute;
        showEndTime = _time;
        showEndTime = formatDate(
            DateTime(2020, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();


  DateTime selectedDate = DateTime.now();
  String date = "";
  int monthprev;
  int yearprev;
  String month = "";
  String year = "";
  String monthCount = "";
  List<String> _imagesUrl = [] ;
  List<String> BookedDate = [] ;
  List<String> bookedDateInsideList = [] ;
  var datelist = [];


  CalendarCarousel _calendarCarouselNoHeader;


  static Widget _presentIcon(String day) => Container(
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );



  void getImage()async{
    _imagesUrl.clear();
    for(int i=0; i< widget.names.length; i++){
      print("IMAGES NAME "+widget.names[i]);
      _imagesUrl.add(widget.names[i]);
    }
    setState(() {});
  }


  @override
  void initState() {

    if(widget.priceText == "Hour"){
      price = widget.priceHour;
      int amount = int.parse(price)* int.parse(noOfHour);
      print("AMOUNT TOTAL "+amount.toString());
      calculatedAmount = amount.toString();
    }else if (widget.priceText == "Week"){
      price = widget.priceWeek;
    }else if(widget.priceText == "Day"){
      price = widget.priceDay;
    }
    getImage();
    bookingDateFilterList();
   // CategoryList();
    print(widget.addPostUserId);
    final dateMonthYearFormatter = DateFormat('MM/dd/yyyy');
    final dateFormatter = DateFormat('dd');
    final yearFormatter = DateFormat('yyyy');
    final monthFormatter = DateFormat('MM');
    final monthTextFormatter = DateFormat('MMMM');

    date = dateFormatter.format(selectedDate);
    year = yearFormatter.format(selectedDate);
    month = monthFormatter.format(selectedDate);

    print("date "+date+"year"+year);

    DateTime lastDayOfMonth = new DateTime(int.parse(year), int.parse(month) + 1, 0);
    monthCount = lastDayOfMonth.day.toString();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    for(int i = 0; i<BookedDate.length; i++){
      var date = DateFormat("dd/MM/yyyy").parse(BookedDate[i]);
      var parseMonth = Jiffy(BookedDate[i], "MM/dd/yyyy").format("dd/MM/yyyy");
      print(parseMonth);
      _markedDateMap.add(DateFormat("dd/MM/yyyy").parse(parseMonth),
          new Event(
            date: DateFormat("dd/MM/yyyy").parse(parseMonth),
            title: 'Event 6',
            icon:_presentIcon(DateFormat("dd/MM/yyyy").parse(parseMonth).day.toString(),),
          )
      );
    }

    setState(() {
      _calendarCarouselNoHeader = CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);
        },
        showHeader: true,

        iconColor: Colors.black,

        daysTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 12
        ),

        weekdayTextStyle:TextStyle(
            color: Colors.black,
            fontSize: 12
        ),

        headerTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 12
        ),

        showOnlyCurrentMonthDate: false,
        selectedDayTextStyle: TextStyle(
          color: Colors.black,
        ),
        weekDayFormat: WeekdayFormat.narrow,
        pageScrollPhysics: NeverScrollableScrollPhysics(),
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        selectedDayButtonColor: Colors.white,
        weekendTextStyle: TextStyle(
          color: Colors.black,
        ),
        todayButtonColor: Colors.white,
        todayTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14
        ),

        markedDatesMap: _markedDateMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateMoreShowTotal: null,
        // null for not showing hidden events indicator
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        onCalendarChanged: (DateTime date) {
          this.setState(() {
            final monthFormatter = DateFormat('MM');
            final yearFormatter = DateFormat('yyyy');
            final monthnew = monthFormatter.format(_currentDate);
            final yearnew = yearFormatter.format(_currentDate);
            monthprev = int.parse(monthnew);
            yearprev = int.parse(yearnew);
            DateTime _targetDateTime = DateTime(yearprev, monthprev, 3);
            _targetDateTime = date;
            month = monthFormatter.format(_targetDateTime);
            year = yearFormatter.format(_targetDateTime);

            DateTime lastDayOfMonth = new DateTime(int.parse(year), int.parse(month) + 1, 0);
            monthCount = lastDayOfMonth.day.toString();

          //  print("CALANDER CHNAGED MONTH two:"+monthDisplay);
            Future.delayed(Duration.zero, () async {
              setState(() {
               // calendarData();
              });
            });
            setState(() {});
          });
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Date & Time',style: TextStyle(fontSize: 20,
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
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Container(
                  // height: 460.0,
                  //width: 320,
                  //width: 320,Next
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //custom icon

                      Container(
                        margin: EdgeInsets.only(
                          top: 0.0,
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                        ),
                        child: Column(
                          children: [
                            // new Row(
                            //
                            //   children: [
                            //     Expanded(
                            //
                            //       child:  IconButton(icon:(Icon(Icons.menu,color: Colors.black,))),
                            //       flex: 0,
                            //     ),
                            //     SizedBox(width: 15,),
                            //     Expanded(child: new Row(
                            //       children: <Widget>[
                            //         // Expanded(
                            //         //     child: Text(
                            //         //       _currentMonth,
                            //         //       style: TextStyle(
                            //         //         fontWeight: FontWeight.bold,
                            //         //         fontSize: 24.0,
                            //         //         color: Colors.grey,
                            //         //       ),
                            //         //     )),
                            //
                            //       ],
                            //     ),
                            //       flex: 1,
                            //     ),
                            //     Expanded(
                            //       child: Image.asset('assets/Images/week.png',height: 18,width: 20,),
                            //       flex: 0,
                            //     ),
                            //
                            //
                            //
                            //   ],
                            // ),

                          ],
                        ),

                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.54,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: _calendarCarouselNoHeader,

                      ), //
                    ],
                  ),
                ),

              ),

              widget.priceText == "Hour"
              ? Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Container(
                  height: 110,
                  width: 320,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         Container(
                         //  width:MediaQuery.of(context).size.width,
                           child: Text(
                             "Choose the number of hours",
                             style: TextStyle(
                                 fontSize: 14,
                                 fontFamily: "Montserrat",
                               fontWeight: FontWeight.w500
                             ),textAlign: TextAlign.center,
                           ),
                         ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),

                      Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xff4996f3),width: 2.0,),
                        ),
                        child:  NumberPicker.horizontal(
                          initialValue: hournumber,
                          minValue: 1,
                          maxValue: 23,
                          highlightSelectedValue: true,
                          listViewHeight: 100,
                          selectedTextStyle: TextStyle(color: Colors.black,fontSize: 20.0,
                            fontWeight: FontWeight.w500,),
                          onChanged: (val){
                            setState(() {
                              hournumber = val ;
                              noOfHour = val.toString();
                              print("No fof hours :"+noOfHour);

                              Hour = selectedTime.hour.toString();
                              minute = selectedTime.minute.toString();
                              _time = Hour + ' : ' + minute;
                              showStartTime = _time;
                              showStartTime = formatDate(
                                  DateTime(2020, 08, 1, int.parse(Hour), selectedTime.minute),
                                  [hh, ':', nn, " ", am]).toString();

                              if(widget.priceText == "Hour"){
                                showEndTime = formatDate(
                                    DateTime(2020, 08, 1, int.parse(Hour)+int.parse(noOfHour), selectedTime.minute),
                                    [hh, ':', nn, " ", am]).toString();
                              }

                              //CALCULATED AMOUNT FOR HOUR
                              int amount = int.parse(price)* int.parse(noOfHour);
                              print("AMOUNT TOTAL "+amount.toString());
                              calculatedAmount = amount.toString();

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              :Container(),

              Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Container(
                  height: 55,
                  width: 320,
                  margin: EdgeInsets.only(top:5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                widget.priceText != "Hour"?"From Date":"Date",
                                style: TextStyle(
                                    color: Colors.black,fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),),
                              padding: EdgeInsets.all(15.0),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      _selectFromDate(context);
                                      setState(() {});
                                    },
                                    child:Row(
                                      children: [
                                        Text(fromDate==""? "mm/dd/yyyy":fromDate),
                                        SizedBox(width: 18,),
                                        InkWell(
                                          child: Container(
                                            child:Image.asset('assets/Images/calendar_icon.png',height: 15,width: 15,),
                                          ),
                                          onTap: (){
                                            _selectFromDate(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20,top: 4),
                                    child:Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      height: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ),

              widget.priceText != "Hour"?
              Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Container(
                  height: 55,
                  width: 320,
                  margin: EdgeInsets.only(top:5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              child: Text(
                                widget.priceText != "Hour"?"To Date":"Date",
                                style: TextStyle(
                                    color: Colors.black,fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500),),
                              padding: EdgeInsets.all(15.0),
                            ),
                          ),

                          Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(left: 25),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        if(fromDate == ""){
                                          Fluttertoast.showToast(
                                              msg: "Please select from date",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 14.0
                                          );
                                        }else{
                                          _selectToDate(context);
                                        }

                                        setState(() {});
                                      },
                                      child:Row(
                                        children: [
                                          Text(toDate==""? "mm/dd/yyyy":toDate),
                                          SizedBox(width: 18,),
                                          InkWell(
                                            child: Image.asset('assets/Images/calendar_icon.png',height: 15,width: 15,),
                                            onTap: (){
                                              _selectToDate(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20,top: 4),
                                      child:Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                        height: 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ) :Container(),

              Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                Container(
                  height: 55,
                  width: 320,
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.priceText == "Hour"? "Start Time":"Time",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),),
                              padding: EdgeInsets.all(15.0),
                            ),
                          ),


                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      _selectTime(context);
                                      setState(() {});
                                    },
                                    child:Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Text(showStartTime==""? "0.00 AM":showStartTime),
                                        SizedBox(width: 37,),
                                        InkWell(
                                          child: Image.asset('assets/Images/clock_icon.png',height: 15,width: 15,),
                                          onTap: (){
                                            _selectTime(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20,top: 4),
                                    child:Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      height: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ),

              widget.priceText == "Hour"?
              Card(
                color: Colors.white,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 55,
                  width: 320,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(" End Time",style: TextStyle(color: Colors.black,fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),),
                              padding: EdgeInsets.all(15.0),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                    //  _selectEndTime(context);
                                      setState(() {});
                                    },
                                    child:Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Text(showEndTime==""? "0.00 AM":showEndTime),
                                        SizedBox(width: 37,),
                                        InkWell(
                                          child: Image.asset('assets/Images/clock_icon.png',height: 15,width: 15,),
                                          onTap: (){
                                            _selectEndTime(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20,top: 4),
                                    child:Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      height: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ) :Container(),

              SizedBox(
                height: 10.0,
              ),

             Card(
               color: Colors.white,
               elevation: 10.0,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10.0),
               ),
               child:  Container(
                   width:320,
                 height: MediaQuery.of(context).size.height * 0.06,
                 padding: EdgeInsets.only(left: 15),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                          calculatedAmount == ""?"Amount to be paid : 0\$":"Amount to be paid : "+calculatedAmount+"\$",
                         textAlign: TextAlign.start,
                         style: TextStyle(
                             fontSize: 14,
                             fontFamily: "Montserrat",
                             fontWeight: FontWeight.w500
                         ),
                       ),
                     )
                   ],
                 )
               ),
             ),

              SizedBox(
                height: 30.0,
              ),

              Center(
                child: RaisedButton(
                  elevation: 7.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: (){

                    if(widget.priceText == "Hour"){
                     if(value == "1"){
                        Fluttertoast.showToast(
                            msg: "Date is not available, Please select another date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      } else if(noOfHour == ""){
                        Fluttertoast.showToast(
                            msg: "Please select no of hours",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else if(fromDate == ""){
                        Fluttertoast.showToast(
                            msg: "Please select Date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else if(showStartTime == ""){
                        Fluttertoast.showToast(
                            msg: "Please select start time",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }
                     else if(showEndTime == ""){
                        Fluttertoast.showToast(
                            msg: "Please select end time",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }
                     else{
                     /*   getDaysInBeteween(startDate, startDate);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            BankAccountPage(title: widget.title, description: widget.description,priceText: widget.priceText,documentId: widget.documentId,
                                location: widget.location, priceDay: widget.priceDay, priceHour: widget.priceHour, priceWeek: widget.priceWeek,categoryName:widget.categoryName, names: widget.names,
                                postingDate:widget.postingDate,latitude:widget.latitude, longitude:widget.longitude, latlng:widget.latlng ,addPostUserId:widget.addPostUserId,
                                fromDate:fromDate, toDate:toDate,showStartTime:showStartTime, showEndTime:showEndTime, stringDays:stringDays,
                                stripeAccountLink:widget.stripeAccountLink, noOfHour:noOfHour, calculatedAmount:calculatedAmount,
                                receiverDeviceToken:widget.receiverDeviceToken,documentIdAdd:widget.documentIdAdd,userId:widget.userId, subCategories:widget.subCategories)));
                    */  }
                    }else{
                      if(startDate.isAfter(endDate)){
                        Fluttertoast.showToast(
                            msg: "Invalid date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else if(value == "1"){
                        Fluttertoast.showToast(
                            msg: "Date is not available, Please select another date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      } else if(fromDate == ""){
                        Fluttertoast.showToast(
                            msg: "Please select from Date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else if(toDate == ""){
                        Fluttertoast.showToast(
                            msg: "Please select to date",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else if(showStartTime == ""){
                        Fluttertoast.showToast(
                            msg: "Please select time",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 14.0
                        );
                      }else{
                     /*   getDaysInBeteween(startDate, endDate);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            BankAccountPage(title: widget.title, description: widget.description,priceText: widget.priceText,documentId: widget.documentId,
                                location: widget.location, priceDay: widget.priceDay, priceHour: widget.priceHour, priceWeek: widget.priceWeek,categoryName:widget.categoryName, names: widget.names,
                                postingDate:widget.postingDate,latitude:widget.latitude, longitude:widget.longitude, latlng:widget.latlng ,addPostUserId:widget.addPostUserId,
                                fromDate:fromDate, toDate:toDate,showStartTime:showStartTime, showEndTime:showEndTime, stringDays:stringDays,
                                stripeAccountLink:widget.stripeAccountLink, noOfHour:noOfHour, calculatedAmount: calculatedAmount,
                                deviceToken:widget.deviceToken, documentIdAdd:widget.documentIdAdd)));
                      */}
                    }

                  },
                  padding: EdgeInsets.symmetric(horizontal: 140,vertical: 12),
                  color: Color(0xff4996f3),
                  child: Text('Next',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Montserrat'),),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

/*  void addBooking()async{
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    PostingModel posting = PostingModel();
    posting.title = widget.title;
    if(widget.priceHour != ""){
      posting.priceHour = widget.priceHour;
    }else{
      posting.priceHour = "";
    }

    if(widget.priceDay != ""){
      posting.priceDay = widget.priceDay;
    }else{
      posting.priceDay = "";
    }

    if(widget.priceWeek != ""){
      posting.priceWeek = widget.priceWeek;
    }else{
      posting.priceWeek = "";
    }

    posting.description = widget.description;
    posting.address = widget.location;
    posting.imageNames = _imagesUrl;
    posting.categoryName = widget.categoryName;
    posting.postingDate = widget.postingDate;
    posting.latitude = widget.latitude;
    posting.longitude = widget.longitude;
    posting.latlng = widget.latlng;
    posting.bookingStatus ="Confirmed" ;
    posting.fromDate = fromDate;
    posting.toDate = toDate;
    posting.startTime = showStartTime;
    posting.endTime = showEndTime;
    posting.noOfHour = "";
    posting.dates = stringDays;
    posting.listDates = stringDays;

    String docId = widget.documentId;
    posting.MyBoookingInfoInFirestore(widget.documentId).whenComplete(() {
      posting.MyBoookingAvailableDateInfoInFirestore(docId).whenComplete(() {
        posting.MyOrderInfoInFirestore(widget.addPostUserId).whenComplete(() {
          _progressDialog.dismissProgressDialog(context);
          progressDialog = false;
        });
      });

    });

  }*/


  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    stringDays = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
     DateTime toDate = startDate.add(Duration(days: i));
     String toDatee = DateFormat("MM/dd/yyyy").format(toDate);
     stringDays.add(toDatee);
    //  days.add(startDate.add(Duration(days: i)));
    }
    print("Datys : "+stringDays.toString());
    return days;
  }

//GETTING BOOKING DATES
  Future<void> bookingDateFilterList() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    String docId = widget.documentId;
    Query query = FirebaseFirestore.instance.collection('all_post').doc(docId).collection("booking_dates");
   print(query);
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);
        PostingModel posting = new PostingModel();

        posting.listDates = List.from(document['listDates']);
        print("images list "+posting.listDates.length.toString());

        setState(() {
          // first add the data to the Offset object
          List.from(document['listDates']).forEach((element){
           print(element);
           BookedDate.add(element);
          });

        });

       // BookedDate.add(posting.listDates.toString());
      });

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      print(BookedDate.length.toString());
      setState(() {});
    });
  }


  bool flag = false;
  List<DateTime> getDaysValidation(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime toDate1 = startDate.add(Duration(days: i));
      String toDatee = DateFormat("MM/dd/yyyy").format(toDate1);
      days.add(startDate.add(Duration(days: i)));

      if(BookedDate.isNotEmpty){
        for(int i = 0; i<BookedDate.length; i++){
          String date = BookedDate[i];
          if(date == toDatee){
            if(value == "0"){
              Fluttertoast.showToast(
                  msg: "Date is not available, Please select another date",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 14.0
              );
              value = "1";
            }
            toDate = "";
            dateTimeValidation = true;
            flag = true;
            break;
          }else{
            String daysCount = days.length.toString();
            print("DAYS COUNT : "+daysCount);

            int amount = int.parse(price)* int.parse(daysCount);
            print("AMOUNT TOTAL "+amount.toString());
            calculatedAmount = amount.toString();
            toDate = DateFormat("MM/dd/yyyy").format(endDate);
          }
        }

      }else{
        String daysCount = days.length.toString();
        print("DAYS COUNT : "+daysCount);

        int amount = int.parse(price)* int.parse(daysCount);
        print("AMOUNT TOTAL "+amount.toString());
        calculatedAmount = amount.toString();
        toDate = DateFormat("MM/dd/yyyy").format(endDate);
      }

    }

    print("Datys : "+stringDays.toString());
    return days;
  }


}