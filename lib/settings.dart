import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ConstSettings {
  static final String CLIENT_ID = "enter client id";
  static final String REDIRECT_URL = "enter redirect url";
}

class SavedSettings {
  static String accessToken;
  static String refreshToken;
  static String instanceUrl;
  static String userId;

  static Future<void> loadData() {
      return SharedPreferences.getInstance().then((prefs) {
      accessToken = prefs.getString("accessToken") ?? "";
      refreshToken = prefs.getString("refreshToken") ?? "";
      instanceUrl = prefs.getString("instanceUrl") ?? "";
      userId = prefs.getString("userId") ?? "";
    });
  }

  static Future<void> saveData() {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setString("accessToken", accessToken);
      prefs.setString("refreshToken", refreshToken);
      prefs.setString("instanceUrl", instanceUrl);
      prefs.setString("userId", userId);
    });
  }
}