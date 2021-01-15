import 'package:flutter/material.dart';
import 'package:ontime/feature/edit/screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ontime/entity/event.dart';
import 'package:ontime/common/space_box.dart';



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
    padding: EdgeInsets.all(25.0),
        child:Column(
            children: <Widget>[
              Container(


                  child: Row(
                    children:<Widget>[
                      Center(
                        child:
                        new Text(
                        "Firebaseハッカソン",
                        style: new TextStyle(fontSize:30.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),

                    ),

                  ]
    ),),





          Container(padding: EdgeInsets.only(top:20,bottom:0),
              child: Row(

                  children:<Widget>[
                    SpaceBox.width(30),
                    Center(
                      child:
                      new Text(
                        "一般公開用URL",

                        style: new TextStyle(fontSize:18.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),

                    ),

                  ]
              ),),



            Container(
              padding: EdgeInsets.only(top:5),
              child: Row(
                  children:<Widget>[
                    SpaceBox.width(30),
                    Column(

                        children:<Widget>[




                          Text(
                            "aaaaaaaaaaaaaaaaaaaaaaaaaaa",
                            style: new TextStyle(fontSize:18.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w200,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                fontFamily: "Roboto"),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                    ),

                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,
                      onPressed: () {},
                    ),


    ]

              ),),




          Container(
              padding: EdgeInsets.only(top:20,bottom:0),
              child:Row(
                  children:<Widget>[
                    SpaceBox.width(30),


                      new Text(
                        "共同編集用URL",

                        style: new TextStyle(fontSize:18.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                      new Text(
                        "(ontimeチャットで共有禁止)",

                        style: new TextStyle(fontSize:14.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ),


                  ]
              ),),
            Container(
              padding: EdgeInsets.only(top:5),
              child: Row(
                  children:<Widget>[
                    SpaceBox.width(30),

                    Column(

                    children:<Widget>[




                    Text(
                      "aaaaaaaaaaaaaaaaaaaaaaaaaaa",
                      style: new TextStyle(fontSize:18.0,
                          color: const Color(0xFF000000),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),

                    ]
                    ),

                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,

                      onPressed: () {},
                    ),
                  ]
    ),),



      ]
      )),
    );
  }
}