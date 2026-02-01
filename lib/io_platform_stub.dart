/// Web gibi dart:io olmayan platformlar için sahte Platform.
class Platform {
  static bool get isIOS => false;
  static bool get isAndroid => false;
}
