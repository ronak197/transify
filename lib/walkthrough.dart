import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:transify/selectLanguage.dart';
import 'package:transify/profile.dart';
class Walkthrougth extends StatelessWidget {

  final String textContent;
  final String imageName;
  int index;

  Walkthrougth({Key key, @required this.textContent, @required this.imageName, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.asset("assets/$imageName"),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,top: 100.0),
              child: Text(
                textContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0,
                  letterSpacing: 1.3
                ),
              ),
            ),
          ),
          index == 3 ? Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: RawMaterialButton(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Text("Select Language", style: TextStyle(color: Color(0xff0058B0)),),
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLanguage()),);
                Profile.walkthroughLoaded = true;
                },
              ),
            ),
          ) : SizedBox(),
        ],
      )
    );
  }
}