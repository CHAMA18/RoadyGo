import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:flutter/material.dart';
import 'recent_rides_model.dart';
export 'recent_rides_model.dart';

class RecentRidesWidget extends StatefulWidget {
  const RecentRidesWidget({super.key});

  static String routeName = 'RecentRides';
  static String routePath = '/recentRides';

  @override
  State<RecentRidesWidget> createState() => _RecentRidesWidgetState();
}

class _RecentRidesWidgetState extends State<RecentRidesWidget> {
  late RecentRidesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Color _statusColor(FlutterFlowTheme theme, String status) {
    final s = status.trim().toLowerCase();
    if (s == 'completed') return const Color(0xFF16A34A);
    if (s == 'cancelled' || s == 'canceled') return const Color(0xFFEF4444);
    if (s == 'pending' || s == 'scheduled') return const Color(0xFFF59E0B);
    if (s == 'ongoing' || s == 'in_progress' || s == 'in progress') {
      return const Color(0xFF2563EB);
    }
    return theme.secondaryText.withValues(alpha: 0.7);
  }

  String _formatRideTime(RideRecord ride) {
    final dt = ride.startTime ?? ride.scheduledTime;
    if (dt == null) return context.tr('time_not_set');
    return dateTimeFormat('MMM d, h:mm a', dt);
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: theme.alternate.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 40,
                color: theme.secondaryText.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.tr('no_rides_yet'),
              style: theme.headlineMedium.override(
                fontFamily: theme.headlineMediumFamily,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                useGoogleFonts: !theme.headlineMediumIsCustom,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('no_rides_desc'),
              style: theme.bodyMedium.override(
                fontFamily: theme.bodyMediumFamily,
                color: theme.secondaryText,
                lineHeight: 1.4,
                useGoogleFonts: !theme.bodyMediumIsCustom,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 180,
              height: 46,
              child: ElevatedButton(
                onPressed: () => context.goNamed(AuthHomePageWidget.routeName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(context.tr('book_a_ride')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard(FlutterFlowTheme theme, RideRecord ride) {
    final statusColor = _statusColor(theme, ride.status);
    final isScheduled = ride.rideType.trim().toLowerCase() == 'scheduled';
    final pickup = ride.pickupAddress.trim().isNotEmpty
        ? ride.pickupAddress.trim()
        : context.tr('pickup_not_set');
    final destination = ride.destinationAddress.trim().isNotEmpty
        ? ride.destinationAddress.trim()
        : context.tr('destination_not_set');
    final fee = ride.rideFee;

    return InkWell(
      onTap: () => context.pushNamed(
        RideDetailsWidget.routeName,
        queryParameters: {
          'rideref': serializeParam(
            ride.reference,
            ParamType.DocumentReference,
          ),
        }.withoutNulls,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.lineColor.withValues(alpha: 0.75),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ride.status.isNotEmpty
                            ? ride.status
                            : context.tr('status_label'),
                        style: theme.labelMedium.override(
                          fontFamily: theme.labelMediumFamily,
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          useGoogleFonts: !theme.labelMediumIsCustom,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatRideTime(ride),
                  style: theme.labelSmall.override(
                    fontFamily: theme.labelSmallFamily,
                    color: theme.secondaryText,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: !theme.labelSmallIsCustom,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 28,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.lineColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickup,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyLarge.override(
                          fontFamily: theme.bodyLargeFamily,
                          fontWeight: FontWeight.w700,
                          useGoogleFonts: !theme.bodyLargeIsCustom,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          color: theme.secondaryText,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: !theme.bodyMediumIsCustom,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (fee > 0)
                      Text(
                        formatNumber(
                          fee,
                          formatType: FormatType.decimal,
                          decimalType: DecimalType.periodDecimal,
                        ),
                        style: theme.titleSmall.override(
                          fontFamily: theme.titleSmallFamily,
                          fontWeight: FontWeight.w800,
                          useGoogleFonts: !theme.titleSmallIsCustom,
                        ),
                      )
                    else
                      Text(
                        ' ',
                        style: theme.titleSmall.override(
                          fontFamily: theme.titleSmallFamily,
                          useGoogleFonts: !theme.titleSmallIsCustom,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.alternate.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isScheduled
                            ? context.tr('scheduled')
                            : context.tr('instant'),
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.primaryText.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w700,
                          useGoogleFonts: !theme.labelSmallIsCustom,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecentRidesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const headerA = Color(0xFFE53935);
    const headerB = Color(0xFFFF6B6B);

    if (currentUserReference == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.goNamed(AutWidget.routeName);
      });
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: headerA,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => context.safePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: Colors.white,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsetsDirectional.only(start: 56, bottom: 14),
                  title: Text(
                    context.tr('my_recent_rides'),
                    style: theme.headlineSmall.override(
                      fontFamily: theme.headlineSmallFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      useGoogleFonts: !theme.headlineSmallIsCustom,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [headerA, headerB],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -40,
                          right: -30,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          left: -30,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    context.tr('trips_realtime_desc'),
                    style: theme.bodyMedium.override(
                      fontFamily: theme.bodyMediumFamily,
                      color: theme.secondaryText,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !theme.bodyMediumIsCustom,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: StreamBuilder<List<RideRecord>>(
                    stream: queryRideRecord(
                      queryBuilder: (rideRecord) => rideRecord
                          .where(
                            'PassengerId',
                            isEqualTo: currentUserReference,
                          )
                          // Most stable query: one equality + one order.
                          .orderBy('scheduled_time', descending: true),
                      limit: 50,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Center(
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final rides = snapshot.data!;
                      if (rides.isEmpty) {
                        return _buildEmptyState(theme);
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rides.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _buildRideCard(theme, rides[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
