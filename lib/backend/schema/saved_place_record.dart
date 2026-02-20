import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SavedPlaceRecord extends FirestoreRecord {
  SavedPlaceRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "latitude" field.
  double? _latitude;
  double get latitude => _latitude ?? 0.0;
  bool hasLatitude() => _latitude != null;

  // "longitude" field.
  double? _longitude;
  double get longitude => _longitude ?? 0.0;
  bool hasLongitude() => _longitude != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _address = snapshotData['address'] as String?;
    _latitude = castToType<double>(snapshotData['latitude']);
    _longitude = castToType<double>(snapshotData['longitude']);
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('saved_places')
          : FirebaseFirestore.instance.collectionGroup('saved_places');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('saved_places').doc(id);

  static Stream<SavedPlaceRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SavedPlaceRecord.fromSnapshot(s));

  static Future<SavedPlaceRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SavedPlaceRecord.fromSnapshot(s));

  static SavedPlaceRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SavedPlaceRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SavedPlaceRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SavedPlaceRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SavedPlaceRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SavedPlaceRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSavedPlaceRecordData({
  String? name,
  String? address,
  double? latitude,
  double? longitude,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class SavedPlaceRecordDocumentEquality implements Equality<SavedPlaceRecord> {
  const SavedPlaceRecordDocumentEquality();

  @override
  bool equals(SavedPlaceRecord? e1, SavedPlaceRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.address == e2?.address &&
        e1?.latitude == e2?.latitude &&
        e1?.longitude == e2?.longitude &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(SavedPlaceRecord? e) => const ListEquality().hash([
        e?.name,
        e?.address,
        e?.latitude,
        e?.longitude,
        e?.createdTime
      ]);

  @override
  bool isValidKey(Object? o) => o is SavedPlaceRecord;
}
