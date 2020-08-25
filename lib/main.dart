import 'package:flutter/material.dart';
import 'clock.dart';
import 'stopwatch.dart';
import 'alarm.dart';

void main() {
  runApp(MyApp());
}

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
        "StopWatch": (context) => StopWatchPage(),
        "Home": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        "Alarm": (context) => AlarmCreatePage(),
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
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: new AssetImage("assets/background.png")),
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
                Navigator.pushNamed(context, "StopWatch");
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
  }
}
