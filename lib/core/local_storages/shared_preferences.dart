import 'package:shared_preferences/shared_preferences.dart';

enum DataType { string, bool, int, stringList }

class SharedPrefs {
  static late SharedPreferences sharedPreferences;

  static Future<void> setData({
    required String key,
    required var data,
    required DataType type,
  }) async {
    if (data == null) {
      sharedPreferences.remove(key);
      return;
    }
    switch (type) {
      case DataType.string:
        await sharedPreferences.setString(key, data);
        break;
      case DataType.bool:
        await sharedPreferences.setBool(key, data);
        break;
      case DataType.int:
        await sharedPreferences.setInt(key, data);
        break;
      case DataType.stringList:
        await sharedPreferences.setStringList(key, data);
        break;
    }
  }

  static getData({
    required String key,
    required DataType type,
  }) {
    switch (type) {
      case DataType.string:
        return sharedPreferences.getString(key);
      case DataType.bool:
        return sharedPreferences.getBool(key);
      case DataType.int:
        return sharedPreferences.getInt(key);
      case DataType.stringList:
        return sharedPreferences.getStringList(key);
    }
  }
}
