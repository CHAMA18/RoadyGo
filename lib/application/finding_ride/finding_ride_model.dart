import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'finding_ride_widget.dart' show FindingRideWidget;
import 'package:flutter/material.dart';

class FindingRideModel extends FlutterFlowModel<FindingRideWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in FindingRide widget.
  RideRecord? ride;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  RideRecord? ridedetailsold;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RideVariablesRecord? float;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  DriverRecord? dri;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
