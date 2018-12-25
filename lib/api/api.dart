import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import "package:flutter_salesforce/settings.dart";

class User {
  String lastName;
  String firstName;
  String id;
  String userName;
}

class UserAPI {
  static Future<User> getUser() {
    String url = "${SavedSettings.instanceUrl}/services/data/v40.0/query/?q=SELECT Id, UserName, LastName, FirstName FROM User WHERE Id = '${SavedSettings.userId}'";
    return http.get(url,
      headers: {
        "Authorization": "Bearer ${SavedSettings.accessToken}"
      }
    ).then((response) {
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      List<dynamic> recordList = responseMap["records"];
      Map<String, dynamic> recordMap = recordList[0];
      User user = new User();
      user.id = recordMap["Id"];
      user.lastName = recordMap["LastName"];
      user.firstName = recordMap["FirstName"];
      user.userName = recordMap["Username"];
      return user;
    });
  }

  static Future<void> getAccessToken() {
    String url = "https://login.salesforce.com/services/oauth2/token";
    return http.post(url,
        body: {
          "grant_type": "refresh_token",
          "client_id": ConstSettings.CLIENT_ID,
          "refresh_token": SavedSettings.refreshToken,
        }
    ).then((response) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      SavedSettings.accessToken = responseMap["access_token"];
      SavedSettings.refreshToken = responseMap["refresh_token"];
      SavedSettings.instanceUrl = responseMap["instance_url"];
      SavedSettings.userId = responseMap["id"];
      SavedSettings.saveData();
    });
  }
}