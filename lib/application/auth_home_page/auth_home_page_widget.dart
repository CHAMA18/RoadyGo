import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:provider/provider.dart';
import 'auth_home_page_model.dart';
export 'auth_home_page_model.dart';

class AuthHomePageWidget extends StatefulWidget {
  const AuthHomePageWidget({super.key});

  static String routeName = 'AuthHomePage';
  static String routePath = '/authHomePage';

  @override
  State<AuthHomePageWidget> createState() => _AuthHomePageWidgetState();
}

class _AuthHomePageWidgetState extends State<AuthHomePageWidget>
    with SingleTickerProviderStateMixin {
  late AuthHomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool _isMapReady = false;
  bool _isSubmittingRideOrder = false;
  late AnimationController _carAnimationController;

  double? _estimatedDistanceKm() {
    final hasPickup = _model.placePickerValue1.address.trim().isNotEmpty;
    final hasDestination = _model.placePickerValue2.address.trim().isNotEmpty;
    if (!hasPickup || !hasDestination) {
      return null;
    }

    final pickup = _model.placePickerValue1.latLng;
    final destination = _model.placePickerValue2.latLng;
    if ((pickup.latitude == 0.0 && pickup.longitude == 0.0) ||
        (destination.latitude == 0.0 && destination.longitude == 0.0)) {
      return null;
    }

    return functions.calculateDistance(pickup, destination);
  }

  Future<RideVariablesRecord?> _loadAdminRideVariables() async {
    try {
      final defaultDocRef = RideVariablesRecord.collection.doc('default');
      final defaultDoc = await RideVariablesRecord.getDocumentOnce(defaultDocRef);
      if (defaultDoc.reference.id == 'default') {
        return defaultDoc;
      }
    } catch (_) {
      // Fall through to broader query when the default doc is missing/inaccessible.
    }

    try {
      final pricingDocs = await queryRideVariablesRecordOnce(limit: 50);
      if (pricingDocs.isEmpty) {
        return null;
      }
      return pricingDocs.firstWhereOrNull((d) => d.reference.id == 'default') ??
          pricingDocs.firstWhereOrNull(
            (d) => d.region.trim().toLowerCase() == 'default',
          ) ??
          pricingDocs.first;
    } catch (e) {
      debugPrint('Failed to load ride pricing: $e');
      return null;
    }
  }

  double _pricingBase(RideVariablesRecord? variables) {
    if (FFAppState().rideTier == 'Corporate') {
      return variables?.corporateCostOfRide ?? 0.0;
    }
    return variables?.costOfRide ?? 0.0;
  }

  double _pricingPerDistance(RideVariablesRecord? variables) {
    if (FFAppState().rideTier == 'Corporate') {
      return variables?.corporateCostPerDistance ?? 0.0;
    }
    return variables?.costPerDistance ?? 0.0;
  }

  double _pricingPerMinute(RideVariablesRecord? variables) {
    if (FFAppState().rideTier == 'Corporate') {
      return variables?.corporateCostPerMinute ?? 0.0;
    }
    return variables?.costPerMinute ?? 0.0;
  }

  Future<void> _recenterMap() async {
    final loc = await getCurrentUserLocation(
      defaultLocation: currentUserLocationValue ?? const LatLng(0.0, 0.0),
      cached: false,
    );
    if (!mounted) {
      return;
    }
    safeSetState(() => currentUserLocationValue = loc);
    final controller = await _model.googleMapsController.future;
    await controller.animateCamera(
      google_maps_flutter.CameraUpdate.newLatLng(
        google_maps_flutter.LatLng(loc.latitude, loc.longitude),
      ),
    );
  }

  Future<void> _handleOrderRide() async {
    if (_isSubmittingRideOrder) {
      return;
    }

    if (currentUserReference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be signed in to create an order.'),
        ),
      );
      return;
    }

    safeSetState(() => _isSubmittingRideOrder = true);
    try {
      _model.variables ??= await _loadAdminRideVariables();
      _model.passenger = await queryPassengerRecordOnce(
        queryBuilder: (passengerRecord) => passengerRecord.where(
          'UserId',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      final rideRecordReference = RideRecord.collection.doc();
      await rideRecordReference.set(
        createRideRecordData(
          destinationLocation: _model.placePickerValue2.latLng,
          destinationAddress: _model.placePickerValue2.name,
          isDriverAssigned: false,
          pickupLocation: _model.placePickerValue1.latLng,
          pickupAddress: _model.placePickerValue1.name,
          userNumber: _model.passenger?.mobileNumber,
          status: 'Active',
          rideFee: functions
              .calculatePrice(
                _model.placePickerValue1.latLng,
                _model.placePickerValue2.latLng,
                _pricingBase(_model.variables),
                _pricingPerDistance(_model.variables),
                _pricingPerMinute(_model.variables),
              )
              .toDouble(),
          rideType: FFAppState().rideTier,
          passengerId: currentUserReference,
        ),
      );

      _model.rideDetails = RideRecord.getDocumentFromData(
        createRideRecordData(
          destinationLocation: _model.placePickerValue2.latLng,
          destinationAddress: _model.placePickerValue2.name,
          isDriverAssigned: false,
          pickupLocation: _model.placePickerValue1.latLng,
          pickupAddress: _model.placePickerValue1.name,
          userNumber: _model.passenger?.mobileNumber,
          status: 'Active',
          rideFee: functions
              .calculatePrice(
                _model.placePickerValue1.latLng,
                _model.placePickerValue2.latLng,
                _pricingBase(_model.variables),
                _pricingPerDistance(_model.variables),
                _pricingPerMinute(_model.variables),
              )
              .toDouble(),
          rideType: FFAppState().rideTier,
          passengerId: currentUserReference,
        ),
        rideRecordReference,
      );

      FFAppState().starteRide = _model.rideDetails?.reference;
      safeSetState(() {});

      if (!mounted) return;
      context.pushNamed(
        FindingRideWidget.routeName,
        queryParameters: {
          'rideDetails': serializeParam(
            _model.rideDetails?.reference,
            ParamType.DocumentReference,
          ),
        }.withoutNulls,
        extra: <String, dynamic>{
          kTransitionInfoKey: const TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
          ),
        },
      );
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      final message = e.code == 'permission-denied'
          ? 'Permission denied while creating ride. Please sign in again and try.'
          : 'Could not create ride. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not create ride. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        safeSetState(() => _isSubmittingRideOrder = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthHomePageModel());
    _carAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) {
      safeSetState(() => currentUserLocationValue = loc);
      resolveUserCurrencySymbol(location: loc);
    })
        .catchError((error) {
      debugPrint('Error getting user location: $error');
      // Fallback to a default location (coordinates for Lusaka, Zambia)
      const fallback = LatLng(-15.4167, 28.2833);
      safeSetState(() => currentUserLocationValue = fallback);
      resolveUserCurrencySymbol(location: fallback);
    }).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        debugPrint('Location request timed out, using default location');
        // Fallback to a default location after timeout
        const fallback = LatLng(-15.4167, 28.2833);
        safeSetState(() => currentUserLocationValue = fallback);
        resolveUserCurrencySymbol(location: fallback);
      },
    );
  }

  @override
  void dispose() {
    _carAnimationController.dispose();
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              alignment: AlignmentDirectional(0.0, 1.0),
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        _buildFallbackMapBackground(),
                        Positioned.fill(
                          child: FlutterFlowGoogleMap(
                            controller: _model.googleMapsController,
                            onMapReady: () {
                              if (!_isMapReady && mounted) {
                                safeSetState(() => _isMapReady = true);
                              }
                            },
                            onCameraIdle: (latLng) {
                              _model.googleMapsCenter = latLng;
                            },
                            initialLocation: _model.googleMapsCenter ??=
                                currentUserLocationValue!,
                            markers: [
                              FlutterFlowMarker(
                                'current_user_marker',
                                currentUserLocationValue!,
                              ),
                              ...FFAppState()
                                  .testMarkers
                                  .where((e) => FFAppState().testMarkers.contains(e))
                                  .toList()
                                  .map(
                                    (marker) => FlutterFlowMarker(
                                      marker.serialize(),
                                      marker,
                                    ),
                                  ),
                            ],
                            markerColor: GoogleMarkerColor.red,
                            markerImage: const MarkerImage(
                              imagePath: 'assets/images/Car-tow.png',
                              isAssetImage: true,
                              size: 52,
                            ),
                            mapType: MapType.normal,
                            style: GoogleMapStyle.standard,
                            initialZoom: 14.0,
                            allowInteraction: true,
                            allowZoom: true,
                            showZoomControls: false,
                            showLocation: true,
                            showCompass: false,
                            showMapToolbar: true,
                            showTraffic: false,
                            centerMapOnMarkerTap: false,
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 220),
                              opacity: _isMapReady ? 0.0 : 1.0,
                              child: _buildFallbackMapBackground(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12.0,
                  left: 15.0,
                  right: 15.0,
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(SchedulePageWidget.routeName);
                    },
                    text: 'Schedule Ride',
                    icon: Icon(
                      Icons.schedule_rounded,
                      size: 18.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 52.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
                          ),
                      elevation: 2.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).lineColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 10.0, 15.0, 10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () async {
                                      await _recenterMap();
                                    },
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withValues(alpha: 0.12),
                                            blurRadius: 10.0,
                                            offset: const Offset(0.0, 3.0),
                                          ),
                                        ],
                                      ),
                                      child: AnimatedBuilder(
                                        animation: _carAnimationController,
                                        builder: (context, _) {
                                          final pulse = Curves.easeInOut.transform(
                                            _carAnimationController.value,
                                          );
                                          final iconScale = 0.92 + (pulse * 0.18);

                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 28 + (pulse * 8),
                                                height: 28 + (pulse * 8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: FlutterFlowTheme.of(context)
                                                      .primary
                                                      .withValues(alpha: 0.14),
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: iconScale,
                                                child: Icon(
                                                  Icons
                                                      .directions_car_filled_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 23.0,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  context
                                      .pushNamed(ProfilePageWidget.routeName);
                                },
                                text: context.tr('profile'),
                                icon: Icon(
                                  Icons.person_2,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              if (FFAppState().starteRide != null)
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                      FindingRideWidget.routeName,
                                      queryParameters: {
                                        'rideDetails': serializeParam(
                                          FFAppState().starteRide,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: context.tr('go_to_ride'),
                                  icon: Icon(
                                    Icons.directions_car_rounded,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleSmallIsCustom,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                            ].divide(SizedBox(width: 15.0)),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0),
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 0.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.tr('where_are_you_going'),
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLargeFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w900,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleLargeIsCustom,
                                            ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              context.tr('pickup_point'),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: FlutterFlowPlacePicker(
                                                  iOSGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyIOS,
                                                  androidGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyAndroid,
                                                  webGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyWeb,
                                                  onSelect: (place) async {
                                                    safeSetState(() => _model
                                                            .placePickerValue1 =
                                                        place);
                                                  },
                                                  defaultText: context.tr(
                                                      'select_pickup_point'),
                                                  icon: Icon(
                                                    Icons.location_on_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                  buttonOptions:
                                                      FFButtonOptions(
                                                    height: 50.0,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .lineColor,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              context.tr('destination'),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: FlutterFlowPlacePicker(
                                                  iOSGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyIOS,
                                                  androidGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyAndroid,
                                                  webGoogleMapsApiKey:
                                                      kGoogleMapsApiKeyWeb,
                                                  onSelect: (place) async {
                                                    safeSetState(() => _model
                                                            .placePickerValue2 =
                                                        place);
                                                  },
                                                  defaultText: context
                                                      .tr('select_destination'),
                                                  icon: Icon(
                                                    Icons.outlined_flag_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                  buttonOptions:
                                                      FFButtonOptions(
                                                    height: 50.0,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .lineColor,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              context.tr('ride_type'),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().rideTier =
                                                        'Basic';
                                                    FFAppState().update(() {});
                                                  },
                                                  child: Container(
                                                    width: 100.0,
                                                    height: 160.0,
                                                    decoration: BoxDecoration(
                                                      color: FFAppState()
                                                                  .rideTier ==
                                                              'Basic'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                        color: FFAppState()
                                                                    .rideTier ==
                                                                'Basic'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                        width: FFAppState()
                                                                    .rideTier ==
                                                                'Basic'
                                                            ? 2.0
                                                            : 1.0,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 120.0,
                                                            width: 160.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/car_tow.png',
                                                                height: 120.0,
                                                                width: 160.0,
                                                                fit: BoxFit
                                                                    .contain,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/images/Car-tow.png',
                                                                    height:
                                                                        120.0,
                                                                    width:
                                                                        160.0,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Container(
                                                                        height:
                                                                            120.0,
                                                                        width:
                                                                            160.0,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .directions_car_outlined,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            context
                                                                .tr('car_tow'),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FFAppState()
                                                                              .rideTier ==
                                                                          'Basic'
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().rideTier =
                                                        'Corporate';
                                                    safeSetState(() {});
                                                  },
                                                  child: Container(
                                                    height: 160.0,
                                                    decoration: BoxDecoration(
                                                      color: FFAppState()
                                                                  .rideTier ==
                                                              'Corporate'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                        color: FFAppState()
                                                                    .rideTier ==
                                                                'Corporate'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                        width: FFAppState()
                                                                    .rideTier ==
                                                                'Corporate'
                                                            ? 2.0
                                                            : 1.0,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            height: 100.0,
                                                            width: 160.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/Truck-tow.png',
                                                                height: 100.0,
                                                                width: 160.0,
                                                                fit: BoxFit
                                                                    .contain,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    height:
                                                                        100.0,
                                                                    width:
                                                                        160.0,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons
                                                                          .local_shipping_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            context.tr(
                                                                'truck_tow'),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color:
                                                                      valueOrDefault<
                                                                          Color>(
                                                                    FFAppState().rideTier ==
                                                                            'Corporate'
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .secondaryBackground
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                  ),
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ],
                                      ),
                                      if (_estimatedDistanceKm() != null)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(14.0, 10.0, 14.0, 10.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .lineColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.route_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 18.0,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                'Estimated distance: ${formatNumber(
                                                  _estimatedDistanceKm(),
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType: DecimalType
                                                      .periodDecimal,
                                                )} km',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_estimatedDistanceKm() != null)
                                        SizedBox(height: 10.0),
                                      if ((_model.placePickerValue2.address !=
                                              '') &&
                                          (_model.placePickerValue1.address !=
                                              ''))
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context.tr('ride_fee'),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            1.0, 0.0),
                                                    children: [
                                                      StreamBuilder<
                                                          List<
                                                              RideVariablesRecord>>(
                                                        stream:
                                                            queryRideVariablesRecord(
                                                          singleRecord: true,
                                                        ),
                                                        builder: (context,
                                                            snapshot) {
                                                          // Customize what your widget looks like when it's loading.
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<
                                                                          Color>(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          final pricingFromStream =
                                                              snapshot.data!
                                                                  .firstOrNull;
                                                          if (pricingFromStream !=
                                                              null) {
                                                            _model.variables =
                                                                pricingFromStream;
                                                          }
                                                          return Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.9,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            30.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: StreamBuilder<
                                                                    List<
                                                                        RideVariablesRecord>>(
                                                                  stream:
                                                                      queryRideVariablesRecord(
                                                                    singleRecord:
                                                                        true,
                                                                  ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    List<RideVariablesRecord>
                                                                        textRideVariablesRecordList =
                                                                        snapshot
                                                                            .data!;
                                                                    final textRideVariablesRecord = textRideVariablesRecordList
                                                                            .isNotEmpty
                                                                        ? textRideVariablesRecordList
                                                                            .first
                                                                        : null;
                                                                    if (textRideVariablesRecord !=
                                                                        null) {
                                                                      _model.variables =
                                                                          textRideVariablesRecord;
                                                                    }
                                                                    final selectedCostOfRide = FFAppState().rideTier ==
                                                                            'Corporate'
                                                                        ? textRideVariablesRecord?.corporateCostOfRide ??
                                                                            0.0
                                                                        : textRideVariablesRecord?.costOfRide ??
                                                                            0.0;
                                                                    final selectedCostPerDistance = FFAppState().rideTier ==
                                                                            'Corporate'
                                                                        ? textRideVariablesRecord?.corporateCostPerDistance ??
                                                                            0.0
                                                                        : textRideVariablesRecord?.costPerDistance ??
                                                                            0.0;
                                                                    final selectedCostPerMinute = FFAppState().rideTier ==
                                                                            'Corporate'
                                                                        ? textRideVariablesRecord?.corporateCostPerMinute ??
                                                                            0.0
                                                                        : textRideVariablesRecord?.costPerMinute ??
                                                                            0.0;

                                                                    return Text(
                                                                      formatNumber(
                                                                        functions.calculatePrice(
                                                                            _model.placePickerValue1.latLng,
                                                                            _model.placePickerValue2.latLng,
                                                                            selectedCostOfRide,
                                                                            selectedCostPerDistance,
                                                                            selectedCostPerMinute),
                                                                        formatType:
                                                                            FormatType.decimal,
                                                                        decimalType:
                                                                            DecimalType.periodDecimal,
                                                                        currency:
                                                                            getCurrentCurrencySymbol(),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                          ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      _SlideToConfirmAction(
                                                        width: 200.0,
                                                        height: 50.0,
                                                        label: context
                                                            .tr('order_ride'),
                                                        enabled:
                                                            !_isSubmittingRideOrder,
                                                        isLoading:
                                                            _isSubmittingRideOrder,
                                                        fillColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        textColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        onConfirmed:
                                                            _handleOrderRide,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 10.0)),
                                            ),
                                          ].divide(SizedBox(height: 10.0)),
                                        ),
                                    ]
                                        .divide(SizedBox(height: 12.0))
                                        .addToStart(SizedBox(height: 20.0))
                                        .addToEnd(SizedBox(height: 20.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguagePicker(FFAppState appState) async {
    final searchController = TextEditingController();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = FlutterFlowTheme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            final q = searchController.text.trim().toLowerCase();
            final items = RoadyGoI18n.europeanLanguages
                .where((e) =>
                    q.isEmpty ||
                    e.name.toLowerCase().contains(q) ||
                    e.code.toLowerCase().contains(q))
                .toList();

            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              title: Text(
                context.tr('select_language'),
                style: theme.titleMedium.override(
                  fontFamily: theme.titleMediumFamily,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.0,
                  useGoogleFonts: !theme.titleMediumIsCustom,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.sizeOf(context)
                    .width
                    .clamp(0.0, 360.0)
                    .toDouble(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: context.tr('search_language'),
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (dialogContext, i) {
                            final item = items[i];
                            return _languageOption(
                              label: item.name,
                              code: item.code,
                              flag: item.flag,
                              appState: appState,
                              dialogContext: dialogContext,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    searchController.dispose();
  }

  Widget _languageOption({
    required String label,
    required String code,
    required String flag,
    required FFAppState appState,
    required BuildContext dialogContext,
  }) {
    final isTranslated = RoadyGoI18n.isLanguageFullyTranslated(code);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 22.0),
      ),
      title: Text(label),
      subtitle: Text(code.toUpperCase()),
      trailing: appState.languageCode == code
          ? const Icon(Icons.check, color: Colors.green)
          : !isTranslated
              ? const Icon(Icons.lock_outline_rounded)
              : null,
      onTap: () {
        if (!isTranslated) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text(context.tr('language_coming_soon')),
            ),
          );
          return;
        }
        Navigator.of(dialogContext).pop();
        Future.microtask(() => appState.setLanguageCode(code));
      },
    );
  }

  Widget _buildFallbackMapBackground() {
    final theme = FlutterFlowTheme.of(context);
    final primary = theme.primary;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F1F8),
            Color(0xFFDCEADF),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: CustomPaint(
                painter: _AuthFallbackRoadGridPainter(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_rounded,
                  color: primary.withValues(alpha: 0.85),
                  size: 34,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('loading_map'),
                  style: TextStyle(
                    color: theme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthFallbackRoadGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = const Color(0xFF90A4AE).withValues(alpha: 0.22)
      ..strokeWidth = 1;
    final major = Paint()
      ..color = const Color(0xFF607D8B).withValues(alpha: 0.25)
      ..strokeWidth = 2;

    for (double y = 0; y <= size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }
    for (double x = 0; x <= size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.15),
      Offset(size.width * 0.92, size.height * 0.72),
      major,
    );
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.92),
      Offset(size.width * 0.78, size.height * 0.12),
      major,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlideToConfirmAction extends StatefulWidget {
  const _SlideToConfirmAction({
    required this.width,
    required this.height,
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.fillColor,
    required this.textColor,
    required this.onConfirmed,
  });

  final double width;
  final double height;
  final String label;
  final bool enabled;
  final bool isLoading;
  final Color fillColor;
  final Color textColor;
  final Future<void> Function() onConfirmed;

  @override
  State<_SlideToConfirmAction> createState() => _SlideToConfirmActionState();
}

class _SlideToConfirmActionState extends State<_SlideToConfirmAction> {
  double _dragProgress = 0.0;
  bool _confirming = false;

  double get _knobSize => widget.height - 8;

  @override
  void didUpdateWidget(covariant _SlideToConfirmAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && !widget.isLoading) {
      _dragProgress = 0.0;
    }
  }

  Future<void> _completeConfirm() async {
    if (_confirming || !widget.enabled) return;
    setState(() {
      _confirming = true;
      _dragProgress = 1.0;
    });
    try {
      await widget.onConfirmed();
    } finally {
      if (mounted) {
        setState(() {
          _confirming = false;
          _dragProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxOffset = widget.width - _knobSize - 8;
    final clampedProgress = _dragProgress.clamp(0.0, 1.0);
    final knobLeft = 4 + (maxOffset * clampedProgress);
    final isBusy = widget.isLoading || _confirming;

    return Opacity(
      opacity: widget.enabled || isBusy ? 1.0 : 0.55,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: (widget.width * clampedProgress)
                  .clamp(widget.height, widget.width)
                  .toDouble(),
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.fillColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Center(
              child: Text(
                isBusy ? 'Ordering...' : 'Slide to ${widget.label}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: clampedProgress > 0.55 ? Colors.white : widget.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Positioned(
              left: knobLeft,
              top: 4,
              child: GestureDetector(
                onHorizontalDragUpdate: (!widget.enabled || isBusy)
                    ? null
                    : (details) {
                        setState(() {
                          _dragProgress += details.delta.dx / maxOffset;
                          _dragProgress = _dragProgress.clamp(0.0, 1.0);
                        });
                      },
                onHorizontalDragEnd: (!widget.enabled || isBusy)
                    ? null
                    : (_) async {
                        if (_dragProgress >= 0.92) {
                          await _completeConfirm();
                        } else {
                          setState(() => _dragProgress = 0.0);
                        }
                      },
                child: Container(
                  width: _knobSize,
                  height: _knobSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isBusy ? Icons.hourglass_top_rounded : Icons.chevron_right_rounded,
                    color: widget.fillColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
