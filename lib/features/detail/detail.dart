import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import "../../common/app_bar.dart";

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
  GlobalKey<ScaffoldState> _key;
  @override
  Widget build(BuildContext context) {
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
                        //   onPressed: () => _key.currentState.openDrawer(),
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
                                child: Text("-",
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
                        // onPressed: () => _key.currentState.openDrawer(),
                        color: Colors.grey[800]),
                  ],
                )),
            body: _DeliveryProcesses(
                processes: data.deliveryProcesses,
                doing: data.complete,
                startingdate: data.startdate,
                nowtime: data.date)));
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
          indicatorBuilder: (_, index) => !isEdgeIndex(index)
              ? ContainerIndicator(
                  child: Container(
                    child: Checkbox(
                      activeColor: Colors.blue,
                      value: messages[index - 1].checkbox,
                      //    onChanged: messages[index - 1].checkbox?messages[index - 1].checkbox = false;messages[index - 1].checkbox =true,
                    ),
                  ),
                )
              : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }
            int sumtime = 0;
            if (index > 1) {
              sumtime = sumtime + messages[index - 2].contenttime;
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
    return DefaultTextStyle(
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
    );
  }
}
