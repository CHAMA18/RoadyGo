import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideRegionSupportResult {
  const RideRegionSupportResult({
    required this.isSupported,
    required this.message,
    this.pricingVariables,
  });

  final bool isSupported;
  final String message;
  final RideVariablesRecord? pricingVariables;
}

Future<RideRegionSupportResult> validateRideRegionSupport({
  required FFPlace pickup,
  required FFPlace destination,
}) async {
  final records = await queryRideVariablesRecordOnce(limit: 200);
  final configuredRecords = records.where(_isConfiguredRegion).toList();

  if (configuredRecords.isEmpty) {
    return const RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in this country yet. Our team has not configured ride coverage for this region.',
    );
  }

  final pickupVariables = _matchingVariables(configuredRecords, pickup);
  if (pickupVariables == null) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_placeLabel(pickup)} yet. Please choose a pickup country or region supported by RoadyGo.',
    );
  }

  if (_matchingVariables(configuredRecords, destination) == null) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_placeLabel(destination)} yet. Please choose a destination country or region supported by RoadyGo.',
    );
  }

  return RideRegionSupportResult(
    isSupported: true,
    message: '',
    pricingVariables: pickupVariables,
  );
}

bool _isConfiguredRegion(RideVariablesRecord record) {
  final region = _normalizeRegion(record.region);
  return region.isNotEmpty && region != 'default' && region != 'global';
}

RideVariablesRecord? _matchingVariables(
  List<RideVariablesRecord> records,
  FFPlace place,
) {
  final candidates = _placeCandidates(place)
      .map(_normalizeRegion)
      .where((value) => value.isNotEmpty)
      .toSet();

  if (candidates.isEmpty) {
    return null;
  }

  for (final record in records) {
    final region = _normalizeRegion(record.region);
    if (candidates.any((candidate) =>
        candidate == region ||
        candidate.contains(region) ||
        region.contains(candidate))) {
      return record;
    }
  }
  return null;
}

Iterable<String> _placeCandidates(FFPlace place) sync* {
  yield place.country;
  yield place.state;
  yield place.city;
  yield place.name;
  yield place.address;
}

String _placeLabel(FFPlace place) {
  for (final value in [place.country, place.state, place.city, place.address]) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return 'this country';
}

String _normalizeRegion(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
