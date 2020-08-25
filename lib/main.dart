import 'package:flutter/material.dart';
import 'clock.dart';
import 'stopwatch.dart';
import 'alarm.dart';

void main() {
  runApp(MyApp());
}

var _stopWatchPage = new StopWatchPage();
var _alarmCreatePage = new AlarmCreatePage();
const CLOCK_EVENT = "clockEvent";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "StopWatch": (context) => _stopWatchPage,
        "Home": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        "Alarm": (context) => _alarmCreatePage,
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CLockPage _mainpage = CLockPage();
  AlarmCreatePage _alarmCreatePage = AlarmCreatePage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: ExactAssetImage(
            'assets/background.png'),
        fit: BoxFit.cover,
      )),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [

      ],),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: _mainpage),
            Positioned(
              bottom: 50,
              child: Container(
                height: 100,
                width: 300,
                child: NotifyPage(),
              ),
            ),
            Positioned(
                child: FlatButton(
              height: 300,
              minWidth: 300,
              shape: CircleBorder(),
              splashColor: Colors.white10,
              color: Colors.transparent,
              child: Text(""),
              onPressed: () {
                //Navigator.pushNamed(context, "StopWatch");
                _mainpage.change_state();
              },
            )),
          ],
        ),
      ),
      drawer: _mainpage.getDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white70,
        onPressed: () {
          Navigator.pushNamed(context, "Alarm");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),);
  }
}

/* Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [

      ],),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.zcool.cn/community/0372d195ac1cd55a8012062e3b16810.jpg'),
            fit: BoxFit.cover,
          ),
        )),
            Positioned(child: _mainpage),
            Positioned(
              bottom: 50,
              child: Container(
                height: 100,
                width: 300,
                child: NotifyPage(),
              ),
            ),
            Positioned(
                child: FlatButton(
              height: 300,
              minWidth: 300,
              shape: CircleBorder(),
              splashColor: Colors.white10,
              color: Colors.transparent,
              child: Text(""),
              onPressed: () {
                //Navigator.pushNamed(context, "StopWatch");
                _mainpage.change_state();
              },
            )),
          ],
        ),
      ),
      drawer: _mainpage.getDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white70,
        onPressed: () {
          Navigator.pushNamed(context, "Alarm");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }*/
