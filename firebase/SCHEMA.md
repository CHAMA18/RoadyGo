# Firestore Schema (Derived From Code)

Source: `lib/backend/schema/*_record.dart`

## `driver`
- Source: `lib/backend/schema/driver_record.dart`

- `Float`: `dynamic`
- `car_model`: `String?`
- `car_plate`: `String?`
- `driver_name`: `String?`
- `driver_phone`: `String?`
- `image_url`: `String?`
- `online`: `bool?`
- `region`: `DocumentReference?`
- `user_id`: `DocumentReference?`

## `passenger`
- Source: `lib/backend/schema/passenger_record.dart`

- `Location`: `String?`
- `MobileNumber`: `String?`
- `Name`: `String?`
- `UserId`: `DocumentReference?`
- `email`: `String?`

## `ride`
- Source: `lib/backend/schema/ride_record.dart`

- `PassengerId`: `DocumentReference?`
- `car_model`: `String?`
- `car_plate`: `String?`
- `destination_address`: `String?`
- `destination_location`: `LatLng?`
- `driver_location`: `LatLng?`
- `driver_name`: `String?`
- `driver_phone`: `String?`
- `driver_uid`: `DocumentReference?`
- `is_driver_assigned`: `bool?`
- `pickup_address`: `String?`
- `pickup_location`: `LatLng?`
- `ride_fee`: `dynamic`
- `ride_type`: `String?`
- `scheduled_time`: `DateTime?`
- `start_time`: `DateTime?`
- `status`: `String?`
- `user_number`: `String?`

## `RideVariables`
- Source: `lib/backend/schema/ride_variables_record.dart`

- `CorporateCostOfRide`: `dynamic`
- `CorporateCostPerDistance`: `dynamic`
- `CorporateCostPerMinute`: `dynamic`
- `CostOfRide`: `dynamic`
- `CostPerDistance`: `dynamic`
- `CostPerMinute`: `dynamic`
- `FloatBasic`: `dynamic`
- `FloatCooprate`: `dynamic`
- `region`: `String?`

## `users`
- Source: `lib/backend/schema/users_record.dart`

- `created_time`: `DateTime?`
- `display_name`: `String?`
- `email`: `String?`
- `phone_number`: `String?`
- `photo_url`: `String?`
- `uid`: `String?`

