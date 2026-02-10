import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());
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
    const primaryHoverColor = Color(0xFFFF5252);

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
                                // Settings Button
                                _GlassButton(
                                  icon: Icons.settings,
                                  onTap: () {
                                    // TODO: Navigate to settings
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Profile Picture and Info
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
                                return _buildProfileHeader(
                                  context,
                                  theme,
                                  context.tr('loading'),
                                  null,
                                );
                              }
                              final passenger = snapshot.data?.isNotEmpty == true
                                  ? snapshot.data!.first
                                  : null;
                              return _buildProfileHeader(
                                context,
                                theme,
                                passenger?.name ?? currentUserEmail ?? 'User',
                                currentUserPhoto,
                              );
                            },
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
                            const SizedBox(height: 32),
                            // Menu Items
                            _buildMenuItem(
                              context,
                              theme,
                              icon: Icons.credit_card,
                              iconBgColor: const Color(0xFFF0F4FF),
                              iconColor: const Color(0xFF3B82F6),
                              title: context.tr('payment_methods'),
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              context,
                              theme,
                              icon: Icons.history,
                              iconBgColor: const Color(0xFFFFF4E6),
                              iconColor: const Color(0xFFF97316),
                              title: context.tr('ride_history'),
                              onTap: () => context.pushNamed(RecentRidesWidget.routeName),
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              context,
                              theme,
                              icon: Icons.local_shipping,
                              iconBgColor: const Color(0xFFE8F5E9),
                              iconColor: const Color(0xFF22C55E),
                              title: context.tr('my_vehicles'),
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              context,
                              theme,
                              icon: Icons.bookmark,
                              iconBgColor: const Color(0xFFFCE7F3),
                              iconColor: const Color(0xFFEC4899),
                              title: context.tr('saved_places'),
                              onTap: () {},
                            ),
                            const SizedBox(height: 32),
                            // Edit Profile Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () =>
                                    context.pushNamed(EditProfileWidget.routeName),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1F2937),
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shadowColor: Colors.black.withValues(alpha: 0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit_square, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.tr('edit_profile'),
                                      style: theme.titleSmall.override(
                                        fontFamily: theme.titleSmallFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                        useGoogleFonts: !theme.titleSmallIsCustom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                                      color: primaryColor.withValues(alpha: 0.6),
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
                                        useGoogleFonts: !theme.titleSmallIsCustom,
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
                        errorBuilder: (_, __, ___) => _buildDefaultAvatar(theme),
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
        // Premium Badge
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
                Icons.verified,
                color: Color(0xFFFDE047),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('premium_member'),
                style: theme.labelSmall.override(
                  fontFamily: theme.labelSmallFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  useGoogleFonts: !theme.labelSmallIsCustom,
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
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.forest,
              iconBgColor: const Color(0xFFF0FDF4),
              iconColor: const Color(0xFF22C55E),
              value: '0g',
              label: context.tr('co2_saved'),
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
        // - CO2 saved: 120g per km (completed rides only).
        final points = (totalDistanceKm * 10).round();
        final co2SavedGrams = totalDistanceKm * 120.0;

        String formatCo2(num grams) {
          if (grams >= 1000) {
            return '${formatNumber(grams / 1000, formatType: FormatType.decimal, decimalType: DecimalType.automatic)}kg';
          }
          return '${formatNumber(grams, formatType: FormatType.compact)}g';
        }

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
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.forest,
                iconBgColor: const Color(0xFFF0FDF4),
                iconColor: const Color(0xFF22C55E),
                value: formatCo2(co2SavedGrams),
                label: context.tr('co2_saved'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    FlutterFlowTheme theme, {
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF3F4F6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: theme.bodyMedium.override(
                    fontFamily: theme.bodyMediumFamily,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0,
                    useGoogleFonts: !theme.bodyMediumIsCustom,
                  ),
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: Colors.grey[300],
                size: 24,
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
