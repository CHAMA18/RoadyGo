import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DriverRecord extends FirestoreRecord {
  DriverRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  bool hasDriverName() => _driverName != null;

  // "car_plate" field.
  String? _carPlate;
  String get carPlate => _carPlate ?? '';
  bool hasCarPlate() => _carPlate != null;

  // "car_model" field.
  String? _carModel;
  String get carModel => _carModel ?? '';
  bool hasCarModel() => _carModel != null;

  // "driver_phone" field.
  String? _driverPhone;
  String get driverPhone => _driverPhone ?? '';
  bool hasDriverPhone() => _driverPhone != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "online" field.
  bool? _online;
  bool get online => _online ?? false;
  bool hasOnline() => _online != null;

  // "Float" field.
  double? _float;
  double get float => _float ?? 0.0;
  bool hasFloat() => _float != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "region" field.
  DocumentReference? _region;
  DocumentReference? get region => _region;
  bool hasRegion() => _region != null;

  void _initializeFields() {
    _driverName = snapshotData['driver_name'] as String?;
    _carPlate = snapshotData['car_plate'] as String?;
    _carModel = snapshotData['car_model'] as String?;
    _driverPhone = snapshotData['driver_phone'] as String?;
    _userId = snapshotData['user_id'] as DocumentReference?;
    _online = snapshotData['online'] as bool?;
    _float = castToType<double>(snapshotData['Float']);
    _imageUrl = snapshotData['image_url'] as String?;
    _region = snapshotData['region'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('driver');

  static Stream<DriverRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DriverRecord.fromSnapshot(s));

  static Future<DriverRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DriverRecord.fromSnapshot(s));

  static DriverRecord fromSnapshot(DocumentSnapshot snapshot) => DriverRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DriverRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DriverRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DriverRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DriverRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDriverRecordData({
  String? driverName,
  String? carPlate,
  String? carModel,
  String? driverPhone,
  DocumentReference? userId,
  bool? online,
  double? float,
  String? imageUrl,
  DocumentReference? region,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'driver_name': driverName,
      'car_plate': carPlate,
      'car_model': carModel,
      'driver_phone': driverPhone,
      'user_id': userId,
      'online': online,
      'Float': float,
      'image_url': imageUrl,
      'region': region,
    }.withoutNulls,
  );

  return firestoreData;
}

class DriverRecordDocumentEquality implements Equality<DriverRecord> {
  const DriverRecordDocumentEquality();

  @override
  bool equals(DriverRecord? e1, DriverRecord? e2) {
    return e1?.driverName == e2?.driverName &&
        e1?.carPlate == e2?.carPlate &&
        e1?.carModel == e2?.carModel &&
        e1?.driverPhone == e2?.driverPhone &&
        e1?.userId == e2?.userId &&
        e1?.online == e2?.online &&
        e1?.float == e2?.float &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.region == e2?.region;
  }

  @override
  int hash(DriverRecord? e) => const ListEquality().hash([
        e?.driverName,
        e?.carPlate,
        e?.carModel,
        e?.driverPhone,
        e?.userId,
        e?.online,
        e?.float,
        e?.imageUrl,
        e?.region
      ]);

  @override
  bool isValidKey(Object? o) => o is DriverRecord;
}
