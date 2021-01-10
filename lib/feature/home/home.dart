import 'package:flutter/material.dart';

/*
/// This is the stateless widget that the main application instantiates.
class EventCards extends StatelessWidget {
  EventCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 */

class EventCards extends StatelessWidget {
  EventCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EventCard()
    );
  }
}

/// Event Card
class EventCard extends StatelessWidget {
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
