import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

const kTileHeight = 64.0;

class _OrderInfo {
  const _OrderInfo({
    @required this.date,
    @required this.startdate,
    @required this.complete,
    @required this.deliveryProcesses,
  });
  final DateTime date;
  final DateTime startdate;
  final int complete;
  final List<_DeliveryProcess> deliveryProcesses;
}

//　親要素
class _DeliveryProcess {
  const _DeliveryProcess(
      this.name,
      this.time, {
        this.messages = const [],
      });

  final String name;
  final int time;
  final List<_DeliveryMessage> messages;
}

//子要素
class _DeliveryMessage {
  const _DeliveryMessage(this.contenttime, this.message);

  final int contenttime; // final DateTime createdAt;
  final String message;
}

_OrderInfo _data(int id) => _OrderInfo(
  date: DateTime.now(),
  startdate: DateTime(2020, 7, 25, 10, 30),
  complete: 1,
  deliveryProcesses: [
    //あえて1足しておく
    _DeliveryProcess(
      '発表会', 60,
      messages: [
        _DeliveryMessage(6, 'Event A Team'),
        _DeliveryMessage(12, 'Event B Team'),
        _DeliveryMessage(25, 'Event C Team'),
      ],
    ),
/*    _DeliveryProcess(
      '休憩',
      60,
      messages: [
        _DeliveryMessage(32, 'Event D Team'),
        _DeliveryMessage(16, 'Event E Team'),
      ],
    ),
    _DeliveryProcess(
      '休憩',
      60,
      messages: [
        _DeliveryMessage(32, 'Event D Team'),
        _DeliveryMessage(16, 'Event E Team'),
      ],
    ),*/
  ],
);

class EditPage extends StatelessWidget {
  final data = _data(1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ここの部分は他のところからいただきます'),
      ),
      body: new Container(
        child: SingleChildScrollView(
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
                    ),
                  ),
                  Container(padding: EdgeInsets.only(top:20,bottom:0),
                    child: Row(
                        children:<Widget>[
                          //SpaceBox.width(30),
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:5),
                    child: Row(
                        children:<Widget>[
                          //SpaceBox.width(30),
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:20,bottom:0),
                    child:Row(
                        children:<Widget>[
                          //SpaceBox.width(30),
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:5),
                    child: Row(
                        children:<Widget>[
                          //SpaceBox.width(30),
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
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    child: Row(
                        children:<Widget>[
                            new Text(
                              "イベント開始",
                              style: new TextStyle(fontSize:18.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"),
                            ),
                            FlatButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 1, 1),
                                      maxTime: DateTime(2025, 12, 31), onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                      }, currentTime: DateTime.now(), locale: LocaleType.jp);
                                },
                                child: Text(
                                  'show date time picker',
                                  style: TextStyle(color: Colors.blue),
                                )),
                        ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.only(top:5),
                    child: _DeliveryProcesses(
                        processes: data.deliveryProcesses,
                        doing: data.complete,
                        startingdate: data.startdate,
                        nowtime: data.date),

                  ),
                  Container(
                    child: RaisedButton(
                      child: const Text(
                          'Scheduleを追加',
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      color: Colors.white,
                      shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ]
            ),
        ),
      ),
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    @required this.messages,
    @required this.startingdate,
    @required this.nowtime,
  });

  final List<_DeliveryMessage> messages;
  final DateTime startingdate;
  final DateTime nowtime;
  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 1.0,
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,
          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
          !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }
            int sumtime = 0;
            sumtime = sumtime + messages[index - 1].contenttime;
            // ;

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Text(
                            DateFormat('HH:mm').format(
                                startingdate.add(Duration(minutes: sumtime))),
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                      Text(messages[index - 1].message),
                    ],
                  ),
                  Row(
                    children: [
                      Text(messages[index - 1].contenttime.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      Text("分",
                          style: TextStyle(
                            fontSize: 10,
                          ))
                    ],
                  )
                ],
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
          isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses(
      {Key key,
        @required this.processes,
        @required this.doing,
        @required this.startingdate,
        @required this.nowtime})
      : assert(processes != null),
        super(key: key);
  final List<_DeliveryProcess> processes;
  final int doing;
  final DateTime startingdate;
  final DateTime nowtime;

  @override
  Widget build(BuildContext context) {
    DateTime startingdateCh = startingdate;
    //return DefaultTextStyle(
    return Center(
      child: Card(
        child: DefaultTextStyle(
          style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                color: Color(0xff989898),
                indicatorTheme: IndicatorThemeData(
                  position: 0,
                  size: 20.0,
                ),
                connectorTheme: ConnectorThemeData(
                  thickness: 2.5,
                ),
              ),
                  builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.before,
                itemCount: processes.length,
                contentsBuilder: (_, index) {
                  int bigsumtime = 0;
                  bigsumtime = bigsumtime + processes[index].time;
                  print(bigsumtime);
                  startingdateCh =
                      startingdateCh.add(Duration(minutes: bigsumtime));
                  //display feature of times
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Text(
                                  DateFormat('HH:mm').format(startingdateCh),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  )),
                                ),
                                Text(
                              processes[index].name,
                              style:
                              DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                            Row(
                              children: [
                                Text(processes[index].time.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                )),
                                Text("分",
                                style: TextStyle(
                                  fontSize: 10,
                                )),
                              ],
                            ),
                          ],
                        ),
                        _InnerTimeline(
                        messages: processes[index].messages,
                        startingdate: startingdateCh,
                        nowtime: nowtime),
                        RaisedButton(
                          child: const Text(
                            'Taskを追加',
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                          color: Colors.white,
                          shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    ),
                  );
                  },
                  ),
            ),
          ),
        ),
      ),
    );
  }
}