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
  List<Record> alarms;
  List<Record> get_notify(int num) {
    alarms.sort(Record.compare);
    if (num < alarms.length)
      return alarms.sublist(alarms.length - num, alarms.length - 1);
  }
}

Alarm alarm;

class NotifyPage extends StatefulWidget {
  NotifyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var c = alarm.get_notify(2);
    return ListView(
      children: [
        c.length >= 1 ? Container() : Text("record"),
      ],
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
