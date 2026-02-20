import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/l10n/roadygo_i18n.dart';
import 'saved_places_model.dart';

export 'saved_places_model.dart';

class SavedPlacesWidget extends StatefulWidget {
  const SavedPlacesWidget({super.key});

  static String routeName = 'SavedPlaces';
  static String routePath = '/savedPlaces';

  @override
  State<SavedPlacesWidget> createState() => _SavedPlacesWidgetState();
}

class _SavedPlacesWidgetState extends State<SavedPlacesWidget> {
  late SavedPlacesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SavedPlacesModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primary,
                      theme.secondary,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    _HeaderButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => context.safePop(),
                      background: Colors.white.withValues(alpha: 0.2),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tr('saved_places'),
                        style: theme.titleLarge.override(
                          fontFamily: theme.titleLargeFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          useGoogleFonts: !theme.titleLargeIsCustom,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (!loggedIn || currentUserReference == null)
                    ? _buildEmptyState(
                        theme,
                        'Sign in to view your saved places.',
                      )
                    : StreamBuilder<List<SavedPlaceRecord>>(
                        stream: querySavedPlaceRecord(
                          parent: currentUserReference,
                          queryBuilder: (q) =>
                              q.orderBy('created_time', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.primary,
                              ),
                            );
                          }

                          final places = snapshot.data!;
                          if (places.isEmpty) {
                            return _buildEmptyState(
                              theme,
                              'No saved places yet.',
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                            itemCount: places.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) =>
                                _PlaceCard(place: places[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme, String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.lineColor),
        ),
        child: Text(
          message,
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});

  final SavedPlaceRecord place;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final title = place.name.trim().isNotEmpty ? place.name.trim() : 'Saved Place';
    final subtitle =
        place.address.trim().isNotEmpty ? place.address.trim() : 'No address';
    final visual = _visualForName(title);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: visual.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(visual.icon, color: visual.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.titleMedium.override(
                    fontFamily: theme.titleMediumFamily,
                    color: theme.primaryText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    useGoogleFonts: !theme.titleMediumIsCustom,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.bodySmall.override(
                    fontFamily: theme.bodySmallFamily,
                    color: theme.secondaryText,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    useGoogleFonts: !theme.bodySmallIsCustom,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.secondaryText),
            onSelected: (value) async {
              if (value != 'delete') return;
              try {
                await place.reference.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved place removed.'),
                    duration: Duration(milliseconds: 1400),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not remove saved place.'),
                    duration: Duration(milliseconds: 1600),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  _PlaceVisual _visualForName(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('home')) {
      return const _PlaceVisual(Icons.home_rounded, Color(0xFF3B82F6));
    }
    if (normalized.contains('work') || normalized.contains('office')) {
      return const _PlaceVisual(Icons.work_rounded, Color(0xFF8B5CF6));
    }
    return const _PlaceVisual(Icons.bookmark_rounded, Color(0xFF10B981));
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _PlaceVisual {
  const _PlaceVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
