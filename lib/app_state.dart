import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _starteRide = prefs.getString('ff_starteRide')?.ref ?? _starteRide;
    });
    _safeInit(() {
      _languageCode = prefs.getString('ff_languageCode') ?? _languageCode;
    });
    _safeInit(() {
      _hasSelectedLanguage =
          prefs.getBool('ff_hasSelectedLanguage') ?? _hasSelectedLanguage;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _routeDistance = '';
  String get routeDistance => _routeDistance;
  set routeDistance(String value) {
    _routeDistance = value;
  }

  String _routeDuration = '';
  String get routeDuration => _routeDuration;
  set routeDuration(String value) {
    _routeDuration = value;
  }

  String _routePrice = '';
  String get routePrice => _routePrice;
  set routePrice(String value) {
    _routePrice = value;
  }

  List<LatLng> _testMarkers = [];
  List<LatLng> get testMarkers => _testMarkers;
  set testMarkers(List<LatLng> value) {
    _testMarkers = value;
  }

  void addToTestMarkers(LatLng value) {
    testMarkers.add(value);
  }

  void removeFromTestMarkers(LatLng value) {
    testMarkers.remove(value);
  }

  void removeAtIndexFromTestMarkers(int index) {
    testMarkers.removeAt(index);
  }

  void updateTestMarkersAtIndex(
    int index,
    LatLng Function(LatLng) updateFn,
  ) {
    testMarkers[index] = updateFn(_testMarkers[index]);
  }

  void insertAtIndexInTestMarkers(int index, LatLng value) {
    testMarkers.insert(index, value);
  }

  DocumentReference? _starteRide;
  DocumentReference? get starteRide => _starteRide;
  set starteRide(DocumentReference? value) {
    _starteRide = value;
    value != null
        ? prefs.setString('ff_starteRide', value.path)
        : prefs.remove('ff_starteRide');
  }

  String _rideTier = 'Basic';
  String get rideTier => _rideTier;
  set rideTier(String value) {
    _rideTier = value;
  }

  String _languageCode = 'en';
  String get languageCode => _languageCode;
  set languageCode(String value) {
    _languageCode = value;
    prefs.setString('ff_languageCode', value);
  }

  bool _hasSelectedLanguage = false;
  bool get hasSelectedLanguage => _hasSelectedLanguage;
  set hasSelectedLanguage(bool value) {
    _hasSelectedLanguage = value;
    prefs.setBool('ff_hasSelectedLanguage', value);
  }

  void setLanguageCode(String code) {
    languageCode = code;
    hasSelectedLanguage = true;
    notifyListeners();
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
