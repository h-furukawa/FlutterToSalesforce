import "package:flutter/material.dart";
import "package:flutter_salesforce/connect/connect.dart";
import "package:flutter_salesforce/User/userInfo.dart";
import "package:flutter_salesforce/settings.dart";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MyApp Build");
    return new MaterialApp(
      title: "Salesforce Connect",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        "/": (_) => new FlutterSalesforce(),
        "/connect": (_) => new Connect(),
        "/user": (_) => new UserInfo(),
      }
    );
  }
}

class FlutterSalesforce extends StatefulWidget {
  @override
  _FlutterSalesforce createState() => new _FlutterSalesforce();
}

class _FlutterSalesforce extends State<FlutterSalesforce> {
  @override
  void initState() {
    SavedSettings.loadData().then((_) {
      print("loadData: ${SavedSettings.accessToken}");
      if (SavedSettings.accessToken != "") {
        Navigator.of(context).pushReplacementNamed("/user");
      }
      else {
        Navigator.of(context).pushReplacementNamed("/connect");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}