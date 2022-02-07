import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static  SharedPreferences? sharedPref ;

  // static Future<void> initializeSharedCash() async {
  //   sharedPref = await SharedPreferences.getInstance();
  // }

  static Future<bool> saveDataInCash(
      {required String key, required dynamic value}) async {
    // these methods return a future of bool why ? so they are telling us if the data is saved(true) or not(false) .
    if (value is String) return await sharedPref!.setString(key, value);
    if (value is int) return await sharedPref!.setInt(key, value);
    if (value is bool) return await sharedPref!.setBool(key, value);

    return await sharedPref!.setDouble(key, value);
  }


  static dynamic getSavedData({required String key}) {
  return sharedPref!.get(key);
}



static Future<bool> removeData({required String key})async{
    return await sharedPref!.remove(key);
}

}
