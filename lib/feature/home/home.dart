import 'package:flutter/material.dart';

class EventCards extends StatelessWidget {
  EventCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EventCard()
    );
  }
}

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('ハッカソン運営大会'),
              subtitle: Text('2021年1月16日土曜日 18:00JST'),
            ),
            Image.network('https://hakuhin.jp/graphic/title.png'),
            const ListTile(
              subtitle: Text('ハッカソンの運営は非常に難しいものであり，時間にルーズでなくてはなりません。なんでな'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('JOIN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
