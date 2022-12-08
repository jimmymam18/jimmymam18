import 'package:bizitme/Models/Bizitme.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';
import 'package:bizitme/Screens/UploadPhotosPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LinkStripeAccount extends StatefulWidget {
  @override
  _LinkStripeAccountState createState() => _LinkStripeAccountState();
}

class _LinkStripeAccountState extends State<LinkStripeAccount> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  int offerID;
  String TestURl;
  String str_stripid="";
  String strUserId="";
  ProgressDialog _progressDialog = ProgressDialog();
  BuildContext dialog_context;

  @override
  void initState() {
   TestURl ="https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_JA41Fjqnk2IpmHzh7IwvKJx7vNZdVC5h&scope=read_write";// live
    // TestURl ="https://dashboard.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_JA413ftExUQKSdDIpFK0bsiRmpHyYK2N&scope=read_write";// Test
    super.initState();
  }

  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();

  @override
  Widget build(BuildContext context) {
    dialog_context=context;
    return WillPopScope(
      onWillPop: () {
        print('Backbutton pressed (device or appbar button), do whatever you want.');
        //trigger leaving and use own data
        flutterWebViewPlugin. hide() ;
        Navigator.of(context).pop();
       /* showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context1) => Dialog(
              elevation: 10.0,
              backgroundColor: Colors.white,
              child: dialogContent_doyouwanttoexit(context),
            ));*/

        return Future.value(false);
      },
      child: new Scaffold(
          appBar:  AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Color((0xff44536a))),
              onPressed: () {
                flutterWebViewPlugin. hide();
                Navigator.of(context).pop();
               // flutterWebViewPlugin.hide();
               /* showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context1) => Dialog(
                      elevation: 10.0,
                      backgroundColor: Colors.white,
                      child: dialogContent_doyouwanttoexit(context),
                    ));*/
              },
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Bizitme',
              style: TextStyle(
                fontSize: 15,
                color: Color((0xff44536a)),
                fontFamily: 'LatoBold',
              ),
            ),
          ),
          body:WebviewScaffold(
            url: TestURl,
            clearCache: true,
            appCacheEnabled: true,
            javascriptChannels: [
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    print(message.message);
                    if (equalsIgnoreCase("F", message.message)) {

                      Fluttertoast.showToast(
                          msg: "Registration Failure",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.pop(context);
                    } else {
                      str_stripid=message.message;
                      print("STRIPE ID :: "+str_stripid);
                      Bizitme.saveSharedPrefValueString(AppConstants.StripeAccountLink, str_stripid);
                      Navigator.of(context).pop();
                      //REDIRECT PAGE AFTER SUCCESSFULLY REGISTRATION
                    //  store_stripeid();
                    }
                  }),
            ].toSet(),
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: const Center(
                child: Text('Loading...'),
              ),
            ),

          )
      ),
    );
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }


  void store_stripeid() {
   // store_stripeid_api();
  }


  dialogContent_doyouwanttoexit(BuildContext context) {
    dialog_context = context;
    return Container(
        width: double.infinity,
        child: new Container(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 0, top: 10),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/warning.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: new Text(
                          "Do you want to cancel registration?",
                          style: TextStyle(
                            fontFamily: 'LatoBold',
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15,bottom: 10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new RaisedButton(
                            onPressed: _cancel,
                            textColor: Colors.white,
                            splashColor: Colors.black,
                            color: Colors.red,
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(
                              "No",
                            ),
                          ),
                          new RaisedButton(
                            onPressed:(){
                              setState(() {
                                Navigator.of(dialog_context).pop();
                               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadPhotosPage()));
                              });
                            },
                            textColor: Colors.white,
                            splashColor: Colors.black,
                            color: Colors.green,
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(
                              "Yes",
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

        ));
  }


  void _cancel() {
    Navigator.of(context).pop();
    flutterWebViewPlugin. show() ;
  }


  void CANCEL_POPUP_() {
    Navigator.of(context).pop();
  // Navigator.push(context,MaterialPageRoute(builder: (context)=>UploadPhotosPage()));
    // Navigator.pushReplacement(context, FadeRoute(page: ServiceProviderDashboard()));


  }

}

