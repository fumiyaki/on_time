import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _key;
  MyAppBar(this._key);

  @override
//  final Size preferredSize = Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Hero(tag: 'tag', child: AppBar(
      leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _key.currentState.openDrawer(),
          color: Colors.grey[800]),
      title: GestureDetector(
        child: SizedBox(height: 30, child: Image.asset('images/LogoAppBar.png')),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      ),
        backgroundColor: Colors.white,
    ));
  }
}
