import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'auth_home_page_widget.dart' show AuthHomePageWidget;
import 'package:flutter/material.dart';

class AuthHomePageModel extends FlutterFlowModel<AuthHomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue1 = FFPlace();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue2 = FFPlace();
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RideVariablesRecord? variables;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PassengerRecord? passenger;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RideRecord? rideDetails;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
