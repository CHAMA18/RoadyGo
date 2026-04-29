import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:flutter/material.dart';
import 'scheduled_rides_model.dart';
export 'scheduled_rides_model.dart';

class ScheduledRidesWidget extends StatefulWidget {
  const ScheduledRidesWidget({super.key});

  static String routeName = 'ScheduledRides';
  static String routePath = '/scheduledRides';

  @override
  State<ScheduledRidesWidget> createState() => _ScheduledRidesWidgetState();
}

class _ScheduledRidesWidgetState extends State<ScheduledRidesWidget> {
  late ScheduledRidesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScheduledRidesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  bool _isTerminalRide(RideRecord ride) {
    final status = ride.status.trim().toLowerCase();
    return status == 'completed' ||
        status == 'canceled' ||
        status == 'cancelled';
  }

  String _formatLocation(String address, LatLng? coordinate, String fallback) {
    final trimmed = address.trim();
    if (trimmed.isNotEmpty) return trimmed;
    if (coordinate == null) return fallback;
    return 'Lat ${coordinate.latitude.toStringAsFixed(5)}, Lng ${coordinate.longitude.toStringAsFixed(5)}';
  }

  String _formatScheduledTime(DateTime? scheduledTime) {
    if (scheduledTime == null) return context.tr('time_not_set');
    return dateTimeFormat('MMM d, yyyy • h:mm a', scheduledTime);
  }

  List<RideRecord> _upcomingScheduledRides(List<RideRecord> rides) {
    final now = DateTime.now();
    final filtered = rides.where((ride) {
      final scheduledTime = ride.scheduledTime;
      if (scheduledTime == null) return false;
      if (_isTerminalRide(ride)) return false;
      return !scheduledTime.isBefore(now);
    }).toList()
      ..sort((a, b) => a.scheduledTime!.compareTo(b.scheduledTime!));
    return filtered;
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  color: theme.primary,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('my_scheduled_rides'),
                textAlign: TextAlign.center,
                style: theme.titleLarge.override(
                  fontFamily: theme.titleLargeFamily,
                  color: theme.primaryText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.titleLargeIsCustom,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('scheduled_rides_sub'),
                textAlign: TextAlign.center,
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.secondaryText,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelScheduledRide(RideRecord ride) async {
    final confirmDialogResponse = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text(context.tr('cancel_ride')),
              content: Text(context.tr('cancel_ride_q')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, false),
                  child: Text(context.tr('cancel')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, true),
                  child: Text(context.tr('confirm')),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmDialogResponse) return;

    try {
      await ride.reference.update(createRideRecordData(
        status: 'Canceled',
        isDriverAssigned: false,
      ));

      if (FFAppState().starteRide == ride.reference) {
        FFAppState().starteRide = null;
      }
    } catch (e) {
      debugPrint('Failed to cancel scheduled ride: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('cancel_ride_q')),
        ),
      );
    }
  }

  Widget _buildCancelButton(FlutterFlowTheme theme, RideRecord ride) {
    return FFButtonWidget(
      onPressed: () => _cancelScheduledRide(ride),
      text: context.tr('cancel'),
      options: FFButtonOptions(
        height: 34.0,
        padding: const EdgeInsetsDirectional.fromSTEB(
          14.0,
          0.0,
          14.0,
          0.0,
        ),
        color: theme.primaryBackground,
        textStyle: theme.titleSmall.override(
          fontFamily: theme.titleSmallFamily,
          color: theme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          useGoogleFonts: !theme.titleSmallIsCustom,
        ),
        elevation: 0.0,
        borderSide: BorderSide(
          color: theme.primary.withValues(alpha: 0.45),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(999.0),
      ),
    );
  }

  Widget _buildScheduledRideCard(FlutterFlowTheme theme, RideRecord ride) {
    final pickup = _formatLocation(
      ride.pickupAddress,
      ride.pickupLocation,
      context.tr('pickup_not_set'),
    );
    final destination = _formatLocation(
      ride.destinationAddress,
      ride.destinationLocation,
      context.tr('destination_not_set'),
    );
    final status = ride.status.trim().isNotEmpty
        ? ride.status.trim()
        : context.tr('status_label');
    final hasAssignedDriver = ride.driverName.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(18.0),
        onTap: () async {
          context.pushNamed(
            RideDetailsWidget.routeName,
            queryParameters: {
              'rideref': serializeParam(
                ride.reference,
                ParamType.DocumentReference,
              ),
            }.withoutNulls,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 18.0,
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.22
                      : 0.06,
                ),
                offset: const Offset(0.0, 8.0),
              )
            ],
            border: Border.all(
              color: theme.lineColor.withValues(alpha: 0.75),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        status,
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          useGoogleFonts: !theme.labelSmallIsCustom,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatScheduledTime(ride.scheduledTime),
                      style: theme.labelMedium.override(
                        fontFamily: theme.labelMediumFamily,
                        color: theme.secondaryText,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.labelMediumIsCustom,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RideLocationLine(
                  icon: Icons.my_location_rounded,
                  label: context.tr('pickup_point'),
                  value: pickup,
                  color: theme.primary,
                ),
                const SizedBox(height: 10),
                _RideLocationLine(
                  icon: Icons.outlined_flag_rounded,
                  label: context.tr('destination'),
                  value: destination,
                  color: theme.secondary,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: theme.secondaryText,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${context.tr('ride_fee')}: ${formatNumber(
                        ride.rideFee,
                        formatType: FormatType.decimal,
                        decimalType: DecimalType.periodDecimal,
                        currency: getCurrentCurrencySymbol(),
                      )}',
                      style: theme.bodySmall.override(
                        fontFamily: theme.bodySmallFamily,
                        color: theme.secondaryText,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.bodySmallIsCustom,
                      ),
                    ),
                    const Spacer(),
                    if (hasAssignedDriver)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              currentUserLocationValue =
                                  await getCurrentUserLocation(
                                defaultLocation: LatLng(0.0, 0.0),
                              );

                              await ride.reference.update(createRideRecordData(
                                driverLocation: currentUserLocationValue,
                              ));

                              context.goNamed(
                                FindingRideWidget.routeName,
                                queryParameters: {
                                  'rideDetails': serializeParam(
                                    ride.reference,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            text: context.tr('start_ride'),
                            options: FFButtonOptions(
                              height: 34.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0,
                                0.0,
                                16.0,
                                0.0,
                              ),
                              color: theme.primary,
                              textStyle: theme.titleSmall.override(
                                fontFamily: theme.titleSmallFamily,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.0,
                                useGoogleFonts: !theme.titleSmallIsCustom,
                              ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                          ),
                          _buildCancelButton(theme, ride),
                        ].divide(const SizedBox(width: 8)),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pending driver',
                            style: theme.labelMedium.override(
                              fontFamily: theme.labelMediumFamily,
                              color: theme.secondaryText,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                              useGoogleFonts: !theme.labelMediumIsCustom,
                            ),
                          ),
                          _buildCancelButton(theme, ride),
                        ].divide(const SizedBox(width: 10)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(PassengerDetailsWidget.routeName);
            },
          ),
          title: Text(
            context.tr('my_scheduled_rides'),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<List<RideRecord>>(
                stream: queryRideRecord(
                  queryBuilder: (rideRecord) => rideRecord
                      .where(
                        'PassengerId',
                        isEqualTo: currentUserReference,
                      )
                      .where(
                        'ride_type',
                        isEqualTo: 'Scheduled',
                      )
                      .orderBy('scheduled_time'),
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
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
                  final listViewRideRecordList =
                      _upcomingScheduledRides(snapshot.data!);

                  if (listViewRideRecordList.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                      scrollDirection: Axis.vertical,
                      itemCount: listViewRideRecordList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewRideRecord =
                            listViewRideRecordList[listViewIndex];
                        return _buildScheduledRideCard(
                          theme,
                          listViewRideRecord,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RideLocationLine extends StatelessWidget {
  const _RideLocationLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.labelSmall.override(
                  fontFamily: theme.labelSmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.labelSmallIsCustom,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.primaryText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
