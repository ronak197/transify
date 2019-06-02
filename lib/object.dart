import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ObjectTranslationPage extends StatefulWidget {
  @override
  _ObjectTranslationPageState createState() => _ObjectTranslationPageState();
}

class _ObjectTranslationPageState extends State<ObjectTranslationPage> {

  List<String> language = ["", "Estonian", "Russian", "Spanish","French", "Hindi", "Gujarati"];
  List<String> languageCode = ["", "et", "ru", "es","fr", "hi", "gu"];

  String transText = "Fetched and Traslated text appears here ";
  String toLanguage = "";

  File _pickedImage;
  bool isImageLoaded = false;

  int imageSaved = 0;       //y
  String savedImagePath;    //y

  TextEditingController txt;
  String lanCode;

  int code = 200;
  final String apiKey = "trnsl.1.1.20190601T145450Z.f4477bc93b0bb429.07f0cf975c4338445c7e6ea904fc21af9308c6f6";
  
  String detectedText;

  String findLanCode(String value){
    int index = 0;
    while(language[index] != value){
      index++;
    }
    return languageCode[index];
  }

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = tempStore;
      isImageLoaded = true;
    });
    setState(() {
      savedImagePath = tempStore.path;    //y

      print(savedImagePath.toString());
    });   //y
    findName();
  }

  Future findName() async{
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_pickedImage);
    ImageLabeler cloudLabeler = FirebaseVision.instance.imageLabeler();
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    List<ImageLabel> cloudLabels = await cloudLabeler.processImage(ourImage);
    List<ImageLabel> labels = await labeler.processImage(ourImage);
    setState(() {
      detectedText = labels[0].text;
      fetchPost(detectedText);
    });
  }

  Future fetchPost(String text) async{
    var out;
    if(toLanguage!=null) {
      out = await http.get(
          '''https://translate.yandex.net/api/v1.5/tr.json/translate?key=$apiKey&text=$text&lang=$lanCode&[format=<text format>]&[options=<translation options>]&[callback=<name of the callback function>]''');
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

  Future saveImage(File a) async{         //y

    final String savingPath = join((await getApplicationDocumentsDirectory()).path,'${imageSaved+1}.png');
    setState(() {
      imageSaved++;
      print('image saved\n');
      print(savingPath);
    });
    final File savedFile = await a.copy(savingPath);
    //y code to add it in collection

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
        elevation: 0.0,
        backgroundColor: Color(0xff3971ea),
        title: Text("Translate Object Name", style: TextStyle(fontFamily: 'fonty', color: Colors.white, fontSize: 30.0),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 60.0,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: isImageLoaded == true ?
                    Container(
                      child: Image(image: FileImage(_pickedImage)),) :
                    Container(
                      child: Icon(Icons.image, size: 50.0,),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
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
                              if(isImageLoaded == true){
                                findName();
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
              detectedText != null ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  child: Container(
                    child: Text(
                      "Detected Text : " + detectedText,
                      style: TextStyle(
                          fontFamily: 'fonty',
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(width: 0.0, height: 0.0,),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  child: Container(
                    child: detectedText != null ?
                    Text(
                      "Translation : " + transText,
                      style: TextStyle(
                          fontFamily: 'fonty',
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100
                      ),
                    ) : Text(
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
              isImageLoaded && (toLanguage!=null)  ?
              RawMaterialButton(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Save", style: TextStyle(color: Color(0xff3971ea)),),
                      Icon(Icons.save_alt, color: Color(0xff3971ea),)
                    ],
                  ),
                ),
                onPressed: () {
                  saveImage(_pickedImage);
                },
              ) : SizedBox(width: 0.0, height: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
