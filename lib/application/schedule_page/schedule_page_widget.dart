import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:provider/provider.dart';
import 'schedule_page_model.dart';
export 'schedule_page_model.dart';

class SchedulePageWidget extends StatefulWidget {
  const SchedulePageWidget({super.key});

  static String routeName = 'SchedulePage';
  static String routePath = '/schedulePage';

  @override
  State<SchedulePageWidget> createState() => _SchedulePageWidgetState();
}

class _SchedulePageWidgetState extends State<SchedulePageWidget> {
  late SchedulePageModel _model;
  static const LatLng _fallbackLocation = LatLng(-15.4167, 28.2833);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool _isMapReady = false;
  bool _isSchedulingRide = false;

  bool get _hasPickup => _model.placePickerValue1.address.trim().isNotEmpty;
  bool get _hasDestination => _model.placePickerValue2.address.trim().isNotEmpty;
  bool get _hasScheduleTime => _model.datePicked != null;
  bool get _isFutureTime =>
      _model.datePicked?.isAfter(DateTime.now().add(const Duration(minutes: 1))) ??
      false;
  bool get _canSchedule =>
      _hasPickup && _hasDestination && _hasScheduleTime && _isFutureTime;

  String _formatScheduleTime(DateTime? dt) {
    if (dt == null) {
      return context.tr('pick_time_of_ride');
    }
    return dateTimeFormat('MMM d, h:mm a', dt);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SchedulePageModel());
    currentUserLocationValue = _fallbackLocation;

    getCurrentUserLocation(defaultLocation: _fallbackLocation, cached: true)
        .then((loc) {
      safeSetState(() => currentUserLocationValue = loc);
      resolveUserCurrencySymbol(location: loc);
    }).catchError((_) {
      safeSetState(() => currentUserLocationValue = _fallbackLocation);
      resolveUserCurrencySymbol(location: _fallbackLocation);
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        safeSetState(() => currentUserLocationValue = _fallbackLocation);
        resolveUserCurrencySymbol(location: _fallbackLocation);
      },
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickScheduleDateTime() async {
    final now = DateTime.now();
    final initialDate = _model.datePicked ?? now.add(const Duration(minutes: 30));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    safeSetState(() {
      _model.datePicked = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _setQuickTime(DateTime dateTime) {
    safeSetState(() => _model.datePicked = dateTime);
  }

  Future<void> _recenterMap() async {
    final loc = await getCurrentUserLocation(
      defaultLocation: currentUserLocationValue ?? _fallbackLocation,
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

  Future<RideVariablesRecord?> _fetchRideVariables() async {
    final docs = await queryRideVariablesRecordOnce(singleRecord: true);
    return docs.firstOrNull;
  }

  double _calculateFare(RideVariablesRecord variables) {
    return functions
        .calculatePrice(
          _model.placePickerValue1.latLng,
          _model.placePickerValue2.latLng,
          FFAppState().rideTier == 'Corporate'
              ? variables.corporateCostOfRide
              : variables.costOfRide,
          FFAppState().rideTier == 'Corporate'
              ? variables.corporateCostPerDistance
              : variables.costPerDistance,
          FFAppState().rideTier == 'Corporate'
              ? variables.corporateCostPerMinute
              : variables.costPerMinute,
        )
        .toDouble();
  }

  Future<void> _scheduleRide() async {
    if (_isSchedulingRide) return;
    if (!_canSchedule) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select pickup, destination, and a future time.'),
        ),
      );
      return;
    }

    if (currentUserReference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be signed in to schedule.')),
      );
      return;
    }

    safeSetState(() => _isSchedulingRide = true);
    try {
      final variables = await _fetchRideVariables();
      if (variables == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pricing configuration unavailable.')),
        );
        return;
      }

      final passenger = await queryPassengerRecordOnce(
        queryBuilder: (passengerRecord) =>
            passengerRecord.where('UserId', isEqualTo: currentUserReference),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      final rideFee = _calculateFare(variables);

      final rideReference = RideRecord.collection.doc();
      await rideReference.set(
        createRideRecordData(
          destinationLocation: _model.placePickerValue2.latLng,
          destinationAddress: _model.placePickerValue2.name.isNotEmpty
              ? _model.placePickerValue2.name
              : _model.placePickerValue2.address,
          isDriverAssigned: false,
          pickupLocation: _model.placePickerValue1.latLng,
          pickupAddress: _model.placePickerValue1.name.isNotEmpty
              ? _model.placePickerValue1.name
              : _model.placePickerValue1.address,
          userNumber: passenger?.mobileNumber,
          status: 'Active',
          rideFee: rideFee,
          rideType: 'Scheduled',
          scheduledTime: _model.datePicked,
          passengerId: currentUserReference,
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ride scheduled for ${_formatScheduleTime(_model.datePicked)}',
          ),
        ),
      );

      context.pushNamed(
        ScheduledRidesWidget.routeName,
        extra: <String, dynamic>{
          kTransitionInfoKey: const TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
          ),
        },
      );
    } finally {
      if (mounted) {
        safeSetState(() => _isSchedulingRide = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final effectiveLocation = currentUserLocationValue ?? _fallbackLocation;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        bottomNavigationBar: _canSchedule
            ? SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    border: Border(
                      top: BorderSide(color: theme.lineColor),
                    ),
                  ),
                  child: SizedBox(
                    height: 54,
                    child: FFButtonWidget(
                      onPressed:
                          !_isSchedulingRide ? _scheduleRide : null,
                      text: _isSchedulingRide
                          ? 'Scheduling...'
                          : 'Schedule Ride',
                      icon: const Icon(
                        Icons.directions_car_filled_rounded,
                        size: 18,
                      ),
                      options: FFButtonOptions(
                        height: 54,
                        color: !_isSchedulingRide
                            ? theme.primary
                            : theme.alternate.withValues(alpha: 0.55),
                        textStyle: theme.titleSmall.override(
                          fontFamily: theme.titleSmallFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          useGoogleFonts: !theme.titleSmallIsCustom,
                        ),
                        elevation: 6,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              )
            : null,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildMap(theme, effectiveLocation),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Row(
                        children: [
                          _buildCircleIconButton(
                            context,
                            icon: Icons.arrow_back_rounded,
                            onTap: () => context.safePop(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Schedule Ride',
                                  style: theme.titleLarge.override(
                                    fontFamily: theme.titleLargeFamily,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0,
                                    color: Colors.white,
                                    useGoogleFonts: !theme.titleLargeIsCustom,
                                  ),
                                ),
                                Text(
                                  'Book in advance with exact pickup timing',
                                  style: theme.bodySmall.override(
                                    fontFamily: theme.bodySmallFamily,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                    color: Colors.white.withValues(alpha: 0.92),
                                    useGoogleFonts: !theme.bodySmallIsCustom,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Plan with confidence',
                                    style: theme.labelSmall.override(
                                      fontFamily: theme.labelSmallFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0,
                                      useGoogleFonts: !theme.labelSmallIsCustom,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    bottom: 14,
                    child: _buildCircleIconButton(
                      context,
                      icon: Icons.near_me_rounded,
                      onTap: () => _recenterMap(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBottomPanel(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(FlutterFlowTheme theme, LatLng effectiveLocation) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF18253A),
                  Color(0xFF28466B),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlutterFlowGoogleMap(
            controller: _model.googleMapsController,
            onMapReady: () {
              if (!_isMapReady && mounted) {
                safeSetState(() => _isMapReady = true);
              }
            },
            onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
            initialLocation: _model.googleMapsCenter ??= effectiveLocation,
            markers: [
              FlutterFlowMarker('current_user_marker', effectiveLocation),
              ...FFAppState().testMarkers.map(
                (marker) => FlutterFlowMarker(marker.serialize(), marker),
              ),
            ],
            markerImage: const MarkerImage(
              imagePath: 'assets/images/Car-tow.png',
              isAssetImage: true,
              size: 34,
            ),
            mapType: MapType.normal,
            style: GoogleMapStyle.standard,
            initialZoom: 14,
            allowInteraction: true,
            allowZoom: true,
            showZoomControls: false,
            showLocation: true,
            showCompass: false,
            showMapToolbar: false,
            showTraffic: false,
            centerMapOnMarkerTap: false,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: _isMapReady ? 0.0 : 1.0,
              child: Container(
                color: const Color(0xFF28466B),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.transparent,
                    theme.primaryBackground.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPanel(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Plan your future ride',
                style: theme.titleLarge.override(
                  fontFamily: theme.titleLargeFamily,
                  color: theme.primaryText,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.titleLargeIsCustom,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose pickup, destination, and exact departure time.',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodySmallIsCustom,
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Ride Type'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _RideTierChip(
                      title: 'Car Tow',
                      selected: FFAppState().rideTier != 'Corporate',
                      onTap: () {
                        FFAppState().rideTier = 'Basic';
                        FFAppState().update(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RideTierChip(
                      title: 'Truck Tow',
                      selected: FFAppState().rideTier == 'Corporate',
                      onTap: () {
                        FFAppState().rideTier = 'Corporate';
                        FFAppState().update(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildLabel('Pickup Point'),
              const SizedBox(height: 6),
              _buildInputShell(
                theme: theme,
                child: FlutterFlowPlacePicker(
                  iOSGoogleMapsApiKey: kGoogleMapsApiKeyIOS,
                  androidGoogleMapsApiKey: kGoogleMapsApiKeyAndroid,
                  webGoogleMapsApiKey: kGoogleMapsApiKeyWeb,
                  onSelect: (place) {
                    safeSetState(() => _model.placePickerValue1 = place);
                  },
                  defaultText: context.tr('select_pickup_point'),
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: theme.secondaryText,
                    size: 20,
                  ),
                  buttonOptions: FFButtonOptions(
                    height: 56,
                    color: Colors.transparent,
                    textStyle: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodyMediumIsCustom,
                    ),
                    elevation: 0,
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildLabel('Destination'),
              const SizedBox(height: 6),
              _buildInputShell(
                theme: theme,
                child: FlutterFlowPlacePicker(
                  iOSGoogleMapsApiKey: kGoogleMapsApiKeyIOS,
                  androidGoogleMapsApiKey: kGoogleMapsApiKeyAndroid,
                  webGoogleMapsApiKey: kGoogleMapsApiKeyWeb,
                  onSelect: (place) {
                    safeSetState(() => _model.placePickerValue2 = place);
                  },
                  defaultText: context.tr('select_destination'),
                  icon: Icon(
                    Icons.flag_rounded,
                    color: theme.secondaryText,
                    size: 20,
                  ),
                  buttonOptions: FFButtonOptions(
                    height: 56,
                    color: Colors.transparent,
                    textStyle: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodyMediumIsCustom,
                    ),
                    elevation: 0,
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildLabel('Pickup Time'),
              const SizedBox(height: 6),
              _buildInputShell(
                theme: theme,
                child: SizedBox(
                  width: double.infinity,
                  child: FFButtonWidget(
                    onPressed: _pickScheduleDateTime,
                    text: _formatScheduleTime(_model.datePicked),
                    icon: const Icon(Icons.schedule_rounded, size: 18),
                    options: FFButtonOptions(
                      height: 56,
                      color: Colors.transparent,
                      textStyle: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      elevation: 0,
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _QuickTimeChip(
                    label: 'In 30 mins',
                    onTap: () =>
                        _setQuickTime(DateTime.now().add(const Duration(minutes: 30))),
                    selected: _model.datePicked != null &&
                        _model.datePicked!.difference(DateTime.now()).inMinutes
                            .abs() <=
                        32,
                  ),
                  _QuickTimeChip(
                    label: 'Tonight 8:00 PM',
                    onTap: () {
                      final now = DateTime.now();
                      _setQuickTime(DateTime(now.year, now.month, now.day, 20, 0)
                          .isAfter(now)
                          ? DateTime(now.year, now.month, now.day, 20, 0)
                          : DateTime(now.year, now.month, now.day + 1, 20, 0));
                    },
                    selected: false,
                  ),
                  _QuickTimeChip(
                    label: 'Tomorrow 8:00 AM',
                    onTap: () {
                      final now = DateTime.now();
                      _setQuickTime(
                        DateTime(now.year, now.month, now.day + 1, 8, 0),
                      );
                    },
                    selected: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFareCard(theme),
              const SizedBox(height: 12),
              Text(
                _canSchedule
                    ? 'All details captured. Use the button below to schedule your ride.'
                    : 'Complete pickup, destination, and pickup time to enable scheduling.',
                style: theme.labelSmall.override(
                  fontFamily: theme.labelSmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.labelSmallIsCustom,
                  ),
                ),
              const SizedBox(height: 8),
              if (_hasScheduleTime && !_isFutureTime)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Selected time must be in the future.',
                    style: theme.bodySmall.override(
                      fontFamily: theme.bodySmallFamily,
                      color: theme.error,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !theme.bodySmallIsCustom,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFareCard(FlutterFlowTheme theme) {
    if (!_hasPickup || !_hasDestination) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.lineColor),
        ),
        child: Text(
          'Add pickup and destination to view fare estimate.',
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.secondaryText,
            letterSpacing: 0,
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
        ),
      );
    }

    return StreamBuilder<List<RideVariablesRecord>>(
      stream: queryRideVariablesRecord(singleRecord: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.lineColor),
            ),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        }

        final variables = snapshot.data!.firstOrNull;
        if (variables == null) {
          return const SizedBox.shrink();
        }

        final fare = formatNumber(
          _calculateFare(variables),
          formatType: FormatType.decimal,
          decimalType: DecimalType.periodDecimal,
          currency: getCurrentCurrencySymbol(),
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primary.withValues(alpha: 0.09),
                theme.secondary.withValues(alpha: 0.09),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.primary.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('estimated_fare'),
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.secondaryText,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
              Text(
                fare,
                style: theme.titleLarge.override(
                  fontFamily: theme.titleLargeFamily,
                  color: theme.primaryText,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.titleLargeIsCustom,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    final theme = FlutterFlowTheme.of(context);
    return Text(
      text,
      style: theme.labelMedium.override(
        fontFamily: theme.labelMediumFamily,
        color: theme.secondaryText,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        useGoogleFonts: !theme.labelMediumIsCustom,
      ),
    );
  }

  Widget _buildInputShell({
    required FlutterFlowTheme theme,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCircleIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: theme.primaryText, size: 21),
        ),
      ),
    );
  }
}

class _QuickTimeChip extends StatelessWidget {
  const _QuickTimeChip({
    required this.label,
    required this.onTap,
    required this.selected,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.primary.withValues(alpha: 0.14)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? theme.primary : theme.lineColor,
          ),
        ),
        child: Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: theme.bodySmallFamily,
            color: selected ? theme.primary : theme.primaryText,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            useGoogleFonts: !theme.bodySmallIsCustom,
          ),
        ),
      ),
    );
  }
}

class _RideTierChip extends StatelessWidget {
  const _RideTierChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? theme.primary : theme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.transparent : theme.lineColor,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: theme.bodyMedium.override(
              fontFamily: theme.bodyMediumFamily,
              color: selected ? Colors.white : theme.primaryText,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              useGoogleFonts: !theme.bodyMediumIsCustom,
            ),
          ),
        ),
      ),
    );
  }
}
