import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class OKDialogBox extends StatelessWidget {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final String title, description;
  final Image image;
  final BuildContext my_context;
  BuildContext dialog_context;

  OKDialogBox({
    @required this.title,
    @required this.description,
    this.image,
    @required this.my_context,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    this.dialog_context = context;
    return
      Container(
          width: double.infinity,
          child: new Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20, top: 30),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: new Text(
                          title,
                          style: TextStyle(
                            color: Color((0xff44536a)),
                            fontSize: 20,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topCenter,
                        child: new Text(
                          description,
                          style: TextStyle(
                              color: Color((0xff44536a)), fontSize: 15),
                          textAlign: TextAlign.center,
                        ),

                      ),

                      SizedBox(height: 0),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 100,
                        margin: const EdgeInsets.only(top: 00),
                        child:RaisedButton(
                          color: Color((0xff1274BA)),
                          child: Text(
                            "OK".toUpperCase(),
                            style: TextStyle(
                              color: Color((0xffffffff)),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          onPressed:(){
                            Navigator.of(dialog_context).pop();
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
  }
}
