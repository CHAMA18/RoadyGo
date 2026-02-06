import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';
import 'package:go_taxi_rider/flutter_flow/place.dart';
import 'package:go_taxi_rider/flutter_flow/lat_lng.dart';
import 'package:go_taxi_rider/components/destination_picker/destination_picker_widget.dart';
import 'package:web/web.dart' as web;

/// Check if Google Maps is loaded
bool _isGoogleMapsLoaded() {
  try {
    final google = js_util.getProperty(js_util.globalThis, 'google');
    if (google == null) return false;
    final maps = js_util.getProperty(google, 'maps');
    if (maps == null) return false;
    final places = js_util.getProperty(maps, 'places');
    return places != null;
  } catch (e) {
    return false;
  }
}

/// Search for places using Google Places Autocomplete API (Web)
Future<List<PlaceSearchResult>> searchPlaces(
  String query,
  String apiKey,
  double lat,
  double lng,
) async {
  if (!_isGoogleMapsLoaded()) {
    debugPrint('Google Maps not loaded');
    return [];
  }

  final completer = Completer<List<PlaceSearchResult>>();

  try {
    final google = js_util.getProperty(js_util.globalThis, 'google');
    final maps = js_util.getProperty(google, 'maps');
    final places = js_util.getProperty(maps, 'places');
    
    // Create AutocompleteService
    final AutocompleteServiceClass = js_util.getProperty(places, 'AutocompleteService');
    final service = js_util.callConstructor(AutocompleteServiceClass, []);
    
    // Create LatLng
    final LatLngClass = js_util.getProperty(maps, 'LatLng');
    final location = js_util.callConstructor(LatLngClass, [lat, lng]);
    
    // Create request object
    final request = js_util.newObject();
    js_util.setProperty(request, 'input', query);
    js_util.setProperty(request, 'location', location);
    js_util.setProperty(request, 'radius', 50000);
    
    // Create callback
    void callback(dynamic predictions, dynamic status) {
      final results = <PlaceSearchResult>[];
      
      if (predictions != null) {
        final length = js_util.getProperty(predictions, 'length') as int? ?? 0;
        for (var i = 0; i < length; i++) {
          final p = js_util.getProperty(predictions, i);
          if (p != null) {
            final placeId = js_util.getProperty(p, 'place_id')?.toString() ?? '';
            final description = js_util.getProperty(p, 'description')?.toString() ?? '';
            final formatting = js_util.getProperty(p, 'structured_formatting');
            
            String mainText = description;
            String secondaryText = '';
            
            if (formatting != null) {
              mainText = js_util.getProperty(formatting, 'main_text')?.toString() ?? description;
              secondaryText = js_util.getProperty(formatting, 'secondary_text')?.toString() ?? '';
            }
            
            if (placeId.isNotEmpty) {
              results.add(PlaceSearchResult(
                placeId: placeId,
                mainText: mainText,
                secondaryText: secondaryText,
              ));
            }
          }
        }
      }
      
      completer.complete(results);
    }
    
    // Call getPlacePredictions
    js_util.callMethod(service, 'getPlacePredictions', [
      request,
      js_util.allowInterop(callback),
    ]);
    
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => [],
    );
  } catch (e) {
    debugPrint('Error in searchPlaces: $e');
    return [];
  }
}

/// Search for nearby places by type using Google Places Nearby Search API (Web)
Future<List<PlaceSearchResult>> searchNearbyPlaces(
  String type,
  String apiKey,
  double lat,
  double lng,
) async {
  if (!_isGoogleMapsLoaded()) {
    debugPrint('Google Maps not loaded');
    return [];
  }

  final completer = Completer<List<PlaceSearchResult>>();

  try {
    // Create a dummy div for PlacesService (required)
    final dummyDiv = web.document.createElement('div');
    
    final google = js_util.getProperty(js_util.globalThis, 'google');
    final maps = js_util.getProperty(google, 'maps');
    final places = js_util.getProperty(maps, 'places');
    
    // Create PlacesService
    final PlacesServiceClass = js_util.getProperty(places, 'PlacesService');
    final service = js_util.callConstructor(PlacesServiceClass, [dummyDiv]);
    
    // Create LatLng
    final LatLngClass = js_util.getProperty(maps, 'LatLng');
    final location = js_util.callConstructor(LatLngClass, [lat, lng]);
    
    // Create request object
    final request = js_util.newObject();
    js_util.setProperty(request, 'location', location);
    js_util.setProperty(request, 'radius', 25000);
    js_util.setProperty(request, 'type', type);
    
    // Create callback
    void callback(dynamic results, dynamic status, dynamic pagination) {
      final placeResults = <PlaceSearchResult>[];
      
      if (results != null) {
        final length = js_util.getProperty(results, 'length') as int? ?? 0;
        final count = length > 10 ? 10 : length;
        
        for (var i = 0; i < count; i++) {
          final place = js_util.getProperty(results, i);
          if (place != null) {
            final placeId = js_util.getProperty(place, 'place_id')?.toString() ?? '';
            final name = js_util.getProperty(place, 'name')?.toString() ?? '';
            final address = js_util.getProperty(place, 'formatted_address')?.toString() ?? 
                           js_util.getProperty(place, 'vicinity')?.toString() ?? '';
            
            double? placeLat;
            double? placeLng;
            
            final geometry = js_util.getProperty(place, 'geometry');
            if (geometry != null) {
              final locationObj = js_util.getProperty(geometry, 'location');
              if (locationObj != null) {
                placeLat = js_util.callMethod(locationObj, 'lat', []) as double?;
                placeLng = js_util.callMethod(locationObj, 'lng', []) as double?;
              }
            }
            
            if (placeId.isNotEmpty) {
              placeResults.add(PlaceSearchResult(
                placeId: placeId,
                mainText: name,
                secondaryText: address,
                lat: placeLat,
                lng: placeLng,
              ));
            }
          }
        }
      }
      
      completer.complete(placeResults);
    }
    
    // Call nearbySearch
    js_util.callMethod(service, 'nearbySearch', [
      request,
      js_util.allowInterop(callback),
    ]);
    
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => [],
    );
  } catch (e) {
    debugPrint('Error in searchNearbyPlaces: $e');
    return [];
  }
}

/// Get place details using Google Places Details API (Web)
Future<FFPlace?> getPlaceDetails(String placeId, String apiKey) async {
  if (!_isGoogleMapsLoaded()) {
    debugPrint('Google Maps not loaded');
    return null;
  }

  final completer = Completer<FFPlace?>();

  try {
    // Create a dummy div for PlacesService (required)
    final dummyDiv = web.document.createElement('div');
    
    final google = js_util.getProperty(js_util.globalThis, 'google');
    final maps = js_util.getProperty(google, 'maps');
    final places = js_util.getProperty(maps, 'places');
    
    // Create PlacesService
    final PlacesServiceClass = js_util.getProperty(places, 'PlacesService');
    final service = js_util.callConstructor(PlacesServiceClass, [dummyDiv]);
    
    // Create request object
    final request = js_util.newObject();
    js_util.setProperty(request, 'placeId', placeId);
    js_util.setProperty(request, 'fields', ['name', 'formatted_address', 'geometry', 'address_components']);
    
    // Create callback
    void callback(dynamic place, dynamic status) {
      if (place == null) {
        completer.complete(null);
        return;
      }
      
      double? placeLat;
      double? placeLng;
      
      final geometry = js_util.getProperty(place, 'geometry');
      if (geometry != null) {
        final locationObj = js_util.getProperty(geometry, 'location');
        if (locationObj != null) {
          placeLat = js_util.callMethod(locationObj, 'lat', []) as double?;
          placeLng = js_util.callMethod(locationObj, 'lng', []) as double?;
        }
      }
      
      if (placeLat == null || placeLng == null) {
        completer.complete(null);
        return;
      }
      
      final name = js_util.getProperty(place, 'name')?.toString() ?? '';
      final address = js_util.getProperty(place, 'formatted_address')?.toString() ?? '';
      
      String? city;
      String? state;
      String? country;
      String? zipCode;
      
      final components = js_util.getProperty(place, 'address_components');
      if (components != null) {
        final length = js_util.getProperty(components, 'length') as int? ?? 0;
        for (var i = 0; i < length; i++) {
          final component = js_util.getProperty(components, i);
          if (component != null) {
            final shortName = js_util.getProperty(component, 'short_name')?.toString();
            final types = js_util.getProperty(component, 'types');
            
            if (types != null && shortName != null) {
              final typesLength = js_util.getProperty(types, 'length') as int? ?? 0;
              for (var j = 0; j < typesLength; j++) {
                final typeStr = js_util.getProperty(types, j)?.toString();
                if (typeStr == 'locality' || typeStr == 'sublocality') {
                  city ??= shortName;
                } else if (typeStr == 'administrative_area_level_1') {
                  state = shortName;
                } else if (typeStr == 'country') {
                  country = shortName;
                } else if (typeStr == 'postal_code') {
                  zipCode = shortName;
                }
              }
            }
          }
        }
      }
      
      final result = FFPlace(
        latLng: LatLng(placeLat, placeLng),
        name: name,
        address: address,
        city: city ?? '',
        state: state ?? '',
        country: country ?? '',
        zipCode: zipCode ?? '',
      );
      
      completer.complete(result);
    }
    
    // Call getDetails
    js_util.callMethod(service, 'getDetails', [
      request,
      js_util.allowInterop(callback),
    ]);
    
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => null,
    );
  } catch (e) {
    debugPrint('Error in getPlaceDetails: $e');
    return null;
  }
}
