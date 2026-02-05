import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideRecord extends FirestoreRecord {
  RideRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "driver_location" field.
  LatLng? _driverLocation;
  LatLng? get driverLocation => _driverLocation;
  bool hasDriverLocation() => _driverLocation != null;

  // "destination_location" field.
  LatLng? _destinationLocation;
  LatLng? get destinationLocation => _destinationLocation;
  bool hasDestinationLocation() => _destinationLocation != null;

  // "destination_address" field.
  String? _destinationAddress;
  String get destinationAddress => _destinationAddress ?? '';
  bool hasDestinationAddress() => _destinationAddress != null;

  // "is_driver_assigned" field.
  bool? _isDriverAssigned;
  bool get isDriverAssigned => _isDriverAssigned ?? false;
  bool hasIsDriverAssigned() => _isDriverAssigned != null;

  // "user_number" field.
  String? _userNumber;
  String get userNumber => _userNumber ?? '';
  bool hasUserNumber() => _userNumber != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "ride_fee" field.
  double? _rideFee;
  double get rideFee => _rideFee ?? 0.0;
  bool hasRideFee() => _rideFee != null;

  // "pickup_location" field.
  LatLng? _pickupLocation;
  LatLng? get pickupLocation => _pickupLocation;
  bool hasPickupLocation() => _pickupLocation != null;

  // "pickup_address" field.
  String? _pickupAddress;
  String get pickupAddress => _pickupAddress ?? '';
  bool hasPickupAddress() => _pickupAddress != null;

  // "driver_uid" field.
  DocumentReference? _driverUid;
  DocumentReference? get driverUid => _driverUid;
  bool hasDriverUid() => _driverUid != null;

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  bool hasDriverName() => _driverName != null;

  // "car_model" field.
  String? _carModel;
  String get carModel => _carModel ?? '';
  bool hasCarModel() => _carModel != null;

  // "car_plate" field.
  String? _carPlate;
  String get carPlate => _carPlate ?? '';
  bool hasCarPlate() => _carPlate != null;

  // "driver_phone" field.
  String? _driverPhone;
  String get driverPhone => _driverPhone ?? '';
  bool hasDriverPhone() => _driverPhone != null;

  // "ride_type" field.
  String? _rideType;
  String get rideType => _rideType ?? '';
  bool hasRideType() => _rideType != null;

  // "scheduled_time" field.
  DateTime? _scheduledTime;
  DateTime? get scheduledTime => _scheduledTime;
  bool hasScheduledTime() => _scheduledTime != null;

  // "start_time" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  bool hasStartTime() => _startTime != null;

  // "PassengerId" field.
  DocumentReference? _passengerId;
  DocumentReference? get passengerId => _passengerId;
  bool hasPassengerId() => _passengerId != null;

  void _initializeFields() {
    _driverLocation = snapshotData['driver_location'] as LatLng?;
    _destinationLocation = snapshotData['destination_location'] as LatLng?;
    _destinationAddress = snapshotData['destination_address'] as String?;
    _isDriverAssigned = snapshotData['is_driver_assigned'] as bool?;
    _userNumber = snapshotData['user_number'] as String?;
    _status = snapshotData['status'] as String?;
    _rideFee = castToType<double>(snapshotData['ride_fee']);
    _pickupLocation = snapshotData['pickup_location'] as LatLng?;
    _pickupAddress = snapshotData['pickup_address'] as String?;
    _driverUid = snapshotData['driver_uid'] as DocumentReference?;
    _driverName = snapshotData['driver_name'] as String?;
    _carModel = snapshotData['car_model'] as String?;
    _carPlate = snapshotData['car_plate'] as String?;
    _driverPhone = snapshotData['driver_phone'] as String?;
    _rideType = snapshotData['ride_type'] as String?;
    _scheduledTime = snapshotData['scheduled_time'] as DateTime?;
    _startTime = snapshotData['start_time'] as DateTime?;
    _passengerId = snapshotData['PassengerId'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ride');

  static Stream<RideRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideRecord.fromSnapshot(s));

  static Future<RideRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideRecord.fromSnapshot(s));

  static RideRecord fromSnapshot(DocumentSnapshot snapshot) => RideRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideRecordData({
  LatLng? driverLocation,
  LatLng? destinationLocation,
  String? destinationAddress,
  bool? isDriverAssigned,
  String? userNumber,
  String? status,
  double? rideFee,
  LatLng? pickupLocation,
  String? pickupAddress,
  DocumentReference? driverUid,
  String? driverName,
  String? carModel,
  String? carPlate,
  String? driverPhone,
  String? rideType,
  DateTime? scheduledTime,
  DateTime? startTime,
  DocumentReference? passengerId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'driver_location': driverLocation,
      'destination_location': destinationLocation,
      'destination_address': destinationAddress,
      'is_driver_assigned': isDriverAssigned,
      'user_number': userNumber,
      'status': status,
      'ride_fee': rideFee,
      'pickup_location': pickupLocation,
      'pickup_address': pickupAddress,
      'driver_uid': driverUid,
      'driver_name': driverName,
      'car_model': carModel,
      'car_plate': carPlate,
      'driver_phone': driverPhone,
      'ride_type': rideType,
      'scheduled_time': scheduledTime,
      'start_time': startTime,
      'PassengerId': passengerId,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideRecordDocumentEquality implements Equality<RideRecord> {
  const RideRecordDocumentEquality();

  @override
  bool equals(RideRecord? e1, RideRecord? e2) {
    return e1?.driverLocation == e2?.driverLocation &&
        e1?.destinationLocation == e2?.destinationLocation &&
        e1?.destinationAddress == e2?.destinationAddress &&
        e1?.isDriverAssigned == e2?.isDriverAssigned &&
        e1?.userNumber == e2?.userNumber &&
        e1?.status == e2?.status &&
        e1?.rideFee == e2?.rideFee &&
        e1?.pickupLocation == e2?.pickupLocation &&
        e1?.pickupAddress == e2?.pickupAddress &&
        e1?.driverUid == e2?.driverUid &&
        e1?.driverName == e2?.driverName &&
        e1?.carModel == e2?.carModel &&
        e1?.carPlate == e2?.carPlate &&
        e1?.driverPhone == e2?.driverPhone &&
        e1?.rideType == e2?.rideType &&
        e1?.scheduledTime == e2?.scheduledTime &&
        e1?.startTime == e2?.startTime &&
        e1?.passengerId == e2?.passengerId;
  }

  @override
  int hash(RideRecord? e) => const ListEquality().hash([
        e?.driverLocation,
        e?.destinationLocation,
        e?.destinationAddress,
        e?.isDriverAssigned,
        e?.userNumber,
        e?.status,
        e?.rideFee,
        e?.pickupLocation,
        e?.pickupAddress,
        e?.driverUid,
        e?.driverName,
        e?.carModel,
        e?.carPlate,
        e?.driverPhone,
        e?.rideType,
        e?.scheduledTime,
        e?.startTime,
        e?.passengerId
      ]);

  @override
  bool isValidKey(Object? o) => o is RideRecord;
}
