import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class _AuthHomePageWidgetState extends State<AuthHomePageWidget> {
  late AuthHomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthHomePageModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = FFAppState();
      if (mounted && !appState.hasSelectedLanguage) {
        _showLanguagePicker(appState);
      }
    });
  }

  @override
  void dispose() {
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 1.0,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.6,
                        decoration: BoxDecoration(),
                        child: FlutterFlowGoogleMap(
                          controller: _model.googleMapsController,
                          onCameraIdle: (latLng) =>
                              _model.googleMapsCenter = latLng,
                          initialLocation: _model.googleMapsCenter ??=
                              currentUserLocationValue!,
                          markers: FFAppState()
                              .testMarkers
                              .where(
                                  (e) => FFAppState().testMarkers.contains(e))
                              .toList()
                              .map(
                                (marker) => FlutterFlowMarker(
                                  marker.serialize(),
                                  marker,
                                ),
                              )
                              .toList(),
                          markerColor: GoogleMarkerColor.red,
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
                                    child: FlutterFlowIconButton(
                                      borderRadius: 20.0,
                                      borderWidth: 0.0,
                                      buttonSize: 50.0,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      icon: FaIcon(
                                        FontAwesomeIcons.locationArrow,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      context.pushNamed(
                                          PassengerDetailsWidget.routeName);
                                    },
                                    text: 'Profile',
                                    icon: Icon(
                                      Icons.person_2,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
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
                                      borderRadius:
                                          BorderRadius.circular(100.0),
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
                                      text: 'Go to Ride',
                                      icon: Icon(
                                        Icons.directions_car_rounded,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                        borderRadius:
                                            BorderRadius.circular(100.0),
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
                                  height: 630.0,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Where are you going',
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeFamily,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w900,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .titleLargeIsCustom,
                                                ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 5.0),
                                                child: Text(
                                                  'Pickup Point',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
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
                                                    child:
                                                        FlutterFlowPlacePicker(
                                                      iOSGoogleMapsApiKey:
                                                          'AIzaSyAugAMTT-SxuNhu1KhmoqRPtZaKDOS0Hg4',
                                                      androidGoogleMapsApiKey:
                                                          'AIzaSyD1ugXQT8BZpkhr3H7aoZAvmRwVK2tbJmU',
                                                      webGoogleMapsApiKey:
                                                          'AIzaSyDYzHlT9F93CI8wnb34fNAGwFjEDXaZGpQ',
                                                      onSelect: (place) async {
                                                        safeSetState(() => _model
                                                                .placePickerValue1 =
                                                            place);
                                                      },
                                                      defaultText:
                                                          'Select Pickup Point',
                                                      icon: Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      buttonOptions:
                                                          FFButtonOptions(
                                                        height: 50.0,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .lineColor,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 5.0),
                                                child: Text(
                                                  'Destination',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
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
                                                    child:
                                                        FlutterFlowPlacePicker(
                                                      iOSGoogleMapsApiKey:
                                                          'AIzaSyAugAMTT-SxuNhu1KhmoqRPtZaKDOS0Hg4',
                                                      androidGoogleMapsApiKey:
                                                          'AIzaSyD1ugXQT8BZpkhr3H7aoZAvmRwVK2tbJmU',
                                                      webGoogleMapsApiKey:
                                                          'AIzaSyDYzHlT9F93CI8wnb34fNAGwFjEDXaZGpQ',
                                                      onSelect: (place) async {
                                                        safeSetState(() => _model
                                                                .placePickerValue2 =
                                                            place);
                                                      },
                                                      defaultText:
                                                          'Select Destination',
                                                      icon: Icon(
                                                        Icons
                                                            .outlined_flag_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      buttonOptions:
                                                          FFButtonOptions(
                                                        height: 50.0,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .lineColor,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 5.0),
                                                child: Text(
                                                  'Ride type',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
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
                                                        FFAppState()
                                                            .update(() {});
                                                      },
                                                      child: Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FFAppState()
                                                                      .rideTier ==
                                                                  'Basic'
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .secondary
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Truck.png',
                                                                  height: 60.0,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Car Tow',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FFAppState().rideTier ==
                                                                              'Basic'
                                                                          ? FlutterFlowTheme.of(context)
                                                                              .secondaryBackground
                                                                          : FlutterFlowTheme.of(context)
                                                                              .primaryText,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
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
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: valueOrDefault<
                                                              Color>(
                                                            FFAppState().rideTier ==
                                                                    'Corporate'
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Truck_tow.png',
                                                                  height: 50.0,
                                                                  width: 80.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Container(
                                                                      height:
                                                                          50.0,
                                                                      width:
                                                                          80.0,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      color: Colors
                                                                          .transparent,
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
                                                              Text(
                                                                'Truck Tow',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: valueOrDefault<
                                                                          Color>(
                                                                        FFAppState().rideTier ==
                                                                                'Corporate'
                                                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                                                            : FlutterFlowTheme.of(context).primaryText,
                                                                        FlutterFlowTheme.of(context)
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
                                                                          !FlutterFlowTheme.of(context)
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
                                          if ((_model.placePickerValue2
                                                          .address !=
                                                      '') &&
                                              (_model.placePickerValue1
                                                          .address !=
                                                      ''))
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Ride fee',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<RideVariablesRecord>
                                                                  containerRideVariablesRecordList =
                                                                  snapshot
                                                                      .data!;
                                                              final containerRideVariablesRecord =
                                                                  containerRideVariablesRecordList
                                                                          .isNotEmpty
                                                                      ? containerRideVariablesRecordList
                                                                          .first
                                                                      : null;

                                                              return Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.9,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
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
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
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
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 50.0,
                                                                              height: 50.0,
                                                                              child: CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                  FlutterFlowTheme.of(context).primary,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                        List<RideVariablesRecord>
                                                                            textRideVariablesRecordList =
                                                                            snapshot.data!;
                                                                        final textRideVariablesRecord = textRideVariablesRecordList.isNotEmpty
                                                                            ? textRideVariablesRecordList.first
                                                                            : null;

                                                                        return Text(
                                                                          formatNumber(
                                                                            functions.calculatePrice(_model.placePickerValue1.latLng, _model.placePickerValue2.latLng,
                                                                                () {
                                                                              if (FFAppState().rideTier == 'Basic') {
                                                                                return textRideVariablesRecord!.costOfRide;
                                                                              } else if (FFAppState().rideTier == 'Corporate') {
                                                                                return textRideVariablesRecord!.corporateCostOfRide;
                                                                              } else {
                                                                                return textRideVariablesRecord!.costOfRide;
                                                                              }
                                                                            }(), () {
                                                                              if (FFAppState().rideTier == 'Basic') {
                                                                                return textRideVariablesRecord!.costPerDistance;
                                                                              } else if (FFAppState().rideTier == 'Corporate') {
                                                                                return textRideVariablesRecord!.corporateCostPerDistance;
                                                                              } else {
                                                                                return textRideVariablesRecord!.costPerDistance;
                                                                              }
                                                                            }(), () {
                                                                              if (FFAppState().rideTier == 'Basic') {
                                                                                return textRideVariablesRecord!.costPerMinute;
                                                                              } else if (FFAppState().rideTier == 'Corporate') {
                                                                                return textRideVariablesRecord!.corporateCostPerMinute;
                                                                              } else {
                                                                                return textRideVariablesRecord!.costPerMinute;
                                                                              }
                                                                            }()),
                                                                            formatType:
                                                                                FormatType.decimal,
                                                                            decimalType:
                                                                                DecimalType.periodDecimal,
                                                                            currency:
                                                                                'K',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                              ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              _model.variables =
                                                                  await queryRideVariablesRecordOnce(
                                                                singleRecord:
                                                                    true,
                                                              ).then((s) => s
                                                                      .firstOrNull);
                                                              _model.passenger =
                                                                  await queryPassengerRecordOnce(
                                                                queryBuilder:
                                                                    (passengerRecord) =>
                                                                        passengerRecord
                                                                            .where(
                                                                  'UserId',
                                                                  isEqualTo:
                                                                      currentUserReference,
                                                                ),
                                                                singleRecord:
                                                                    true,
                                                              ).then((s) => s
                                                                      .firstOrNull);

                                                              var rideRecordReference =
                                                                  RideRecord
                                                                      .collection
                                                                      .doc();
                                                              await rideRecordReference
                                                                  .set(
                                                                      createRideRecordData(
                                                                destinationLocation:
                                                                    _model
                                                                        .placePickerValue2
                                                                        .latLng,
                                                                destinationAddress:
                                                                    _model
                                                                        .placePickerValue2
                                                                        .name,
                                                                isDriverAssigned:
                                                                    false,
                                                                pickupLocation:
                                                                    _model
                                                                        .placePickerValue1
                                                                        .latLng,
                                                                pickupAddress:
                                                                    _model
                                                                        .placePickerValue1
                                                                        .name,
                                                                userNumber: _model
                                                                    .passenger
                                                                    ?.mobileNumber,
                                                                status:
                                                                    'Active',
                                                                rideFee: functions
                                                                    .calculatePrice(
                                                                        _model
                                                                            .placePickerValue1
                                                                            .latLng,
                                                                        _model
                                                                            .placePickerValue2
                                                                            .latLng,
                                                                        FFAppState().rideTier ==
                                                                                'Basic'
                                                                            ? _model
                                                                                .variables!.costOfRide
                                                                            : _model
                                                                                .variables!.corporateCostOfRide,
                                                                        FFAppState().rideTier ==
                                                                                'Basic'
                                                                            ? _model
                                                                                .variables!.costPerDistance
                                                                            : _model
                                                                                .variables!.corporateCostPerDistance,
                                                                        FFAppState().rideTier ==
                                                                                'Basic'
                                                                            ? _model.variables!.costPerMinute
                                                                            : _model.variables!.corporateCostPerMinute)
                                                                    .toDouble(),
                                                                rideType:
                                                                    FFAppState()
                                                                        .rideTier,
                                                                passengerId:
                                                                    currentUserReference,
                                                              ));
                                                              _model.rideDetails =
                                                                  RideRecord.getDocumentFromData(
                                                                      createRideRecordData(
                                                                        destinationLocation: _model
                                                                            .placePickerValue2
                                                                            .latLng,
                                                                        destinationAddress: _model
                                                                            .placePickerValue2
                                                                            .name,
                                                                        isDriverAssigned:
                                                                            false,
                                                                        pickupLocation: _model
                                                                            .placePickerValue1
                                                                            .latLng,
                                                                        pickupAddress: _model
                                                                            .placePickerValue1
                                                                            .name,
                                                                        userNumber: _model
                                                                            .passenger
                                                                            ?.mobileNumber,
                                                                        status:
                                                                            'Active',
                                                                        rideFee: functions
                                                                            .calculatePrice(
                                                                                _model.placePickerValue1.latLng,
                                                                                _model.placePickerValue2.latLng,
                                                                                FFAppState().rideTier == 'Basic' ? _model.variables!.costOfRide : _model.variables!.corporateCostOfRide,
                                                                                FFAppState().rideTier == 'Basic' ? _model.variables!.costPerDistance : _model.variables!.corporateCostPerDistance,
                                                                                FFAppState().rideTier == 'Basic' ? _model.variables!.costPerMinute : _model.variables!.corporateCostPerMinute)
                                                                            .toDouble(),
                                                                        rideType:
                                                                            FFAppState().rideTier,
                                                                        passengerId:
                                                                            currentUserReference,
                                                                      ),
                                                                      rideRecordReference);
                                                              FFAppState()
                                                                      .starteRide =
                                                                  _model
                                                                      .rideDetails
                                                                      ?.reference;
                                                              safeSetState(
                                                                  () {});

                                                              context.pushNamed(
                                                                FindingRideWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'rideDetails':
                                                                      serializeParam(
                                                                    _model
                                                                        .rideDetails
                                                                        ?.reference,
                                                                    ParamType
                                                                        .DocumentReference,
                                                                  ),
                                                                }.withoutNulls,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  kTransitionInfoKey:
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .fade,
                                                                  ),
                                                                },
                                                              );

                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            text: 'Order Ride',
                                                            options:
                                                                FFButtonOptions(
                                                              width: 200.0,
                                                              height: 50.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).titleSmallFamily,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                      ),
                                                              elevation: 0.0,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 10.0)),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                        ]
                                            .divide(SizedBox(height: 12.0))
                                            .addToStart(SizedBox(height: 20.0)),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguagePicker(FFAppState appState) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = FlutterFlowTheme.of(context);
        return AlertDialog(
          title: Text(
            'Select Language',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                label: 'English',
                code: 'en',
                appState: appState,
              ),
              _languageOption(
                label: 'Español',
                code: 'es',
                appState: appState,
              ),
              _languageOption(
                label: 'Français',
                code: 'fr',
                appState: appState,
              ),
              _languageOption(
                label: 'Deutsch',
                code: 'de',
                appState: appState,
              ),
              _languageOption(
                label: 'Português',
                code: 'pt',
                appState: appState,
              ),
              _languageOption(
                label: 'العربية',
                code: 'ar',
                appState: appState,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption({
    required String label,
    required String code,
    required FFAppState appState,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: appState.languageCode == code
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        appState.setLanguageCode(code);
        Navigator.of(context).pop();
      },
    );
  }
}
