import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const key = 'a17d10bd349e432d99228b4331ed7628';

//实况天气  https://devapi.heweather.net/v7/weather/now?{请求参数}
const baseurl = "https://devapi.heweather.net/v7/weather/now?";

class WeatherPage extends StatefulWidget {
  @override
  WeatherPageState pstate = WeatherPageState();
  WeatherPageState createState() => pstate;
}

class WeatherPageState extends State<WeatherPage> {
  //data
  bool WebRequest = true;
  WeatherData weather = WeatherData.empty();
  String cityname = '';
  String cityid = '';
  List<String> _chinacitys = [
    "北京市 101010100",
    "重庆市 101040100",
    "上海市 101020100",
    "天津市 101030100",
    "香港特别行政区 101320101",
    "澳门特别行政区 101330101",
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

  _getWeather() async{
    WeatherData data = await _fetchWeather();
    setState((){
      weather = data;
    });
  }

  Future<WeatherData>_fetchWeather() async {
    final response = await http.get(
      // 'https://devapi.heweather.net/v7/weather/now?location=${cityid}&key=${key}');
        '${baseurl}location=${cityid}&key=${key}');
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      return new WeatherData();
    };
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        endDrawer: Drawer(
          child: buildCityList(),
        ),
        body: new Column(
            children: <Widget>[
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 100.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      cityname,
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.white, fontSize: 30.0,),
                    ),
                    new Text(
                        weather?.tmp,
                        style: new TextStyle(color: Colors.white, fontSize: 30.0)
                    ),
                    new Text(
                        weather?.cond,
                        style: new TextStyle(color: Colors.white, fontSize: 30.0)
                    ),
                    new Text(
                      weather?.hum,
                      style: new TextStyle(color: Colors.white, fontSize: 30.0),
                    ),

                  ],
                ),
              ),
            ]
        )
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

class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cond: json['now']['text'],
      tmp: json['now']['temp']+"°",
      hum: "湿度  "+json['now']['humidity']+"%",
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