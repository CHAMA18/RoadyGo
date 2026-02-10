import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'passenger_details_model.dart';
export 'passenger_details_model.dart';

class PassengerDetailsWidget extends StatefulWidget {
  const PassengerDetailsWidget({super.key});

  static String routeName = 'PassengerDetails';
  static String routePath = '/passengerDetails';

  @override
  State<PassengerDetailsWidget> createState() => _PassengerDetailsWidgetState();
}

class _PassengerDetailsWidgetState extends State<PassengerDetailsWidget>
    with TickerProviderStateMixin {
  late PassengerDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerDetailsModel());

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'dividerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 100.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 100.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 100.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 100.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserReference == null) {
      // If we somehow got here without an authenticated user, return to auth.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.goNamed(AutWidget.routeName);
      });
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<PassengerRecord>>(
      stream: queryPassengerRecord(
        queryBuilder: (passengerRecord) => passengerRecord.where(
          'UserId',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
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
        List<PassengerRecord> passengerDetailsPassengerRecordList =
            snapshot.data!;
        final passengerDetailsPassengerRecord =
            passengerDetailsPassengerRecordList.isNotEmpty
                ? passengerDetailsPassengerRecordList.first
                : null;

        final displayName =
            (passengerDetailsPassengerRecord?.name.isNotEmpty == true)
                ? passengerDetailsPassengerRecord!.name
                : (currentUserDisplayName.isNotEmpty
                    ? currentUserDisplayName
                    : (currentUserEmail.isNotEmpty
                        ? currentUserEmail
                        : context.tr('user')));
        final displayEmail =
            (passengerDetailsPassengerRecord?.email.isNotEmpty == true)
                ? passengerDetailsPassengerRecord!.email
                : currentUserEmail;
        final displayPhotoUrl = currentUserPhoto;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  context.pushNamed(
                                      AuthHomePageWidget.routeName);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              Text(
                                context.tr('user_details'),
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleMediumFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleMediumIsCustom,
                                    ),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: displayPhotoUrl.isNotEmpty
                                      ? Image.network(
                                          displayPhotoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: Colors.white.withValues(
                                                alpha: 0.2),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 52,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.white.withValues(
                                              alpha: 0.2),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 52,
                                          ),
                                        ),
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      FlutterFlowTheme.of(context).secondaryBackground,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            displayName,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineSmallFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .headlineSmallIsCustom,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.place,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                passengerDetailsPassengerRecord?.location
                                                .isNotEmpty ==
                                            true
                                    ? passengerDetailsPassengerRecord!.location
                                    : context.tr('location_not_set'),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodySmallIsCustom,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            displayEmail.isNotEmpty ? displayEmail : ' ',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodySmallFamily,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  letterSpacing: 0.0,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .bodySmallIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        children: [
                          _ActionCard(
                            icon: Icons.edit,
                            title: context.tr('edit_profile'),
                            subtitle: context.tr('edit_profile_sub'),
                            onTap: () async {
                              context.pushNamed(EditProfileWidget.routeName);
                            },
                          ),
                          const SizedBox(height: 12),
                          _ActionCard(
                            icon: Icons.language_rounded,
                            title: context.tr('languages'),
                            subtitle: context.tr('languages_sub'),
                            onTap: () async {
                              final theme = FlutterFlowTheme.of(context);
                              final controller = TextEditingController();

                              Future<void> applyLanguage(String code) async {
                                FFAppState().setLanguageCode(code);
                                // Small UX win: close sheet after applying.
                                Navigator.pop(context);
                              }

                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (sheetContext) {
                                  final current =
                                      FFAppState().languageCode.isNotEmpty
                                          ? FFAppState().languageCode
                                          : 'en';

                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      final q = controller.text.trim()
                                          .toLowerCase();
                                      final items = RoadyGoI18n
                                          .europeanLanguages
                                          .where((e) =>
                                              q.isEmpty ||
                                              e.name
                                                  .toLowerCase()
                                                  .contains(q) ||
                                              e.code
                                                  .toLowerCase()
                                                  .contains(q))
                                          .toList();

                                      return SafeArea(
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 12),
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 12, 16, 16),
                                          decoration: BoxDecoration(
                                            color: theme.secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                    alpha: 0.25),
                                                blurRadius: 30,
                                                offset: const Offset(0, 12),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 44,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: theme.lineColor
                                                        .withValues(
                                                            alpha: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      context.tr(
                                                          'select_language'),
                                                      style: theme.titleMedium
                                                          .override(
                                                        fontFamily: theme
                                                            .titleMediumFamily,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: theme.primaryText,
                                                        useGoogleFonts: !theme
                                                            .titleMediumIsCustom,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            sheetContext),
                                                    icon: const Icon(
                                                        Icons.close_rounded),
                                                    color: theme.secondaryText,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: theme.primaryBackground
                                                      .withValues(alpha: 0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: theme.lineColor
                                                        .withValues(
                                                            alpha: 0.8),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.search_rounded,
                                                      color: theme.secondaryText
                                                          .withValues(
                                                              alpha: 0.8),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: TextField(
                                                        controller: controller,
                                                        onChanged: (_) =>
                                                            setModalState(() {}),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: context.tr(
                                                              'search_language'),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                context.tr('current_language'),
                                                style: theme.labelMedium
                                                    .override(
                                                  fontFamily: theme
                                                      .labelMediumFamily,
                                                  color: theme.secondaryText,
                                                  fontWeight: FontWeight.w700,
                                                  useGoogleFonts: !theme
                                                      .labelMediumIsCustom,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 380),
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: items.length,
                                                  separatorBuilder: (_, __) =>
                                                      const SizedBox(height: 8),
                                                  itemBuilder: (context, i) {
                                                    final item = items[i];
                                                    final selected =
                                                        item.code == current;
                                                    return InkWell(
                                                      onTap: () =>
                                                          applyLanguage(
                                                              item.code),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 14,
                                                          vertical: 12,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: selected
                                                              ? theme.primary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.10)
                                                              : theme
                                                                  .primaryBackground
                                                                  .withValues(
                                                                      alpha:
                                                                          0.55),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          border: Border.all(
                                                            color: selected
                                                                ? theme.primary
                                                                    .withValues(
                                                                        alpha:
                                                                            0.35)
                                                                : theme.lineColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.7),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 38,
                                                              height: 38,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: selected
                                                                    ? theme
                                                                        .primary
                                                                        .withValues(
                                                                            alpha:
                                                                                0.18)
                                                                    : theme
                                                                        .alternate
                                                                        .withValues(
                                                                            alpha:
                                                                                0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .translate_rounded,
                                                                color: selected
                                                                    ? theme
                                                                        .primary
                                                                    : theme
                                                                        .secondaryText,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    item.name,
                                                                    style: theme
                                                                        .bodyLarge
                                                                        .override(
                                                                      fontFamily:
                                                                          theme
                                                                              .bodyLargeFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: theme
                                                                          .primaryText,
                                                                      useGoogleFonts:
                                                                          !theme
                                                                              .bodyLargeIsCustom,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2),
                                                                  Text(
                                                                    item.code
                                                                        .toUpperCase(),
                                                                    style: theme
                                                                        .labelSmall
                                                                        .override(
                                                                      fontFamily:
                                                                          theme
                                                                              .labelSmallFamily,
                                                                      color: theme
                                                                          .secondaryText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      useGoogleFonts:
                                                                          !theme
                                                                              .labelSmallIsCustom,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            if (selected)
                                                              Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color:
                                                                    theme.primary,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _ActionCard(
                            icon: Icons.add_location_alt,
                            title: context.tr('add_scheduled_ride'),
                            subtitle: context.tr('add_scheduled_ride_sub'),
                            onTap: () async {
                              context.pushNamed(SchedulePageWidget.routeName);
                            },
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<int>(
                            future: queryRideRecordCount(
                              queryBuilder: (rideRecord) => rideRecord
                                  .where(
                                    'PassengerId',
                                    isEqualTo: currentUserReference,
                                  )
                                  .where(
                                    'ride_type',
                                    isEqualTo: 'Scheduled',
                                  ),
                            ),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              return _ActionCard(
                                icon: Icons.schedule,
                                title: context.tr('scheduled_rides'),
                                subtitle: context.tr('scheduled_rides_sub'),
                                badgeText: count > 0
                                    ? formatNumber(
                                        count,
                                        formatType: FormatType.compact,
                                      )
                                    : null,
                                onTap: () async {
                                  context.pushNamed(
                                      ScheduledRidesWidget.routeName);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _ActionCard(
                            icon: Icons.history,
                            title: context.tr('recent_rides'),
                            subtitle: context.tr('recent_rides_sub'),
                            onTap: () async {
                              context.pushNamed(RecentRidesWidget.routeName);
                            },
                          ),
                          const SizedBox(height: 24),
                          _ActionCard(
                            icon: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            title: 'Dark/Light Mode',
                            subtitle: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? context.tr('switch_to_light')
                                : context.tr('switch_to_dark'),
                            onTap: () async {
                              final isDark = Theme.of(context).brightness ==
                                  Brightness.dark;
                              setDarkModeSetting(
                                context,
                                isDark ? ThemeMode.light : ThemeMode.dark,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          InkWell(
                            onTap: () async {
                              final theme = FlutterFlowTheme.of(context);
                              final confirmed =
                                  await showModalBottomSheet<bool>(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SafeArea(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 14, 18, 18),
                                      decoration: BoxDecoration(
                                        color: theme.secondaryBackground,
                                        borderRadius: BorderRadius.circular(22),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                                alpha: 0.25),
                                            blurRadius: 30,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 44,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: theme.lineColor
                                                    .withValues(alpha: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Row(
                                            children: [
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEF4444)
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Icon(
                                                  Icons.logout_rounded,
                                                  color: Color(0xFFEF4444),
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      context.tr('log_out_q'),
                                                      // Keep localized copy for title; email line stays as-is.
                                                      style:
                                                          theme.titleMedium
                                                              .override(
                                                        fontFamily: theme
                                                            .titleMediumFamily,
                                                        color: theme.primaryText,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: !theme
                                                            .titleMediumIsCustom,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      currentUserEmail.isNotEmpty
                                                          ? 'Signed in as $currentUserEmail'
                                                          : 'You can sign back in anytime.',
                                                      style:
                                                          theme.bodySmall
                                                              .override(
                                                        fontFamily: theme
                                                            .bodySmallFamily,
                                                        color:
                                                            theme.secondaryText,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: !theme
                                                            .bodySmallIsCustom,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        theme.primaryText,
                                                    side: BorderSide(
                                                      color: theme.lineColor,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 14,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  child: Text(context.tr('cancel')),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFEF4444),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 14,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  child: Text(context.tr('log_out')),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (confirmed != true) return;

                              GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              GoRouter.of(context).clearRedirectLocation();
                              if (!context.mounted) return;
                              context.goNamed(AutWidget.routeName);
                            },
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground
                                    .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.25),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444)
                                        .withValues(alpha: 0.12),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    context.tr('log_out'),
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: const Color(0xFFEF4444),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleSmallIsCustom,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'App Version 2.4.0',
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelSmallFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText
                                      .withValues(alpha: 0.6),
                                  letterSpacing: 0.0,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .labelSmallIsCustom,
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
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.secondaryBackground.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.lineColor.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: theme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.bodyLarge.override(
                        fontFamily: theme.bodyLargeFamily,
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                        useGoogleFonts: !theme.bodyLargeIsCustom,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.labelSmall.override(
                        fontFamily: theme.labelSmallFamily,
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: !theme.labelSmallIsCustom,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText!,
                    style: theme.labelSmall.override(
                      fontFamily: theme.labelSmallFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.0,
                      useGoogleFonts: !theme.labelSmallIsCustom,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right,
                color: theme.secondaryText.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
