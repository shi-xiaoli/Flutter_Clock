import 'package:flutter/material.dart';

class Record {
  int _hour;
  int _minute;
  static int compare(Record a, Record b) {
    if (a._hour < b._hour) return -1;
    if (a._hour > b._hour) return 1;
    if (a._minute < b._minute) return -1;
    if (a._minute > b._minute) return 1;
    return 0;
  }
}

class Alarm {
  List<Record> alarms = [];
  List<Record> get_notify(int num) {
    if (alarms.isEmpty) return alarms;
    alarms.sort(Record.compare);
    if (num < alarms.length)
      return alarms.sublist(alarms.length - num, alarms.length - 1);
    return alarms;
  }
}

class NotifyPage extends StatefulWidget {
  NotifyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  Alarm _alarm;
  @override
  void initState() {
    _alarm = Alarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var c = _alarm.get_notify(2);
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        if (c.length > index)
          return ListTile(
            title: Text(
              c[c.length - index].toString(),
              style: TextStyle(color: Colors.white70),
            ),
          );
        else
          return Text(
            "empty",
            style: TextStyle(color: Colors.white70),
          );
      },
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0
            ? Divider(
                color: Colors.blue,
              )
            : Divider(
                color: Colors.green,
              );
      },
      itemCount: 2,
    );
  }
}

class ShowRow extends StatefulWidget {
  ShowRow({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ShowRowState createState() => _ShowRowState();
}

class _ShowRowState extends State<ShowRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AlarmCreatePage extends StatefulWidget {
  AlarmCreatePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AlarmCreatePageState createState() => _AlarmCreatePageState();
}

class _AlarmCreatePageState extends State<AlarmCreatePage> {
  Alarm _alarm;
  @override
  void initState() {
    _alarm = Alarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (contex) {
            return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "新建闹钟",
          style: TextStyle(color: Colors.black),
        ),
        actions: [FlatButton(onPressed: () {}, child: Icon(Icons.done))],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              left: 100,
              child: Container(
                height: 200,
                width: 50,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          "$index",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.white,
                      );
                    },
                    itemCount: 24),
              )),
          Positioned(
              right: 100,
              child: Container(
                height: 200,
                width: 50,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      int min = index - 1;
                      return ListTile(
                        title: Text(
                          (index > 1 && index < 61) ? "$min" : "",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.white,
                      );
                    },
                    itemCount: 62),
              ))
        ,Positioned(child: Container(
          child: ListView(children: [
            
          ],),
        ))
        ],
      ),
    );
  }
}
