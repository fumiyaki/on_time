import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class detailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 253, 1),
      appBar: AppBar(
        title: const Text('ここの部分は他のところからいただきます'),
      ),
      body: timeline(),
    );
  }
}

class timeline extends StatefulWidget {
  @override
  _timelineState createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  final now = DateTime.now();
  bool _value = false;
  DateTime date = DateTime(2020, 7, 25, 10, 30);
  List<String> litems = ["11:00", "26", "プレゼン一組目", "6", "プレゼン一組目"];
  List<int> lis = [70, 10, 6];

  void _handleCheckbox(bool e) {
    setState(() {
      _value = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
        //  contentsBuilder: (_, __) => _EmptyContents(),
        theme: TimelineThemeData(
          nodePosition: 0.2,
          connectorTheme: ConnectorThemeData(
            thickness: 8.0,
            indent: 0,
            color: Color(0xffd3d3d3),
          ),
          indicatorTheme: IndicatorThemeData(
            size: 0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          oppositeContentsBuilder: (context, index) {
            if (index == 1) {
              return null;
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                        child: Container(
                            child: (index == 0)
                                ? Text(DateFormat('HH:mm').format(date))
                                : Text(DateFormat('HH:mm').format(date.add(
                                    Duration(
                                        minutes: lis
                                            .take(index)
                                            .toList()
                                            .reduce((a, b) => a + b))))))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child:
                          Checkbox(value: _value, onChanged: _handleCheckbox),
                    ),
                  ],
                ),
              );
            }
          },
          contentsBuilder: (context, index) {
            if (index == 1) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    Row(
                      children: [
                        Text(litems[3],
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        Text("分",
                            style: TextStyle(
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ],
                ),
              );
            }
            if (index < 1) {
              return Timeline_Right(litems, Color.fromRGBO(112, 112, 112, .53));
            } else {
              return Timeline_Right(litems, Color.fromRGBO(112, 112, 112, 1));
            }
          },
          connectorBuilder: (context, index, _) => SolidLineConnector(),
          indicatorBuilder: (context, index) {
            print(index);
            if (index == 1) {
              return TimelineNode(
                indicator: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 268, 0),
                        child: Container(
                            child: (index == 0)
                                ? Text(DateFormat('HH:mm').format(date))
                                : Text(DateFormat('HH:mm').format(date.add(
                                    Duration(
                                        minutes: lis
                                            .take(index)
                                            .toList()
                                            .reduce((a, b) => a + b))))))),
                    Container(
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          side: BorderSide(
                            color: Color.fromRGBO(109, 113, 249, 1),
                            width: 4.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Checkbox(
                                  value: _value, onChanged: _handleCheckbox),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 16, 4),
                              child: Text('プレゼン一組目',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                        boxShadow: [
                          new BoxShadow(
                            color: Color.fromRGBO(109, 113, 249, .4),
                            spreadRadius: 0,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                startConnector: SolidLineConnector(),
                endConnector: SolidLineConnector(),
              );
            } else {
              return TimelineNode(
                indicator: TimelineNode.simple(),
                startConnector: SolidLineConnector(),
                endConnector: SolidLineConnector(),
              );
            }
          },
          itemCount: 4,
        ));
  }
}

class Timeline_Right extends StatelessWidget {
  var litems;
  final Color fontcolor;
  Timeline_Right(this.litems, this.fontcolor);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.litems[2],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: fontcolor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 32, 0),
              child: Row(
                children: [
                  Text(litems[3],
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Text("分",
                      style: TextStyle(
                        fontSize: 10,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Timeline_Now extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
