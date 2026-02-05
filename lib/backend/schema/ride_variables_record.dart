import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideVariablesRecord extends FirestoreRecord {
  RideVariablesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "CostOfRide" field.
  double? _costOfRide;
  double get costOfRide => _costOfRide ?? 0.0;
  bool hasCostOfRide() => _costOfRide != null;

  // "CostPerDistance" field.
  double? _costPerDistance;
  double get costPerDistance => _costPerDistance ?? 0.0;
  bool hasCostPerDistance() => _costPerDistance != null;

  // "CostPerMinute" field.
  double? _costPerMinute;
  double get costPerMinute => _costPerMinute ?? 0.0;
  bool hasCostPerMinute() => _costPerMinute != null;

  // "CorporateCostOfRide" field.
  double? _corporateCostOfRide;
  double get corporateCostOfRide => _corporateCostOfRide ?? 0.0;
  bool hasCorporateCostOfRide() => _corporateCostOfRide != null;

  // "CorporateCostPerDistance" field.
  double? _corporateCostPerDistance;
  double get corporateCostPerDistance => _corporateCostPerDistance ?? 0.0;
  bool hasCorporateCostPerDistance() => _corporateCostPerDistance != null;

  // "CorporateCostPerMinute" field.
  double? _corporateCostPerMinute;
  double get corporateCostPerMinute => _corporateCostPerMinute ?? 0.0;
  bool hasCorporateCostPerMinute() => _corporateCostPerMinute != null;

  // "FloatBasic" field.
  double? _floatBasic;
  double get floatBasic => _floatBasic ?? 0.0;
  bool hasFloatBasic() => _floatBasic != null;

  // "FloatCooprate" field.
  double? _floatCooprate;
  double get floatCooprate => _floatCooprate ?? 0.0;
  bool hasFloatCooprate() => _floatCooprate != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  void _initializeFields() {
    _costOfRide = castToType<double>(snapshotData['CostOfRide']);
    _costPerDistance = castToType<double>(snapshotData['CostPerDistance']);
    _costPerMinute = castToType<double>(snapshotData['CostPerMinute']);
    _corporateCostOfRide =
        castToType<double>(snapshotData['CorporateCostOfRide']);
    _corporateCostPerDistance =
        castToType<double>(snapshotData['CorporateCostPerDistance']);
    _corporateCostPerMinute =
        castToType<double>(snapshotData['CorporateCostPerMinute']);
    _floatBasic = castToType<double>(snapshotData['FloatBasic']);
    _floatCooprate = castToType<double>(snapshotData['FloatCooprate']);
    _region = snapshotData['region'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('RideVariables');

  static Stream<RideVariablesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideVariablesRecord.fromSnapshot(s));

  static Future<RideVariablesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideVariablesRecord.fromSnapshot(s));

  static RideVariablesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RideVariablesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideVariablesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideVariablesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideVariablesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideVariablesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideVariablesRecordData({
  double? costOfRide,
  double? costPerDistance,
  double? costPerMinute,
  double? corporateCostOfRide,
  double? corporateCostPerDistance,
  double? corporateCostPerMinute,
  double? floatBasic,
  double? floatCooprate,
  String? region,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'CostOfRide': costOfRide,
      'CostPerDistance': costPerDistance,
      'CostPerMinute': costPerMinute,
      'CorporateCostOfRide': corporateCostOfRide,
      'CorporateCostPerDistance': corporateCostPerDistance,
      'CorporateCostPerMinute': corporateCostPerMinute,
      'FloatBasic': floatBasic,
      'FloatCooprate': floatCooprate,
      'region': region,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideVariablesRecordDocumentEquality
    implements Equality<RideVariablesRecord> {
  const RideVariablesRecordDocumentEquality();

  @override
  bool equals(RideVariablesRecord? e1, RideVariablesRecord? e2) {
    return e1?.costOfRide == e2?.costOfRide &&
        e1?.costPerDistance == e2?.costPerDistance &&
        e1?.costPerMinute == e2?.costPerMinute &&
        e1?.corporateCostOfRide == e2?.corporateCostOfRide &&
        e1?.corporateCostPerDistance == e2?.corporateCostPerDistance &&
        e1?.corporateCostPerMinute == e2?.corporateCostPerMinute &&
        e1?.floatBasic == e2?.floatBasic &&
        e1?.floatCooprate == e2?.floatCooprate &&
        e1?.region == e2?.region;
  }

  @override
  int hash(RideVariablesRecord? e) => const ListEquality().hash([
        e?.costOfRide,
        e?.costPerDistance,
        e?.costPerMinute,
        e?.corporateCostOfRide,
        e?.corporateCostPerDistance,
        e?.corporateCostPerMinute,
        e?.floatBasic,
        e?.floatCooprate,
        e?.region
      ]);

  @override
  bool isValidKey(Object? o) => o is RideVariablesRecord;
}
