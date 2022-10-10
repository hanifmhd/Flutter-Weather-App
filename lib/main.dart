import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/GetLocation.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey = '9fa3b94ceead0f42ad805323f52bcbf5';
  var city;
  var position;
  var description;
  var temp;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Column(
          children: [
            Container(
              child: displayImage(),
            ),
            // SizedBox(height: 50.0,),
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Text(
                'You are in: ',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      city == null ? 'Fetching location...' : city,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[500]),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                ),
                title:
                    Text('Temperature: ${temp == null ? '...' : '$temp °C'}'),
                subtitle: Text(
                    'Status: ${description == null ? '...' : description}'),
              ),
            ),
            Container(
              child: Center(
                child: ElevatedButton(
                  child: Text('Get weather info'),
                  onPressed: () {
                    getTemp(position['latitude'], position['longitude']);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //display images based on current time
  displayImage() {
    var now = DateTime.now();
    final currentTime = DateFormat.jm().format(now);
    if (currentTime.contains('AM')) {
      return Image.asset('images/dayTime.jpg');
    } else if (currentTime.contains('PM')) {
      return Image.asset('images/nightTime.jpg');
    }
  }

  //get location
  void getCurrentLocation() async {
    GetLocation getLocation = GetLocation();
    await getLocation.getCurrentLocation();
    setState(() {
      city = getLocation.city;
      position = {
        'latitude': getLocation.latitude,
        'longitude': getLocation.longitude,
      };
    });
  }

  //get current temp
  Future<void> getTemp(double lat, double lon) async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    var dataDecoded = jsonDecode(response.body);
    print(dataDecoded);
    setState(() {
      description = dataDecoded['weather'][0]['description'];
      temp = dataDecoded['main']['temp'];
    });
  }
}
