// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the button on the right!

import 'dart:math' show cos, sqrt, asin;
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlng;
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as gmfpi;

class RouteViewLive extends StatefulWidget {
  const RouteViewLive({
    Key? key,
    this.width,
    this.height,
    this.lineColor = Colors.green,
    this.startAddress,
    this.destinationAddress,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
    required this.rideDetails,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color lineColor;
  final String? startAddress;
  final String? destinationAddress;
  final LatLng startCoordinate;
  final LatLng endCoordinate;
  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;
  final DocumentReference rideDetails;

  @override
  _RouteViewLiveState createState() => _RouteViewLiveState();
}

class _RouteViewLiveState extends State<RouteViewLive> {
  static const String _locationIconAssetPath =
      'assets/images/icons8-location.gif';

  late final CameraPosition _initialLocation;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> initialPolylines = {};
  bool _webAdvancedMarkersConfigured = !kIsWeb;
  BitmapDescriptor? _locationMarkerIcon;

  // Same as earlier
  String get googleMapsApiKey {
    if (kIsWeb) {
      return widget.webGoogleMapsApiKey;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
      case TargetPlatform.iOS:
        return widget.iOSGoogleMapsApiKey;
      case TargetPlatform.android:
        return widget.androidGoogleMapsApiKey;
      default:
        return widget.webGoogleMapsApiKey;
    }
  }

  // Formula for calculating distance between two coordinates
  // Same as earlier
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // TODO: Add updated _calculateDistance and _createPolylines method
  // TODO: Add a new method to initialize the polylines

  Future<void> _enableWebAdvancedMarkers(GoogleMapController controller) async {
    if (!kIsWeb || _webAdvancedMarkersConfigured) return;
    var configured = false;
    try {
      await gmfpi.GoogleMapsFlutterPlatform.instance.updateMapConfiguration(
        const gmfpi.MapConfiguration(
          markerType: gmfpi.MarkerType.advancedMarker,
        ),
        mapId: controller.mapId,
      );
      configured = true;
    } catch (e) {
      debugPrint('Failed to enable web advanced markers: $e');
    }
    if (!mounted) return;
    setState(() {
      _webAdvancedMarkersConfigured = configured;
    });
  }

  Marker _createMapMarker({
    required MarkerId markerId,
    required latlng.LatLng position,
    required InfoWindow infoWindow,
    required BitmapDescriptor icon,
  }) {
    if (kIsWeb) {
      return gmfpi.AdvancedMarker(
        markerId: markerId,
        position: position,
        infoWindow: infoWindow,
        icon: icon,
      );
    }
    return Marker(
      markerId: markerId,
      position: position,
      infoWindow: infoWindow,
      icon: icon,
    );
  }

  Set<Marker> get _mapMarkers {
    if (kIsWeb && !_webAdvancedMarkersConfigured) {
      return <Marker>{};
    }
    return Set<Marker>.from(markers);
  }

  Future<BitmapDescriptor> _getLocationMarkerIcon() async {
    if (_locationMarkerIcon != null) return _locationMarkerIcon!;
    try {
      _locationMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size.square(48)),
        _locationIconAssetPath,
      );
    } catch (e) {
      debugPrint('Failed to load location icon asset: $e');
      _locationMarkerIcon = BitmapDescriptor.defaultMarker;
    }
    return _locationMarkerIcon!;
  }

  // Same as earlier
  @override
  void initState() {
    final startCoordinate = latlng.LatLng(
      widget.startCoordinate.latitude,
      widget.startCoordinate.longitude,
    );
    _initialLocation = CameraPosition(
      target: startCoordinate,
      zoom: 14,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RideRecord>(
      stream: RideRecord.getDocument(widget.rideDetails),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: widget.height,
            width: widget.width,
            child: GoogleMap(
              markers: _mapMarkers,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(initialPolylines.values),
              onMapCreated: (GoogleMapController controller) async {
                mapController = controller;
                await _enableWebAdvancedMarkers(controller);
                initPolylines();
              },
            ),
          );
        }

        final rideRecord = snapshot.data;
        debugPrint('MAP::UPDATED');

        return Container(
          height: widget.height,
          width: widget.width,
          child: FutureBuilder<Map<PolylineId, Polyline>?>(
              future: _calculateDistance(
                startLatitude: rideRecord!.driverLocation!.latitude,
                startLongitude: rideRecord.driverLocation!.longitude,
                destinationLatitude: rideRecord.pickupLocation!.latitude,
                destinationLongitude: rideRecord.pickupLocation!.longitude,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return GoogleMap(
                    markers: _mapMarkers,
                    initialCameraPosition: CameraPosition(
                      target: latlng.LatLng(
                        rideRecord.destinationLocation!.latitude,
                        rideRecord.destinationLocation!.longitude,
                      ),
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    polylines: Set<Polyline>.of(initialPolylines.values),
                    onMapCreated: (GoogleMapController controller) async {
                      mapController = controller;
                      await _enableWebAdvancedMarkers(controller);
                    },
                  );
                }

                return GoogleMap(
                  markers: _mapMarkers,
                  initialCameraPosition: CameraPosition(
                    target: latlng.LatLng(
                      rideRecord.destinationLocation!.latitude,
                      rideRecord.destinationLocation!.longitude,
                    ),
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(snapshot.data!.values),
                  onMapCreated: (GoogleMapController controller) async {
                    mapController = controller;
                    await _enableWebAdvancedMarkers(controller);
                  },
                );
              }),
        );
      },
    );
  }

  Future<Tuple2<Map<PolylineId, Polyline>, List<latlng.LatLng>>>
      _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    List<latlng.LatLng> polylineCoordinates = [];

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(latlng.LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: widget.lineColor,
      points: polylineCoordinates,
      width: 3,
    );
    // polylines[id] = polyline;

    return Tuple2({id: polyline}, polylineCoordinates);
  }

  Future<Map<PolylineId, Polyline>?> _calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    if (markers.isNotEmpty) markers.clear();

    try {
      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';
      final markerIcon = await _getLocationMarkerIcon();

      // Start Location Marker
      Marker startMarker = _createMapMarker(
        markerId: MarkerId(startCoordinatesString),
        position: latlng.LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: startCoordinatesString,
          snippet: widget.startAddress ?? '',
        ),
        icon: markerIcon,
      );

      // Destination Location Marker
      Marker destinationMarker = _createMapMarker(
        markerId: MarkerId(destinationCoordinatesString),
        position: latlng.LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: destinationCoordinatesString,
          snippet: widget.destinationAddress ?? '',
        ),
        icon: markerIcon,
        // icon: await BitmapDescriptor.fromAssetImage(
        //   ImageConfiguration(size: Size(20, 20)),
        //   'assets/images/cab-top-view.png',
        // ),
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      debugPrint(
        'MAP::START COORDINATES: ($startLatitude, $startLongitude)',
      );
      debugPrint(
        'MAP::DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: latlng.LatLng(northEastLatitude, northEastLongitude),
            southwest: latlng.LatLng(southWestLatitude, southWestLongitude),
          ),
          60.0,
        ),
      );

      final result = await _createPolylines(
        startLatitude,
        startLongitude,
        destinationLatitude,
        destinationLongitude,
      );

      final polylines = result.item1;
      final polylineCoordinates = result.item2;

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      final placeDistance = totalDistance.toStringAsFixed(2);
      debugPrint('MAP::DISTANCE: $placeDistance km');
      FFAppState().routeDistance = '$placeDistance km';

      var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLatitude,$destinationLongitude&origins=$startLatitude,$startLongitude&key=$googleMapsApiKey',
      );
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        final String durationText =
            jsonResponse['rows'][0]['elements'][0]['duration']['text'];
        debugPrint('MAP::$durationText');
        FFAppState().routeDuration = '$durationText';
      } else {
        debugPrint('ERROR in distance matrix API');
      }

      return polylines;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  initPolylines() async {
    double startLatitude = widget.startCoordinate.latitude;
    double startLongitude = widget.startCoordinate.longitude;

    double destinationLatitude = widget.endCoordinate.latitude;
    double destinationLongitude = widget.endCoordinate.longitude;
    final initPolylines = await _calculateDistance(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
    );
    if (initPolylines != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => initialPolylines = initPolylines));
    }
  }
}
