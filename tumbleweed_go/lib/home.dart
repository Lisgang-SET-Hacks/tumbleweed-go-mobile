import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'util.dart';

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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Upload Tumbleweed',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: Icon(Icons.camera),
            ),
            ListTile(
              title: Text(
                'About Tumbleweed GO',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: Icon(Icons.info),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: RaisedButton(
                color: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onPressed: () {
                  _pushCamera();
                },
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Upload Tumbleweed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Rowdies',
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _pushCamera() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CameraScreen()));
  }
}
