import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps_flutter;

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/components/destination_picker/destination_picker_widget.dart';
import '/l10n/roadygo_i18n.dart';
import 'home_page_model.dart';

export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with SingleTickerProviderStateMixin {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final hasLocation = currentUserLocationValue != null;
    final effectiveLocation =
        currentUserLocationValue ?? const LatLng(0.0, 0.0);

    final theme = FlutterFlowTheme.of(context);
    final primaryColor = const Color(0xFFFF6B6B);
    final surfaceColor = theme.secondaryBackground;
    final inputBg = theme.primaryBackground;
    final borderColor = theme.lineColor;
    final textPrimary = theme.primaryText;
    final textSecondary = theme.secondaryText;

    if (kIsWeb) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildTopBar(
                  context,
                  theme,
                  primaryColor,
                  textSecondary,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: _buildMap(
                  theme: theme,
                  primaryColor: primaryColor,
                  hasLocation: hasLocation,
                  effectiveLocation: effectiveLocation,
                  showLocationMarker: false,
                ),
              ),
              Expanded(
                child: _buildBottomSheetContainer(
                  context: context,
                  theme: theme,
                  primaryColor: primaryColor,
                  surfaceColor: surfaceColor,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  minHeight: null,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // Map Background (top 55%)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: _buildMap(
                theme: theme,
                primaryColor: primaryColor,
                hasLocation: hasLocation,
                effectiveLocation: effectiveLocation,
                showLocationMarker: true,
              ),
            ),

            // Top Bar with Menu and Profile
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildTopBar(
                  context,
                  theme,
                  primaryColor,
                  textSecondary,
                ),
              ),
            ),

            // Near Me Button
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.50 + 20,
              right: 20,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.near_me,
                    color: primaryColor,
                    size: 24,
                  ),
                  onPressed: () async {
                    final loc = await getCurrentUserLocation(
                      defaultLocation: LatLng(0.0, 0.0),
                      cached: false,
                    );
                    final controller = await _model.googleMapsController.future;
                    controller.animateCamera(
                      CameraUpdate.newLatLng(
                        google_maps_flutter.LatLng(loc.latitude, loc.longitude),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Go to Active Ride Button
            if (FFAppState().starteRide != null)
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.50 + 80,
                right: 20,
                child: GestureDetector(
                  onTap: () {
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
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_car_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr('go_to_ride'),
                          style: theme.bodySmall.override(
                            fontFamily: theme.bodySmallFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                            useGoogleFonts: !theme.bodySmallIsCustom,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom Sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomSheetContainer(
                context: context,
                theme: theme,
                primaryColor: primaryColor,
                surfaceColor: surfaceColor,
                inputBg: inputBg,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                minHeight: MediaQuery.of(context).size.height * 0.50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    FlutterFlowTheme theme,
    Color primaryColor,
    Color textSecondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu Button
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: textSecondary,
              size: 22,
            ),
            onPressed: () {
              // Open menu/drawer
            },
          ),
        ),
        // Profile Button
        GestureDetector(
          onTap: () => context.pushNamed(ProfilePageWidget.routeName),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  context.tr('profile'),
                  style: theme.bodyMedium.override(
                    fontFamily: theme.bodyMediumFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    useGoogleFonts: !theme.bodyMediumIsCustom,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap({
    required FlutterFlowTheme theme,
    required Color primaryColor,
    required bool hasLocation,
    required LatLng effectiveLocation,
    required bool showLocationMarker,
  }) {
    return Stack(
      children: [
        // Map background - shows while map is loading
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFE8F4E8), // Light green map-like background
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr('loading_map'),
                  style: TextStyle(
                    color: theme.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Google Map
        Positioned.fill(
          child: FlutterFlowGoogleMap(
          controller: _model.googleMapsController,
          onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
          initialLocation: _model.googleMapsCenter ?? effectiveLocation,
          markers: FFAppState()
              .testMarkers
              .where((e) => FFAppState().testMarkers.contains(e))
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
          showLocation: hasLocation,
          showCompass: false,
          showMapToolbar: false,
          showTraffic: false,
          centerMapOnMarkerTap: false,
        ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.primaryBackground.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showLocationMarker)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 64 * _pulseAnimation.value,
                    height: 64 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomSheetContainer({
    required BuildContext context,
    required FlutterFlowTheme theme,
    required Color primaryColor,
    required Color surfaceColor,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required double? minHeight,
  }) {
    return Container(
      constraints: minHeight == null
          ? const BoxConstraints()
          : BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.alternate,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    context.tr('where_are_you_going_q'),
                    style: theme.headlineSmall.override(
                      fontFamily: theme.headlineSmallFamily,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.headlineSmallIsCustom,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pickup Point
                  _buildInputSection(
                    context: context,
                    label: context.tr('pickup_point'),
                    child: FlutterFlowPlacePicker(
                      iOSGoogleMapsApiKey: kGoogleMapsApiKeyIOS,
                      androidGoogleMapsApiKey: kGoogleMapsApiKeyAndroid,
                      webGoogleMapsApiKey: kGoogleMapsApiKeyWeb,
                      onSelect: (place) async {
                        safeSetState(() => _model.placePickerValue1 = place);
                      },
                      defaultText: context.tr('select_pickup_point'),
                      icon: Icon(
                        Icons.location_on,
                        color: textSecondary,
                        size: 22,
                      ),
                      buttonOptions: FFButtonOptions(
                        height: 56,
                        color: inputBg,
                        textStyle: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          color: textPrimary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          useGoogleFonts: !theme.bodyMediumIsCustom,
                        ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Destination
                  _buildInputSection(
                    context: context,
                    label: context.tr('destination'),
                    child: _DestinationPickerButton(
                      selectedPlace: _model.placePickerValue2,
                      currentLocation: currentUserLocationValue,
                      onSelect: (place) {
                        safeSetState(() => _model.placePickerValue2 = place);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ride Type
                  Text(
                    context.tr('ride_type'),
                    style: theme.titleMedium.override(
                      fontFamily: theme.titleMediumFamily,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.titleMediumIsCustom,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _RideTypeCard(
                          title: context.tr('basic'),
                          imagePath: 'assets/images/Truck.png',
                          isSelected: FFAppState().rideTier == 'Basic',
                          primaryColor: primaryColor,
                          onTap: () {
                            FFAppState().rideTier = 'Basic';
                            FFAppState().update(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _RideTypeCard(
                          title: context.tr('corporate'),
                          imagePath: 'assets/images/Truck-2.png',
                          isSelected: FFAppState().rideTier == 'Corporate',
                          primaryColor: primaryColor,
                          onTap: () {
                            FFAppState().rideTier = 'Corporate';
                            safeSetState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Confirm Booking Button
                  if (_model.placePickerValue2.address != '' &&
                      _model.placePickerValue1.address != '')
                    _buildRideFeeAndButton(context, primaryColor),

                  // Simple Confirm Button (when not all fields filled)
                  if (_model.placePickerValue2.address == '' ||
                      _model.placePickerValue1.address == '')
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F2937),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('confirm_booking'),
                              style: theme.titleSmall.override(
                                fontFamily: theme.titleSmallFamily,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                useGoogleFonts: !theme.titleSmallIsCustom,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: theme.labelSmall.override(
              fontFamily: theme.labelSmallFamily,
              color: theme.secondaryText,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              useGoogleFonts: !theme.labelSmallIsCustom,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildRideFeeAndButton(BuildContext context, Color primaryColor) {
    final theme = FlutterFlowTheme.of(context);

    return StreamBuilder<List<RideVariablesRecord>>(
      stream: queryRideVariablesRecord(singleRecord: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          );
        }

        final rideVariablesRecord =
            snapshot.data!.isNotEmpty ? snapshot.data!.first : null;

        if (rideVariablesRecord == null) {
          return const SizedBox.shrink();
        }

        final price = formatNumber(
          functions.calculatePrice(
            _model.placePickerValue1.latLng,
            _model.placePickerValue2.latLng,
            () {
              if (FFAppState().rideTier == 'Basic') {
                return rideVariablesRecord.costOfRide;
              } else if (FFAppState().rideTier == 'Corporate') {
                return rideVariablesRecord.corporateCostOfRide;
              } else {
                return rideVariablesRecord.costOfRide;
              }
            }(),
            () {
              if (FFAppState().rideTier == 'Basic') {
                return rideVariablesRecord.costPerDistance;
              } else if (FFAppState().rideTier == 'Corporate') {
                return rideVariablesRecord.corporateCostPerDistance;
              } else {
                return rideVariablesRecord.costPerDistance;
              }
            }(),
            () {
              if (FFAppState().rideTier == 'Basic') {
                return rideVariablesRecord.costPerMinute;
              } else if (FFAppState().rideTier == 'Corporate') {
                return rideVariablesRecord.corporateCostPerMinute;
              } else {
                return rideVariablesRecord.costPerMinute;
              }
            }(),
          ),
          formatType: FormatType.decimal,
          decimalType: DecimalType.periodDecimal,
          currency: '\$',
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride Fee Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.lineColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      context.tr('estimated_fare'),
                      style: theme.bodyMedium.override(
                        fontFamily: theme.bodyMediumFamily,
                        color: theme.secondaryText,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.bodyMediumIsCustom,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    price,
                    style: theme.headlineSmall.override(
                      fontFamily: theme.headlineSmallFamily,
                      color: theme.primaryText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.headlineSmallIsCustom,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Booking Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    FindingRideWidget.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                      ),
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryText,
                  foregroundColor: theme.secondaryBackground,
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('confirm_booking'),
                      style: theme.titleSmall.override(
                        fontFamily: theme.titleSmallFamily,
                        color: theme.secondaryBackground,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.titleSmallIsCustom,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: theme.secondaryBackground,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Ride Type Selection Card
class _RideTypeCard extends StatelessWidget {
  const _RideTypeCard({
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  final String title;
  final String imagePath;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : theme.lineColor,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    color: isSelected ? null : null,
                    colorBlendMode: isSelected ? null : BlendMode.saturation,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.titleMedium.override(
                    fontFamily: theme.titleMediumFamily,
                    color: isSelected ? Colors.white : theme.secondaryText,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    useGoogleFonts: !theme.titleMediumIsCustom,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: primaryColor,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A beautiful destination picker button with animations
class _DestinationPickerButton extends StatefulWidget {
  const _DestinationPickerButton({
    required this.selectedPlace,
    required this.onSelect,
    this.currentLocation,
  });

  final FFPlace selectedPlace;
  final Function(FFPlace) onSelect;
  final LatLng? currentLocation;

  @override
  State<_DestinationPickerButton> createState() =>
      _DestinationPickerButtonState();
}

class _DestinationPickerButtonState extends State<_DestinationPickerButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _DestinationPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openDestinationPicker() {
    showDestinationPicker(
      context: context,
      onSelect: widget.onSelect,
      iOSGoogleMapsApiKey: kGoogleMapsApiKeyIOS,
      androidGoogleMapsApiKey: kGoogleMapsApiKeyAndroid,
      webGoogleMapsApiKey: kGoogleMapsApiKeyWeb,
      title: context.tr('where_to'),
      hintText: context.tr('search_destination'),
      currentLocation: widget.currentLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasDestination = widget.selectedPlace.address.isNotEmpty;
    const primaryColor = Color(0xFFFF6B6B);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _openDestinationPicker();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasDestination ? primaryColor : theme.lineColor,
              width: hasDestination ? 1.4 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.flag,
                  color: hasDestination ? primaryColor : theme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasDestination
                        ? (widget.selectedPlace.name.isNotEmpty
                            ? widget.selectedPlace.name
                            : widget.selectedPlace.address)
                        : context.tr('select_destination'),
                    style: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: hasDestination
                          ? theme.primaryText
                          : theme.secondaryText,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodyMediumIsCustom,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
