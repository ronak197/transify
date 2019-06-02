import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _numberOfItems = 30;
  Image img = Image.asset(
    'assets/text.png',
    fit: BoxFit.fill,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Center(
              child: Text(
                "My Collection",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'fonty'),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
            itemCount: _numberOfItems,
            itemBuilder: (BuildContext context, int index) {
              return LibCard(
                image: img,
                inputText: 'Hello!',
                outputText: 'Konnichiwa!',
              ); // to be updated
            }),
      ),
    );
  }
}

class LibCard extends StatefulWidget {
  @required
  final Image image;
  @required
  final String inputText;
  @required
  final String outputText;

  LibCard({Key key, this.image, this.inputText, this.outputText})
      : super(key: key);

  @override
  _LibCardState createState() => _LibCardState();
}

class _LibCardState extends State<LibCard> {
  double cardHeight = 100.0;
  TextStyle txtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400);

  Widget insertLabel(String a) {
    return SizedBox(
      height: cardHeight / 2,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            a,
            style: txtStyle,
          ),
        ),
      ),
    );
  }

  void deleteCard() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Yet to be implemented!'),
      duration: Duration(seconds: 2),
    ));
  } //need to be implemented

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            showCard();
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                child: widget.image,
                height: cardHeight,
                width: cardHeight,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    insertLabel(widget.inputText),
                    insertLabel(widget.outputText)
                  ],
                ),
              ),
              SizedBox(
                width: 60.0,
                height: 100.0,
                child: FlatButton(
                    splashColor: Colors.red,
                    onPressed: deleteCard,
                    child: Center(
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  Future<void> showCard() {
    double desSize = 12.0;
    double mainSize = 18.0;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: AlertDialog(
              content: new SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: widget.image,
                        height: 200.0,
                        width: 200.0,
                      ),
                      Divider(),
                      Text(
                        'In your default language:',
                        style: TextStyle(fontSize: desSize),
                      ),
                      Text(
                        widget.inputText,
                        style: TextStyle(
                          fontSize: mainSize,
                          fontFamily: 'fonty',
                        ),
                      ),
                      Divider(),
                      Text(
                        'And the translation:',
                        style: TextStyle(fontSize: desSize),
                      ),
                      Text(
                        widget.outputText,
                        style:
                            TextStyle(fontSize: mainSize, fontFamily: 'fonty'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
