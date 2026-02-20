import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'profile_page_model.dart';

export 'profile_page_model.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _attemptedLocationResolve = false;
  bool _resolvingLocation = false;
  String? _resolvedLocationLabel;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveCurrentLocationLabel();
    });
  }

  String _mapsKey() {
    if (isWeb) return kGoogleMapsApiKeyWeb;
    if (isAndroid) return kGoogleMapsApiKeyAndroid;
    if (isiOS) return kGoogleMapsApiKeyIOS;
    return kGoogleMapsApiKeyWeb;
  }

  Future<String?> _reverseGeocode(LatLng latLng) async {
    final key = _mapsKey();
    if (key.isEmpty) return null;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${latLng.latitude},${latLng.longitude}',
        'key': key,
        'language': FFAppState().languageCode,
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['status'] != 'OK') return null;

    final results = (body['results'] as List?) ?? const [];
    if (results.isEmpty) return null;
    final first = results.first as Map<String, dynamic>;

    final comps = (first['address_components'] as List?) ?? const [];
    String? city;
    String? region;
    String? country;
    for (final c in comps) {
      final m = c as Map<String, dynamic>;
      final types = (m['types'] as List?)?.cast<String>() ?? const [];
      final longName = m['long_name'] as String?;
      if (longName == null || longName.isEmpty) continue;
      if (city == null &&
          (types.contains('locality') ||
              types.contains('postal_town') ||
              types.contains('sublocality'))) {
        city = longName;
      }
      if (region == null && types.contains('administrative_area_level_1')) {
        region = longName;
      }
      if (country == null && types.contains('country')) {
        country = longName;
      }
    }

    final parts = <String>[
      if (city != null) city,
      if (region != null && region != city) region,
      if (country != null) country,
    ];
    if (parts.isNotEmpty) return parts.join(', ');

    final formatted = first['formatted_address'] as String?;
    return (formatted != null && formatted.isNotEmpty) ? formatted : null;
  }

  Future<void> _resolveCurrentLocationLabel() async {
    if (_attemptedLocationResolve) return;
    _attemptedLocationResolve = true;

    if (mounted) {
      setState(() => _resolvingLocation = true);
    }
    try {
      final loc = await getCurrentUserLocation(
        defaultLocation: const LatLng(0.0, 0.0),
        cached: false,
      );
      if (!mounted) return;

      if (loc.latitude == 0.0 && loc.longitude == 0.0) {
        setState(() => _resolvedLocationLabel = null);
        return;
      }

      final label = await _reverseGeocode(loc);
      if (!mounted) return;

      final fallback =
          'Lat ${loc.latitude.toStringAsFixed(5)}, Lng ${loc.longitude.toStringAsFixed(5)}';
      setState(() => _resolvedLocationLabel = (label?.isNotEmpty ?? false)
          ? label
          : fallback);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().toLowerCase();
      if (msg.contains('permissions') || msg.contains('denied')) {
        setState(
          () => _resolvedLocationLabel = context.tr('location_permission_denied'),
        );
      } else if (msg.contains('services are disabled')) {
        setState(
          () => _resolvedLocationLabel = context.tr('location_services_disabled'),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _resolvingLocation = false);
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const primaryColor = Color(0xFFFF6B6B);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF3F4F6),
        body: Stack(
          children: [
            // Gradient Header (45% height)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8787),
                      Color(0xFFFF5252),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                    bottomRight: Radius.circular(48),
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative Blurs
                    Positioned(
                      top: -40,
                      left: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Column(
                        children: [
                          // Top Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Back Button
                                _GlassButton(
                                  icon: Icons.arrow_back_ios_new,
                                  onTap: () => context.safePop(),
                                ),
                                // Title
                                Text(
                                  context.tr('profile'),
                                  style: theme.titleMedium.override(
                                    fontFamily: theme.titleMediumFamily,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    useGoogleFonts: !theme.titleMediumIsCustom,
                                  ),
                                ),
                                const SizedBox(width: 40, height: 40),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Profile Picture and Info
                          AuthUserStreamWidget(
                            builder: (context) =>
                                StreamBuilder<List<PassengerRecord>>(
                              stream: queryPassengerRecord(
                                queryBuilder: (passengerRecord) =>
                                    passengerRecord.where(
                                  'email',
                                  isEqualTo: currentUserEmail,
                                ),
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  final loadingLocation = _resolvingLocation
                                      ? context.tr('fetching_location')
                                      : (_resolvedLocationLabel ??
                                          context.tr('location_not_set'));
                                  return _buildProfileHeader(
                                    context,
                                    theme,
                                    currentUserDisplayName.isNotEmpty
                                        ? currentUserDisplayName
                                        : (currentUserEmail.isNotEmpty
                                            ? currentUserEmail
                                            : context.tr('loading')),
                                    currentUserPhoto,
                                    loadingLocation,
                                  );
                                }
                                final passenger =
                                    snapshot.data?.isNotEmpty == true
                                        ? snapshot.data!.first
                                        : null;
                                // Priority: PassengerRecord name > Firebase displayName > email > 'User'
                                String displayName = passenger?.name ?? '';
                                if (displayName.isEmpty) {
                                  displayName = currentUserDisplayName;
                                }
                                if (displayName.isEmpty) {
                                  displayName = currentUserEmail;
                                }
                                if (displayName.isEmpty) {
                                  displayName = context.tr('user');
                                }
                                final persistedLocation = passenger
                                                ?.location
                                                .trim()
                                                .isNotEmpty ==
                                            true
                                    ? passenger!.location.trim()
                                    : null;
                                final userLocation = _resolvingLocation
                                    ? context.tr('fetching_location')
                                    : (_resolvedLocationLabel ??
                                        persistedLocation ??
                                        context.tr('location_not_set'));
                                return _buildProfileHeader(
                                  context,
                                  theme,
                                  displayName,
                                  currentUserPhoto,
                                  userLocation,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.62,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                        child: Column(
                          children: [
                            // Stats Grid
                            _buildStatsGrid(context, theme),
                            const SizedBox(height: 24),
                            // Section moved from Passenger Details into Profile.
                            _buildActionCard(
                              context,
                              theme,
                              icon: Icons.edit,
                              title: context.tr('edit_profile'),
                              subtitle: context.tr('edit_profile_sub'),
                              onTap: () =>
                                  context.pushNamed(EditProfileWidget.routeName),
                            ),
                            const SizedBox(height: 12),
                            _buildActionCard(
                              context,
                              theme,
                              icon: Icons.language_rounded,
                              title: context.tr('languages'),
                              subtitle: context.tr('languages_sub'),
                              onTap: _showLanguagePicker,
                            ),
                            const SizedBox(height: 12),
                            _buildActionCard(
                              context,
                              theme,
                              icon: Icons.add_location_alt,
                              title: context.tr('add_scheduled_ride'),
                              subtitle: context.tr('add_scheduled_ride_sub'),
                              onTap: () =>
                                  context.pushNamed(SchedulePageWidget.routeName),
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
                                return _buildActionCard(
                                  context,
                                  theme,
                                  icon: Icons.schedule,
                                  title: context.tr('scheduled_rides'),
                                  subtitle: context.tr('scheduled_rides_sub'),
                                  badgeText: count > 0
                                      ? formatNumber(
                                          count,
                                          formatType: FormatType.compact,
                                        )
                                      : null,
                                  onTap: () => context
                                      .pushNamed(ScheduledRidesWidget.routeName),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionCard(
                              context,
                              theme,
                              icon: Icons.history,
                              title: context.tr('recent_rides'),
                              subtitle: context.tr('recent_rides_sub'),
                              onTap: () =>
                                  context.pushNamed(RecentRidesWidget.routeName),
                            ),
                            const SizedBox(height: 12),
                            _buildActionCard(
                              context,
                              theme,
                              icon: Icons.bookmark,
                              title: context.tr('saved_places'),
                              subtitle: context.tr('saved_places'),
                              onTap: () =>
                                  context.pushNamed(SavedPlacesWidget.routeName),
                            ),
                            const SizedBox(height: 12),
                            _buildActionCard(
                              context,
                              theme,
                              icon: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              title: context.tr('dark_light_mode'),
                              subtitle:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? context.tr('switch_to_light')
                                      : context.tr('switch_to_dark'),
                              onTap: () {
                                final isDark = Theme.of(context).brightness ==
                                    Brightness.dark;
                                setDarkModeSetting(
                                  context,
                                  isDark ? ThemeMode.light : ThemeMode.dark,
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            // Log Out Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () async {
                                  GoRouter.of(context).prepareAuthEvent();
                                  await authManager.signOut();
                                  GoRouter.of(context).clearRedirectLocation();
                                  context.goNamedAuth(
                                    AutWidget.routeName,
                                    context.mounted,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color:
                                          primaryColor.withValues(alpha: 0.6),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.tr('log_out'),
                                      style: theme.titleSmall.override(
                                        fontFamily: theme.titleSmallFamily,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0,
                                        useGoogleFonts:
                                            !theme.titleSmallIsCustom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    FlutterFlowTheme theme,
    String name,
    String? photoUrl,
    String location,
  ) {
    return Column(
      children: [
        // Profile Picture with Glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow Effect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
            // Profile Image
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildDefaultAvatar(theme),
                      )
                    : _buildDefaultAvatar(theme),
              ),
            ),
            // Online Indicator
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Name
        Text(
          name,
          style: theme.headlineMedium.override(
            fontFamily: theme.headlineMediumFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            useGoogleFonts: !theme.headlineMediumIsCustom,
          ),
        ),
        const SizedBox(height: 8),
        // Location Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.place_rounded,
                color: Color(0xFFFDE047),
                size: 18,
              ),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.labelSmall.override(
                    fontFamily: theme.labelSmallFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    useGoogleFonts: !theme.labelSmallIsCustom,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(FlutterFlowTheme theme) {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: 56,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, FlutterFlowTheme theme) {
    final userRef = currentUserReference;
    if (userRef == null) {
      return Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.directions_car,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF3B82F6),
              value: '0',
              label: context.tr('total_rides'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.loyalty,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFF97316),
              value: '0',
              label: context.tr('points'),
            ),
          ),
        ],
      );
    }

    return StreamBuilder<List<RideRecord>>(
      stream: queryRideRecord(
        queryBuilder: (rideRecord) => rideRecord.where(
          'PassengerId',
          isEqualTo: userRef,
        ),
      ),
      builder: (context, snapshot) {
        final rides = snapshot.data ?? const <RideRecord>[];
        final totalRides = rides.length;
        final completedRides =
            rides.where((r) => r.status.toLowerCase() == 'completed').toList();

        double totalDistanceKm = 0.0;
        for (final r in completedRides) {
          final pickup = r.pickupLocation;
          final dest = r.destinationLocation;
          if (pickup == null || dest == null) continue;
          totalDistanceKm += functions.calculateDistance(pickup, dest) ?? 0.0;
        }

        // Simple, data-backed stats derived from real rides:
        // - Points: 10 points per km traveled (completed rides only).
        final points = (totalDistanceKm * 10).round();

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.directions_car,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF3B82F6),
                value: formatNumber(
                  totalRides,
                  formatType: FormatType.compact,
                ),
                label: context.tr('total_rides'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.loyalty,
                iconBgColor: const Color(0xFFFFF7ED),
                iconColor: const Color(0xFFF97316),
                value: formatNumber(
                  points,
                  formatType: FormatType.compact,
                ),
                label: context.tr('points'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLanguagePicker() async {
    final appState = FFAppState();
    final searchController = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = FlutterFlowTheme.of(dialogContext);
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
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
                width: MediaQuery.sizeOf(dialogContext)
                    .width
                    .clamp(0.0, 360.0)
                    .toDouble(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.6,
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
                          itemBuilder: (itemContext, i) {
                            final item = items[i];
                            final isTranslated = RoadyGoI18n
                                .isLanguageFullyTranslated(item.code);
                            final selected = appState.languageCode == item.code;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Text(
                                item.flag,
                                style: const TextStyle(fontSize: 22.0),
                              ),
                              title: Text(item.name),
                              subtitle: Text(item.code.toUpperCase()),
                              trailing: selected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : !isTranslated
                                      ? const Icon(Icons.lock_outline_rounded)
                                      : null,
                              onTap: () {
                                if (!isTranslated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(context.tr('language_coming_soon')),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.of(itemContext).pop();
                                Future.microtask(
                                  () => appState.setLanguageCode(item.code),
                                );
                              },
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

  Widget _buildActionCard(
    BuildContext context,
    FlutterFlowTheme theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badgeText,
  }) {
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
                    badgeText,
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

/// Glass-style button for top bar
class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Stats card widget
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF9FAFB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          // Value
          Text(
            value,
            style: theme.titleLarge.override(
              fontFamily: theme.titleLargeFamily,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleLargeIsCustom,
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label.toUpperCase(),
            style: theme.labelSmall.override(
              fontFamily: theme.labelSmallFamily,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
              useGoogleFonts: !theme.labelSmallIsCustom,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
