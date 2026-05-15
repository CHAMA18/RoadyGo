import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart';

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
  final regionConfigs = await _loadRegionPricingConfigs();
  if (regionConfigs.isNotEmpty) {
    return _validateAgainstRegions(
      regionConfigs: regionConfigs,
      pickup: pickup,
      destination: destination,
    );
  }

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

Future<List<_RegionPricingConfig>> _loadRegionPricingConfigs() async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('regions').limit(500).get();
    return snapshot.docs
        .map((doc) => _RegionPricingConfig.fromSnapshot(doc))
        .where((region) => region.isActive && region.isConfigured)
        .toList();
  } catch (e) {
    debugPrint('validateRideRegionSupport: failed to load regions - $e');
    return const [];
  }
}

RideRegionSupportResult _validateAgainstRegions({
  required List<_RegionPricingConfig> regionConfigs,
  required FFPlace pickup,
  required FFPlace destination,
}) {
  final pickupRegions = _regionsForPlace(regionConfigs, pickup);
  if (pickupRegions.isEmpty) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_placeLabel(pickup)} yet. Please choose a pickup country or region supported by RoadyGo.',
    );
  }

  final pickupRegion = _matchingRegion(pickupRegions, pickup) ??
      _countryFallbackRegion(pickupRegions);
  if (pickupRegion == null) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_cityOrPlaceLabel(pickup)} yet. Please choose a pickup city configured in the admin panel.',
    );
  }

  final destinationRegions = _regionsForPlace(regionConfigs, destination);
  if (destinationRegions.isEmpty) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_placeLabel(destination)} yet. Please choose a destination country or region supported by RoadyGo.',
    );
  }

  final destinationRegion = _matchingRegion(
        destinationRegions,
        destination,
      ) ??
      _countryFallbackRegion(destinationRegions);
  if (destinationRegion == null) {
    return RideRegionSupportResult(
      isSupported: false,
      message:
          'RoadyGo is not available in ${_cityOrPlaceLabel(destination)} yet. Please choose a destination city configured in the admin panel.',
    );
  }

  return RideRegionSupportResult(
    isSupported: true,
    message: '',
    pricingVariables: pickupRegion.toRideVariablesRecord(),
  );
}

List<_RegionPricingConfig> _regionsForPlace(
  List<_RegionPricingConfig> regionConfigs,
  FFPlace place,
) {
  final countryMatches =
      regionConfigs.where((region) => _matchesCountry(region, place)).toList();
  if (countryMatches.isNotEmpty) {
    return countryMatches;
  }

  final cityMatch = _matchingRegion(regionConfigs, place);
  if (cityMatch != null) {
    final cityCountryCode = cityMatch.countryCode.trim().toUpperCase();
    if (cityCountryCode.isNotEmpty) {
      return regionConfigs
          .where(
            (region) =>
                region.countryCode.trim().toUpperCase() == cityCountryCode,
          )
          .toList();
    }
    return [cityMatch];
  }

  return const [];
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

_RegionPricingConfig? _matchingRegion(
  List<_RegionPricingConfig> regions,
  FFPlace place,
) {
  final cityCandidates = _cityCandidates(place)
      .map(_normalizeRegion)
      .where((value) => value.isNotEmpty)
      .toSet();
  if (cityCandidates.isEmpty) {
    return null;
  }

  for (final region in regions) {
    final regionCity = _normalizeRegion(region.cityName);
    final regionName = _normalizeRegion(region.displayCityName);
    if (cityCandidates.any(
      (candidate) =>
          candidate == regionCity ||
          candidate == regionName ||
          _containsNormalizedPlace(candidate, regionCity) ||
          _containsNormalizedPlace(regionName, candidate),
    )) {
      return region;
    }
  }
  return null;
}

_RegionPricingConfig? _countryFallbackRegion(
  List<_RegionPricingConfig> regions,
) {
  if (regions.length == 1 && regions.first.cityName.trim().isEmpty) {
    return regions.first;
  }
  return null;
}

bool _matchesCountry(_RegionPricingConfig region, FFPlace place) {
  final placeCountryCode = place.country.trim().toUpperCase();
  final regionCountryCode = region.countryCode.trim().toUpperCase();

  // Direct ISO code match (e.g. "ZM" == "ZM")
  if (placeCountryCode.isNotEmpty &&
      regionCountryCode.isNotEmpty &&
      placeCountryCode == regionCountryCode) {
    return true;
  }

  // Match place's full country name against region's countryName
  // (e.g. place.country "Zambia" == region.countryName "Zambia")
  final placeCountryNorm = _normalizeRegion(place.country);
  final regionCountryName = _normalizeRegion(region.countryName);
  if (placeCountryNorm.isNotEmpty &&
      regionCountryName.isNotEmpty &&
      (placeCountryNorm == regionCountryName ||
          _containsNormalizedPlace(placeCountryNorm, regionCountryName) ||
          _containsNormalizedPlace(regionCountryName, placeCountryNorm))) {
    return true;
  }

  // Match place's full country name against region's countryCode
  // in case admin stored the full name in the code field
  final regionCountryCodeNorm = _normalizeRegion(region.countryCode);
  if (placeCountryNorm.isNotEmpty &&
      regionCountryCodeNorm.isNotEmpty &&
      regionCountryCodeNorm.length > 2 &&
      (placeCountryNorm == regionCountryCodeNorm ||
          _containsNormalizedPlace(placeCountryNorm, regionCountryCodeNorm))) {
    return true;
  }

  // Final fallback: check if the address or name mentions the country
  final countryCandidates = _placeCountryCandidates(place)
      .map(_normalizeRegion)
      .where((value) => value.isNotEmpty)
      .toSet();

  return countryCandidates.any(
    (candidate) =>
        (regionCountryName.isNotEmpty &&
            _containsNormalizedPlace(candidate, regionCountryName)) ||
        (regionCountryCode.length == 2 &&
            candidate == regionCountryCode.toLowerCase()),
  );
}

Iterable<String> _placeCandidates(FFPlace place) sync* {
  yield place.country;
  yield place.state;
  yield place.city;
  yield place.name;
  yield place.address;
}

Iterable<String> _placeCountryCandidates(FFPlace place) sync* {
  yield place.country;
  yield place.address;
  yield place.name;
}

Iterable<String> _cityCandidates(FFPlace place) sync* {
  yield place.city;
  yield place.state;
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

String _cityOrPlaceLabel(FFPlace place) {
  for (final value in [place.city, place.name, place.address, place.country]) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return 'this city';
}

String _normalizeRegion(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool _containsNormalizedPlace(String value, String candidate) {
  if (value.isEmpty || candidate.isEmpty || candidate.length < 3) {
    return false;
  }
  return value == candidate ||
      value.startsWith('$candidate ') ||
      value.endsWith(' $candidate') ||
      value.contains(' $candidate ');
}

class _RegionPricingConfig {
  const _RegionPricingConfig({
    required this.id,
    required this.name,
    required this.cityName,
    required this.countryName,
    required this.countryCode,
    required this.isActive,
    required this.costOfRide,
    required this.costPerKm,
    required this.costPerMin,
    required this.floatPercent,
    required this.corpCostOfRide,
    required this.corpCostPerKm,
    required this.corpCostPerMin,
    required this.corpFloatPercent,
  });

  final String id;
  final String name;
  final String cityName;
  final String countryName;
  final String countryCode;
  final bool isActive;
  final double costOfRide;
  final double costPerKm;
  final double costPerMin;
  final double floatPercent;
  final double corpCostOfRide;
  final double corpCostPerKm;
  final double corpCostPerMin;
  final double corpFloatPercent;

  bool get isConfigured =>
      countryCode.trim().isNotEmpty ||
      countryName.trim().isNotEmpty ||
      cityName.trim().isNotEmpty ||
      name.trim().isNotEmpty;

  String get displayCityName {
    if (cityName.trim().isNotEmpty) {
      return cityName.trim();
    }
    final cleaned = name.trim().replaceFirst(
          RegExp(r'^[\u{1F1E6}-\u{1F1FF}]{2}\s*', unicode: true),
          '',
        );
    if (!cleaned.contains(',')) {
      return cleaned;
    }
    return cleaned.split(',').first.trim();
  }

  factory _RegionPricingConfig.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return _RegionPricingConfig(
      id: doc.id,
      name: _stringValue(data['name']),
      cityName: _stringValue(data['cityName']),
      countryName: _stringValue(data['countryName']),
      countryCode: _stringValue(data['countryCode']),
      isActive: data['isActive'] != false,
      costOfRide: _doubleValue(data['costOfRide']),
      costPerKm: _doubleValue(data['costPerKm']),
      costPerMin: _doubleValue(data['costPerMin']),
      floatPercent: _doubleValue(data['floatPercent']),
      corpCostOfRide: _doubleValue(data['corpCostOfRide']),
      corpCostPerKm: _doubleValue(data['corpCostPerKm']),
      corpCostPerMin: _doubleValue(data['corpCostPerMin']),
      corpFloatPercent: _doubleValue(data['corpFloatPercent']),
    );
  }

  RideVariablesRecord toRideVariablesRecord() {
    return RideVariablesRecord.getDocumentFromData(
      createRideVariablesRecordData(
        region: name.trim().isNotEmpty ? name.trim() : displayCityName,
        costOfRide: costOfRide,
        costPerDistance: costPerKm,
        costPerMinute: costPerMin,
        corporateCostOfRide: corpCostOfRide,
        corporateCostPerDistance: corpCostPerKm,
        corporateCostPerMinute: corpCostPerMin,
        floatBasic: floatPercent,
        floatCooprate: corpFloatPercent,
      ),
      RideVariablesRecord.collection.doc(id),
    );
  }

  static String _stringValue(dynamic value) => value?.toString().trim() ?? '';

  static double _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
