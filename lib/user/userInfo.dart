import 'package:flutter/material.dart';
import "package:flutter_salesforce/api/api.dart";
import "package:flutter_salesforce/settings.dart";

class UserInfo extends StatefulWidget {
  @override
  _UserInfo createState() => new _UserInfo();
}

class _UserInfo extends State<UserInfo> {
  User user;

  void setUserInfo(User user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  void initState() {
    UserAPI.getUser().then((user) {
      setUserInfo(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("UserInfo"),
        actions: _buildAppBarActionButton(),
      ),
      body: new Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget> [
           new Text("UserName: ${this.user != null ? this.user.userName : ""}"),
           new Text("Name: ${this.user != null ? this.user.lastName : ""} ${this.user != null ? this.user.firstName : ""}"),
         ]
      )
    );
  }

  List<Widget> _buildAppBarActionButton() {
    return <Widget>[
      MaterialButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              content: new Text("ログアウトしますか？"),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  }),
                new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, "ok");
                  })
              ],
            ),
          ).then((value) {
            // ボタンタップ時の処理
            switch (value) {
              case "cancel":
                break;
              case "ok":
                SavedSettings.accessToken = "";
                SavedSettings.refreshToken = "";
                SavedSettings.instanceUrl = "";
                SavedSettings.userId = "";
                SavedSettings.saveData();
                Navigator.of(context).pushReplacementNamed("/");
                break;
              default:
            }
          });
        },
        child: Text(
          "ログアウト",
          style: TextStyle(
              fontSize: 14.0,
              color: Colors.white
          ),
        ),
      )
    ];
  }
}