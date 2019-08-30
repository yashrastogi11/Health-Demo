import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(color: Color.fromARGB(255, 243, 172, 19)),
        ),
        backgroundColor: Color.fromARGB(255, 246, 245, 241),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 246, 245, 241),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text("Welcome to the app"),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Hello"),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: Text("There"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
