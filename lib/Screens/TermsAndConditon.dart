import 'package:bizitme/helper/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TermsAndConditon extends StatefulWidget {
  @override
  _TermsAndConditonState createState() => _TermsAndConditonState();
}

class _TermsAndConditonState extends State<TermsAndConditon> {

  String url = "";


  @override
  void initState(){
    super.initState();
    // url = "http://13.59.162.217:8000/terms_and_condition/";

    url = API.terms_and_condition;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      body: WillPopScope(
          onWillPop: (){
            Navigator.pop(context);
          },
          child: new MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              "/": (_) => new WebviewScaffold(
                url: url,
                withJavascript: true,
                hidden: true,
                appBar:PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
                  child: new AppBar(
                    centerTitle :true,
                    title: new Text(
                      'Terms of service',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 2.6 *
                            MediaQuery.of(context)
                                .size
                                .height *
                            0.01,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Color(0xff4996f3),
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            },
          )
      ),
    );
  }
}
