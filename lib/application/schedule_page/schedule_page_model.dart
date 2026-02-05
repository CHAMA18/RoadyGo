import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'schedule_page_widget.dart' show SchedulePageWidget;
import 'package:flutter/material.dart';

class SchedulePageModel extends FlutterFlowModel<SchedulePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue1 = FFPlace();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue2 = FFPlace();
  DateTime? datePicked;
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
