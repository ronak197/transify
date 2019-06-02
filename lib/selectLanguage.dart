import 'package:flutter/material.dart';
import 'package:transify/profile.dart';
import 'package:transify/menu.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {

  List<String> languages = ["Afrikaans","Albanian","Amharic","Arabic","Armenian","Azerbaijani","Basque","Belarusian","Bengali","Bosnian","Bulgarian","Burmese","Catalan","Cebuano","Chichewa","Chinese","Corsican","Croatian","Czech","Danish","Dutch","English","Esperanto","Estonian","Filipino","Finnish","French","Frisian","Galician","Georgian","German","Greek","Gujarati","Haitian Creole","Hausa","Hawaiian","Hebrew","Hindi","Hmong","Hungarian","Icelandic","Igbo","Indonesian","Irish","Italian","Japanese","Javanese","Kannada","Kazakh","Khmer","Korean","Kurdish (Kurmanji)","Kyrgyz","Lao","Latin","Latvian","Lithuanian","Luxembourgish","Macedonian","Malagasy","Malay","Malayalam","Maltese","Maori","Marathi","Mongolian","Nepali","Norwegian (Bokmål)","Pashto","Persian","Polish","Portuguese","Punjabi","Romanian","Russian","Samoan","Scots Gaelic","Serbian","Sesotho","Shona","Sindhi","Sinhala","Slovak","Slovenian","Somali","Spanish","Sundanese","Swahili","Swedish","Tajik","Tamil","Telugu","Thai","Turkish","Ukrainian","Urdu","Uzbek","Vietnamese","Welsh","Xhosa","Yiddish","Yoruba","Zulu"];
  int numberOfLanguages = 103;

  Future<void> _confirmDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Center(
                    child: Text("You have selected ${Profile.language}"),
                  )
                ],
              ),
            ),
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 30.0, bottom: 20.0),
                child: Text("Select Language", style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w800),),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 50.0,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 103,
                  itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: (){
                        Profile.language = languages[index];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
                        _confirmDialogBox();
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
                            child: Text( languages[index],
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xff031473)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}