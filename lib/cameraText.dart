import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraText extends StatefulWidget {
  @override
  _CameraTextState createState() => _CameraTextState();
}

class _CameraTextState extends State<CameraText> {

  File _pickedImage;
  bool isImageLoaded = false;
  String transText = "Fetched and Traslated text appears here ";
  String toLanguage = "";
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> language = ["", "Estonian", "Russian", "Spanish","French", "Hindi", "Gujarati"];
  List<String> languageCode = ["", "et", "ru", "es","fr", "hi", "gu"];

  TextEditingController txt;
  int code = 200;

  final String apiKey = "trnsl.1.1.20190601T145450Z.f4477bc93b0bb429.07f0cf975c4338445c7e6ea904fc21af9308c6f6";
  String lanCode;

  String findLanCode(String value){
    int index = 0;
    while(language[index] != value){
      index++;
    }
    return languageCode[index];
  }

  Future fetchPost() async{
    var out;
    if(toLanguage!=null) {
      out = await http.get(
          '''https://translate.yandex.net/api/v1.5/tr.json/translate?key=$apiKey&text=${txt.text.toString()}&lang=$lanCode&[format=<text format>]&[options=<translation options>]&[callback=<name of the callback function>]''');
    }
    code = int.parse(out.body.toString().substring(8,11));
    setState(() {
      print(code);
      if(code == 502 || code == 413){
        transText = "Opps !! Something went wrong";
      }
      else transText = out.body.toString().substring(36).replaceAll("\"]}", "");
    });
  }

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = tempStore;
      isImageLoaded = true;
    });
    readText();
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    txt.text = "";

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            txt.text += word.text.toString() + " ";
          });
        }
      }
    }

  }

  @override
  void initState() {
    txt = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.camera_enhance, color: Colors.white,),
        onPressed: pickImage,
      ),
      backgroundColor: Color(0xff3971ea),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff3971ea),
        title: Text("Translate Text", style: TextStyle(fontFamily: 'fonty', color: Colors.white, fontSize: 30.0),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 60.0,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: CupertinoTextField(
                      controller: txt,
                      placeholder: "Enter text to be translated",
                      clearButtonMode: OverlayVisibilityMode.editing,
                      textAlign: TextAlign.justify,
                      maxLines: 8,
                      style: TextStyle(fontFamily: 'fonty', color: Colors.white, fontSize: 20.0, ),
                      padding: EdgeInsets.all(10.0),
                      onChanged: (changedText) {
                        setState(() {
                          transText = changedText;
                          if(transText != null){
                            fetchPost();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                width: MediaQuery.of(context).size.width * 0.53,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.white),
                child: FormField(
                  builder: (FormFieldState state){
                    return InputDecorator(
                      decoration: InputDecoration.collapsed(
                        hintText: "Select",
                      ),
                      isEmpty: toLanguage == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: toLanguage,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              toLanguage = newValue;
                              lanCode = findLanCode(newValue);
                              if(txt.text != null){
                                fetchPost();
                              }
                            });
                          },
                          items: language.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  child: Container(
                    child: Text(
                      transText,
                      style: TextStyle(
                          fontFamily: 'fonty',
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
