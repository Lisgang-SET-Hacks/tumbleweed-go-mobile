import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tumbleweed Go',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Tumbleweed GO'),
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
  final api = ApiAccessor();

  Future<Position> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: RaisedButton(
            onPressed: () {
              _getCurrentLocation().then((location) {
                print('${location.latitude}  ${location.longitude}');
                api.postTumbleweed(location.latitude, location.longitude).then(
                    (result) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                }).catchError((error) => Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString()))));
              });
            },
            child: Text('Upload Tumbleweed'),
          ),
        );
      }),
    );
  }
}

class ApiAccessor {
  final baseUrl = 'https://tumbleweed-go-backend.herokuapp.com/';

  Future<Map<String, dynamic>> getTumbleweeds() async {
    var response = await http.get(baseUrl + 'tumbleweed/get');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return Future.error('Error ${response.statusCode}');
    }
  }

  Future<String> postTumbleweed(double lat, long) async {
    var response = await http.post(baseUrl + 'tumbleweed/upload/$lat/$long');

    if (response.statusCode == 200) {
      return 'Successfully uploaded tumbleweed';
    } else {
      return Future.error('Error ${response.statusCode}');
    }
  }
}
