import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import "theme.dart" as theme;

class StopWatchPage extends StatefulWidget {
  StopWatchPage({Key key, this.title}) : super(key: key) {}
  final String title;
  @override
  StopWatchPageState createState() => StopWatchPageState();
}

class StopWatchPageState extends State<StopWatchPage> {
  Stopwatch _stopwatch = new Stopwatch();
  Timer _timer;
  var _iconOfStart = Icons.play_arrow;
  int _h;
  int _s;
  int _m;
  List<String> _records = [];
  String _time = '00:00:00';
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(milliseconds: 10), _setTime);
  }

  _setTime(Timer timer) {
    if (mounted) {
      setState(() {
        _h = (_stopwatch.elapsedMilliseconds / 10).truncate();
        _s = (_h / 100).truncate();
        _m = (_s / 60).truncate();

        String hStr = (_h % 100).toString().padLeft(2, '0');
        String sStr = (_s % 60).toString().padLeft(2, '0');
        String mStr = (_m % 60).toString().padLeft(2, '0');
        _time = '$mStr:$sStr:$hStr';
      });
    }
  }

//665 777 833
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment(0,-0.8),
        children: [
          Image(image: new AssetImage("assets/background.png")),
          Positioned(
              child: Container(
            height: 100,
            width: 300,
            child: ListView.separated(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _records[index],
                    style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(height: 0.1,color: Colors.blue,endIndent: 1,),
              controller: _controller,
            ),
          )),
          Positioned(
            bottom: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: BackdropFilter(
                //图片模糊过滤，横向竖向都设置5.0
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                //透明控件
                child: Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 200,
                    height: 60,
                    //盒子装饰器，进行装饰，设置颜色为灰色
                    decoration: BoxDecoration(
                      gradient: theme.Theme.primaryGradient,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 150,
              child: FlatButton(
                child: Text(""),
                shape: CircleBorder(),
                height: 300,
                minWidth: 300,
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          Positioned(
              top: 260,
              child: Container(
                child: Text(_time,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 50,
                        decoration: TextDecoration.none)),
              )),
          Positioned(
              bottom: 105,
              child: FlatButton(
                shape: CircleBorder(),
                height: 50,
                minWidth: 50,
                child: Icon(
                  _iconOfStart,
                  color: Colors.white70,
                ),
                onPressed: () {
                  if (_iconOfStart == Icons.stop) {
                    _iconOfStart = Icons.play_arrow;
                    _stopwatch.stop();
                  } else {
                    _iconOfStart = Icons.stop;
                    _stopwatch.start();
                  }
                },
              )),
          Positioned(
            bottom: 105,
            left: 80,
            child: FlatButton(
              shape: CircleBorder(),
              height: 50,
              minWidth: 50,
              child: Icon(
                Icons.replay,
                color: Colors.white70,
              ),
              onPressed: () {
                _stopwatch.reset();
                _records.clear();
              },
            ),
          ),
          Positioned(
            bottom: 105,
            right: 80,
            child: FlatButton(
              shape: CircleBorder(),
              height: 50,
              minWidth: 50,
              child: Icon(
                Icons.more_time,
                color: Colors.white70,
              ),
              onPressed: () {
                String id = (_records.length + 1).toString();
                _records.add("第$id条记录\t\t$_time");
                _controller.animateTo(_controller.position.maxScrollExtent,
                    duration: Duration(seconds: 1), curve: Curves.bounceIn);
              },
            ),
          )
        ],
      ),
    );
  }
}
