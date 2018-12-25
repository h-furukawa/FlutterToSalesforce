import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:crypto/crypto.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:async';
import "package:flutter_salesforce/settings.dart";
import "package:flutter_salesforce/util.dart";

class Connect extends StatefulWidget {
  @override
  _Connect createState() => new _Connect();
}

class _Connect extends State<Connect> {
  String verifierCode = "";
  String challengeCode = "";

  @override
  Widget initState() {
    // URL変化を検知する
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    print("isExecute init");
    bool isExecute = false;
    flutterWebviewPlugin.onUrlChanged.listen((url) {
      if (url.startsWith(ConstSettings.REDIRECT_URL) && isExecute == false) {
        print("isExecute false: ${isExecute}");
        isExecute = true;
        print("isExecute true: ${isExecute}");
        flutterWebviewPlugin.close();
        Uri uri = Uri.parse(url);
        String code = uri.queryParameters["code"];
        getToken(code).then((_) => Navigator.of(context).pushReplacementNamed("/"));
      }
    });

    // verifierCodeを生成
    this.verifierCode = Util.base64UrlEncode(Util.randomString(32));

    // challengeCodeを生成（16進数化せずに数字をそのままBase64変換する）
    this.challengeCode = Util.base64UrlEncode(new String.fromCharCodes(sha256.convert(this.verifierCode.codeUnits).bytes));
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        title: Text("Salesforce Connect"),
      ),
      url: "https://login.salesforce.com/services/oauth2/authorize" +
           "?response_type=code" +
           "&client_id=${ConstSettings.CLIENT_ID}" +
           "&redirect_uri=${ConstSettings.REDIRECT_URL}" +
           "&display=touch" +
           "&code_challenge=${this.challengeCode}"
    );
  }

  /// トークンの取得
  Future<void> getToken(String code) {
    print("getToken");
    String url = "https://login.salesforce.com/services/oauth2/token";
    return http.post(url,
      body: {
        "grant_type": "authorization_code",
        "client_id": ConstSettings.CLIENT_ID,
        "redirect_uri": ConstSettings.REDIRECT_URL,
        "code": code,
        "code_verifier": this.verifierCode,
      }
    ).then((response) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      SavedSettings.accessToken = responseMap["access_token"];
      SavedSettings.refreshToken = responseMap["refresh_token"];
      SavedSettings.instanceUrl = responseMap["instance_url"];
      SavedSettings.userId = responseMap["id"].toString().split("/").last;
      print("accessToken: ${SavedSettings.accessToken}");
      SavedSettings.saveData();
    });
  }
}