import 'package:flutter/material.dart';
import 'package:transify/profile.dart';
import 'package:transify/walkthrough.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:transify/menu.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Profile.walkthroughLoaded == false ? Welcome() : MenuPage(),
));

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xff3791EA),
//            image: DecorationImage(image: AssetImage("assets/backg.png"))
          ),
          child: Stack(
            children: <Widget>[
              PageView(
                children: <Widget>[
                  Walkthrougth(textContent: "Instantly translates words and phrases", imageName: "text.png",index: 0),
                  Walkthrougth(textContent: "Caputre text from the camera and translate it", imageName: "camera.png", index: 1,),
                  Walkthrougth(textContent: "Find the language spoken in a region from the photo captured of a monument", imageName: "monument.png", index: 2,),
                  Walkthrougth(textContent: "Translate the name of the object captured from camera", imageName: "object.png",index: 3,),
                ],
                onPageChanged: (value) {
                  setState(() {
                    currentIndexPage = value;
                  });
                },
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.9,
                // left: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.41),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DotsIndicator(
                      dotsCount: pageLength,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                        activeColor: Color(0xff0058B0),
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
