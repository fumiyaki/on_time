import 'package:flutter/material.dart';
import '../entity/user.dart';
import 'space_box.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  MyDrawer({this.user});

  @override
  _MyDrawerState createState() => _MyDrawerState(user: this.user);
}

class _MyDrawerState extends State<MyDrawer> {
  User user;

  _MyDrawerState({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
        child: Column(children: [
      SpaceBox.height(50),
      Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: ListTile(
                  title: Text('新しいイベントを設定', style: TextStyle(
                    fontSize: 16
                  )),
                  trailing: IconButton(
                      icon:
                          Icon(Icons.create_rounded, color: Colors.indigo[300]),
                      onPressed: () {
                        if (user.id == null) {
                          /*
                Navigator.pushNamed(
                    context,
                    AuthPage().routeName,
                );

                 */
                        } else {
                          /*
                Navigator.pushNamed(
                    context,
                    DetailEditorPage().routeName,

                    // ユーザー情報を渡す
                    arguments: user
                )
                */
                        }
                      })))),
      SpaceBox.height(50),
      Text('共同編集中のイベント一覧', style: TextStyle(
        color: Colors.grey[900],
        fontSize: 16
      ))
    ])
    );
  }
}
