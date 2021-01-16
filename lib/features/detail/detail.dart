import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import "../../common/drawer.dart";
import "../../common/app_bar.dart";

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

//こ要素
class _DeliveryMessage {
  const _DeliveryMessage(this.contenttime, this.message, this.checkbox);

  final int contenttime; // final DateTime createdAt;
  final String message;
  final bool checkbox;
}

_OrderInfo _data(int id) => _OrderInfo(
      date: DateTime.now(),
      startdate: DateTime(2020, 7, 25, 10, 30),
      complete: 1,
      deliveryProcesses: [
        //あえて1足しておく
        _DeliveryProcess(
          '発表会',
          60,
          messages: [
            _DeliveryMessage(6, 'Event A Team', false),
            _DeliveryMessage(12, 'Event B Team', false),
            _DeliveryMessage(25, 'Event C Team', false),
          ],
        ),
        _DeliveryProcess(
          '休憩',
          60,
          messages: [
            _DeliveryMessage(32, 'Event D Team', false),
            _DeliveryMessage(16, 'Event E Team', false),
            _DeliveryMessage(16, 'Event E Team', false),
            _DeliveryMessage(16, 'Event E Team', false),
          ],
        ),
        _DeliveryProcess(
          '休憩',
          60,
          messages: [
            _DeliveryMessage(32, 'Event D Team', false),
            _DeliveryMessage(16, 'Event E Team', false),
          ],
        ),
      ],
    );

class detailPage extends StatelessWidget {
  final data = _data(1);
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _loggedIn = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: MyAppBar(_key),
        body: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.brush_sharp),
                      onPressed: () => Navigator.pushNamed(context, '/edit'),
                        color: Colors.grey[800]),
                        Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 2),
                        child: Column(
                        children: [
                        Text("Firebaseハッカソン",
                        style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        )),
                        Row(
                        children: [
                        Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 2, 2),
                        child:
                         Text("-",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: Text("32",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: Text("h",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: Text("21",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: Text("m",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.share),
                      //    onPressed: () => Navigator.pop(context, "SearchBarDemoApp"),
                      color: Colors.grey[800]),
                ],
              )),
          body: _DeliveryProcesses(
              processes: data.deliveryProcesses,
              doing: data.complete,
              startingdate: data.startdate,
              nowtime: data.date),

          /// ログイン時のみチャットボタン表示
          floatingActionButton: _loggedIn ?
          FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: new Icon(Icons.chat)) :
          Container(),

          /// ドロワー
          drawerEdgeDragWidth: 0,
          drawer: SizedBox(
              width: 0.8 * screenWidth, child: MyDrawer(login: _loggedIn)),
          key: _key,
        ));
  }
}

class _InnerTimeline extends StatefulWidget {
  const _InnerTimeline({
    @required this.messages,
    @required this.startingdate,
    @required this.nowtime,
  });

  final List<_DeliveryMessage> messages;
  final DateTime startingdate;
  final DateTime nowtime;
  @override
  __InnerTimelineState createState() => __InnerTimelineState();
}

class __InnerTimelineState extends State<_InnerTimeline> {
  List<bool> check_box = List.filled(10, false);

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == widget.messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 3.0,
                space: 8.0,
                indent: 0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) => !isEdgeIndex(index)
              ? ContainerIndicator(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                    child: Container(
                      child: new Checkbox(
                          activeColor: Colors.blue,
                          value: check_box[index],
                          onChanged: (bool value) => setState(() {
                                print(check_box[index]);
                                check_box[index] = value;
                                print(check_box[index]);
                              })),
                    ),
                  ),
                )
              : null,
          startConnectorBuilder: (_, index) => SizedBox(
            height: 40.0,
            width: 16.0,
            child: SolidLineConnector(),
          ),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }
            int sumtime = 0;
            if (index > 1) {
              sumtime = sumtime + widget.messages[index - 2].contenttime;
            }
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
                            DateFormat('HH:mm').format(widget.startingdate
                                .add(Duration(minutes: sumtime))),
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                      Text(widget.messages[index - 1].message),
                    ],
                  ),
                  Row(
                    children: [
                      Text(widget.messages[index - 1].contenttime.toString(),
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
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 56.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: widget.messages.length + 2,
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
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: SingleChildScrollView(
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
                return Padding(
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
                                  ))
                            ],
                          )
                        ],
                      ),
                      _InnerTimeline(
                          messages: processes[index].messages,
                          startingdate: startingdateCh,
                          nowtime: nowtime),
                    ],
                  ),
                );
              },
              indicatorBuilder: (_, index) {
                if (doing >= index) {
                  print(index);
                  return DotIndicator(
                    color: Color(0xff66c97f),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  );
                } else {
                  return OutlinedDotIndicator(
                    borderWidth: 2.5,
                  );
                }
              },
              connectorBuilder: (_, index, ___) => SolidLineConnector(
                color: doing >= index ? Color(0xff66c97f) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
