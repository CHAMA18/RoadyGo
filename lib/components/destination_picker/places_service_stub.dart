// Stub implementation for non-web platforms
import 'package:go_taxi_rider/flutter_flow/place.dart';
import 'package:go_taxi_rider/components/destination_picker/destination_picker_widget.dart';

Future<List<PlaceSearchResult>> searchPlaces(
  String query,
  String apiKey,
  double lat,
  double lng,
) async {
  return [];
}

Future<List<PlaceSearchResult>> searchNearbyPlaces(
  String type,
  String apiKey,
  double lat,
  double lng,
) async {
  return [];
}

Future<FFPlace?> getPlaceDetails(String placeId, String apiKey) async {
  return null;
}
