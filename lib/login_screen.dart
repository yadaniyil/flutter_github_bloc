import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Github Bloc')),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Login',
                  border: OutlineInputBorder(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(24.0))),
                )),
            SizedBox(height: 24.0),
            TextFormField(
              obscureText: true,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(24.0))),
                )),
            SizedBox(height: 36.0),
            RaisedButton(
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text('Login',
                    style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
                color: Colors.blueGrey,
                onPressed: () {})
          ],
        ),
      ), // ,
    );
  }
}
