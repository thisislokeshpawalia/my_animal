import 'package:shared_preferences/shared_preferences.dart';


class BiometricPreferenceService {


  static const String key =
      "biometric_enabled";



  Future<bool> isEnabled() async {

    final prefs =
    await SharedPreferences.getInstance();


    return prefs.getBool(key) ?? false;

  }



  Future<void> setEnabled(bool value) async {

    final prefs =
    await SharedPreferences.getInstance();


    await prefs.setBool(
      key,
      value,
    );

  }

}