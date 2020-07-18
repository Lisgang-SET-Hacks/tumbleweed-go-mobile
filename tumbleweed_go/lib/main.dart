import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'util.dart';

void main() => runApp(TumbleweedGo());

class TumbleweedGo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tumbleweed Go',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Tumbleweed GO'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ApiAccessor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: RaisedButton(
            onPressed: () {
              _pushCamera();
            },
            child: Text('Upload Tumbleweed'),
          ),
        );
      }),
    );
  }

  void _pushCamera() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return CameraScreen();
    }));
  }
}
