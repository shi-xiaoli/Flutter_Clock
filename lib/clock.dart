import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:flare_dart/math/mat2d.dart';

const key = 'a17d10bd349e432d99228b4331ed7628';
const PI = 3.1415926;

//实况天气  https://devapi.heweather.net/v7/weather/now?{请求参数}
const baseurl = "https://devapi.heweather.net/v7/weather/now?";

class CLockPage extends StatefulWidget {
  CLockPage({Key key, this.title}) : super(key: key) {}
  _ClockPageState _state;
  final String title;
  @override
  _ClockPageState createState() {
    print("create");
    return _state = _ClockPageState();
  }

  void changeState() {
    _state.state == 0 ? _state.state = 1 : _state.state = 0;
  }
  // _update(Timer _timer) {
  //   //_pState.setTime();
  // }

  Widget getDrawer() => _ClockPageState().buildCityList();
}

class _ClockPageState extends State<CLockPage> with FlareController {
  Timer timer;
  int state = 0;
  String _time = "00:00";
  String _date = "0000-00-00";
  String _weekday = "";
  bool WebRequest = false;
  String errorinfo = "";
  WeatherData weather = WeatherData.empty();
  String cityname = '北京';
  String cityid = '101010100';
  ActorNode _hour_ptr;
  ActorNode _min_ptr;
  ActorNode _sec_ptr;
  List<String> _chinacitys = [
    "北京市 101010100",
    "重庆市 101040100",
    "上海市 101020100",
    "天津市 101030100",
    "香港 101320101",
    "澳门 101330101",
    "哈尔滨市 101050101",
    "阿城市 101050104",
    "双城市 101050102",
    "尚志市 101050111",
    "五常市 101050112",
    "齐齐哈尔市 101050201",
    "讷河市 101050202",
    "鸡西市 101051101",
    "虎林市 101051102",
    "密山市 101051103"
  ];

  @override
  void initialize(FlutterActorArtboard artboard) {
    _hour_ptr = artboard.getNode("hour");
    _min_ptr = artboard.getNode("minute");
    _sec_ptr = artboard.getNode("seconds");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _sec_ptr.rotation = DateTime.now().second / 60.0 * 2 * PI;
    _min_ptr.rotation = DateTime.now().minute / 60.0 * 2 * PI;
    _hour_ptr.rotation = DateTime.now().hour / 24.0 * 4 * PI;
    return true;
  }

  _getWeather() async {
    WeatherData data = await _fetchWeather();
    setState(() {
      print(1);
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async {
    final response = await http.get(
        // 'https://devapi.heweather.net/v7/weather/now?location=${cityid}&key=${key}');
        '${baseurl}location=${cityid}&key=${key}');
    if (response.statusCode == 200) {
      setState(() {
        print(2);
        WebRequest = true;
      });
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      //print(response.statusCode);
      setState(() {
        print(3);
        errorinfo = "获取天气信息失败";
        WebRequest = false;
      });
      return new WeatherData();
    }
    ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    print("dispose");
  }

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(Duration(milliseconds: 10), _setTime);
  }

  _setTime(Timer timer) {
    setState(() {
      int h = DateTime.now().hour.truncate();
      int m = DateTime.now().minute.truncate();
      _date = DateTime.now().toString().split(" ")[0];
      String twd = DateTime.now().weekday.toString();
      if (twd == '1')
        _weekday = "周一";
      else if (twd == '2')
        _weekday = "周二";
      else if (twd == '3')
        _weekday = "周三";
      else if (twd == '4')
        _weekday = "周四";
      else if (twd == '5')
        _weekday = "周五";
      else if (twd == '6')
        _weekday = "周六";
      else if (twd == '7') _weekday = "周日";
      String hStr = (h % 100).toString().padLeft(2, '0');
      String mStr = (m % 60).toString().padLeft(2, '0');
      _time = '$hStr:$mStr ';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state == 0)
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            bottom: 300,
            child: Column(children: [
              Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(cityname,
                        style: TextStyle(color: Colors.white70, fontSize: 20)),
                    Text(_time,
                        style: TextStyle(color: Colors.white70, fontSize: 65)),
                  ]),
                  SizedBox(
                    width: 1,
                    height: 90,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  Container(
                    child: _chooseweatherinfo(),
                  ),
                ],
              ),
            ])),
        Positioned(
          bottom: 270,
          child: Text("${_date} ${_weekday}",
              style: TextStyle(color: Colors.white70, fontSize: 20)),
        ),
      ]);
    else
      return FlareActor("assets/simulationClock.flr",
            alignment: Alignment.center, fit: BoxFit.contain, controller: this);
  }

  Widget _chooseweatherinfo() {
    if (WebRequest) {
      return Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            child: _chooseicon(),
          ),
          Text(weather.cond,
              style: TextStyle(color: Colors.white70, fontSize: 20)),
        ]),
        Text(weather.tmp,
            style: TextStyle(color: Colors.white70, fontSize: 20)),
        Text(weather.win,
            style: TextStyle(color: Colors.white70, fontSize: 15)),
      ]);
    } else {
      return Column(children: <Widget>[
        Text("暂无天气信息", style: TextStyle(color: Colors.white70, fontSize: 15))
      ]);
    }
  }

  Widget _chooseicon() {
    if (weather.cond == "晴") {
      if ((DateTime.now().hour.truncate()) % 100 > 5 &&
          (DateTime.now().hour.truncate()) % 100 < 20)
        return Icon(
          WeatherIcons.wiDaySunny,
          color: Colors.red,
        );
      else
        return Icon(
          WeatherIcons.wiMoonAltFull,
          color: Colors.green,
        );
    } else if (weather.cond == "阴")
      return Icon(
        WeatherIcons.wiCloud,
        color: Colors.green,
      );
    else if (weather.cond == "多云")
      return Icon(
        WeatherIcons.wiCloudy,
        color: Colors.green,
      );
    else if (weather.cond == "雨" ||
        weather.cond == "小雨" ||
        weather.cond == "大雨")
      return Icon(
        WeatherIcons.wiDayRain,
        color: Colors.green,
      );
    else if (weather.cond == "雪" || weather.cond == "大雪")
      return Icon(
        WeatherIcons.wiDaySnow,
        color: Colors.green,
      );
    else
      return Icon(
        WeatherIcons.wiDaySnow,
        color: Colors.green,
      );
  }

  Widget buildCityList() {
    return new ListView.builder(
      itemCount: _chinacitys.length,
      itemBuilder: (context, i) {
        return _buildRow(_chinacitys[i].split(" ")[0], i);
      },
    );
  }

  Widget _buildRow(String city, int i) {
    return new ListTile(
      title: new Text(
        city,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      onTap: () {
        cityname = _chinacitys[i].split(" ")[0];
        cityid = _chinacitys[i].split(" ")[1];
        _getWeather();
      },
    );
  }
}

class WeatherData {
  String cond; //天气
  String tmp; //温度
  String hum; //湿度
  String win;

  WeatherData({this.cond, this.tmp, this.hum, this.win});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cond: json['now']['text'],
      tmp: json['now']['temp'] + "°",
      hum: "湿度  " + json['now']['humidity'] + "%",
      win:
          "   " + json['now']['windDir'] + " " + json['now']['windScale'] + "级",
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }
}
