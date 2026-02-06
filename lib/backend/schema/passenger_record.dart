import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PassengerRecord extends FirestoreRecord {
  PassengerRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "UserId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "MobileNumber" field.
  String? _mobileNumber;
  String get mobileNumber => _mobileNumber ?? '';
  bool hasMobileNumber() => _mobileNumber != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "Location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  void _initializeFields() {
    _userId = snapshotData['UserId'] as DocumentReference?;
    _name = snapshotData['Name'] as String?;
    _mobileNumber = snapshotData['MobileNumber'] as String?;
    _email = snapshotData['email'] as String?;
    _location = snapshotData['Location'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('passenger');

  static Stream<PassengerRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PassengerRecord.fromSnapshot(s));

  static Future<PassengerRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PassengerRecord.fromSnapshot(s));

  static PassengerRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PassengerRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PassengerRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PassengerRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PassengerRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PassengerRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPassengerRecordData({
  DocumentReference? userId,
  String? name,
  String? mobileNumber,
  String? email,
  String? location,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'UserId': userId,
      'Name': name,
      'MobileNumber': mobileNumber,
      'email': email,
      'Location': location,
    }.withoutNulls,
  );

  return firestoreData;
}

class PassengerRecordDocumentEquality implements Equality<PassengerRecord> {
  const PassengerRecordDocumentEquality();

  @override
  bool equals(PassengerRecord? e1, PassengerRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.name == e2?.name &&
        e1?.mobileNumber == e2?.mobileNumber &&
        e1?.email == e2?.email;
  }

  @override
  int hash(PassengerRecord? e) => const ListEquality()
      .hash([e?.userId, e?.name, e?.mobileNumber, e?.email]);

  @override
  bool isValidKey(Object? o) => o is PassengerRecord;
}
