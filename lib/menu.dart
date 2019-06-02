import 'package:flutter/material.dart';
import 'package:transify/cameraText.dart';
import 'package:transify/object.dart';
import 'package:transify/landmark.dart';
import 'package:transify/selectLanguage.dart';
import 'package:transify/library.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> menus = [
    'Translate Text',
    'Object Translation',
    'From photo of landmark'
  ];

  List<Image> bg = [
    //update the assets list
    Image.asset(
      'assets/text_bg.png',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/object_bg.png',
      fit: BoxFit.fill,
    ),
    Image.asset(
      'assets/monument_bg.png',
      fit: BoxFit.fill,
    )
  ];

  Color _fontColor = Color(0xffeae3f2);
  Color _menuBg = Colors.white;

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Change your language',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectLanguage()));
                      },
                    ),
                    FlatButton(
                        child: Text(
                          'View collection',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LibraryPage()));
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
          child: Text(
            "Transify",
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'fonty'),
          ),
        ),
        titleSpacing: 0.0,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            onPressed: _optionsDialogBox,
            child: Icon(
              Icons.menu,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: _menuBg,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraText()));
                      } else if (index == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ObjectTranslationPage()));
                      } else if (index == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandmarkSearch()));
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: SizedBox(height: 150.0, child: bg[index])),
                        Positioned(
                          top: 10.0,
                          left: 10.0,
                          child: Text(
                            menus[index],
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: _fontColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
