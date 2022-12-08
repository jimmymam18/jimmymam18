import 'package:bizitme/helper/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CancellationPolicy extends StatefulWidget {
  @override
  _CancellationPolicyState createState() => _CancellationPolicyState();
}

class _CancellationPolicyState extends State<CancellationPolicy> {
  String url = "";


  @override
  void initState(){
    super.initState();
    // url = "http://13.59.162.217:8000/cancellation_refund_policy/";
    url = API.cancellation_refund_policy;
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
                      'Cancellation Policy',
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
