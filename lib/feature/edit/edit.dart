import 'package:flutter/material.dart';
import 'package:ontime/feature/edit/screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(

      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(26, 25, 60, 1.0),
          ),
        ),
      ),

      home: MyHomePage(),

    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ontime'),
      ),
      body:

      new Container(
        child:Column(
            children: <Widget>[
              Row(
                  children:<Widget>[
                    Center(
                      child:
                      new Text(
                        "ハッカソン",
                        style: new TextStyle(fontSize:22.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                      ),

                    ),

                  ]
    ),
              Row(


              ),





              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
               Center(
                child:
                new Text(
                  "イベント開始",
                  style: new TextStyle(fontSize:22.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),

              ),
              Padding(
                padding: EdgeInsets.only(left:24.0),
                child: Text(
                  "JST",
                  style: new TextStyle(fontSize:22.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),
              )
                ]

              )
        ]
              ),




        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,


      ),
    );
  }
}