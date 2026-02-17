import 'package:flutter/material.dart';

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

  final _places = const <_SavedPlace>[
    _SavedPlace(
      title: 'Home',
      subtitle: 'Lagos, Victoria Island, Admiralty Way 14',
      icon: Icons.home_rounded,
      accent: Color(0xFF3B82F6),
    ),
    _SavedPlace(
      title: 'Work',
      subtitle: 'Ikoyi, Corporate Towers, 8th Floor',
      icon: Icons.work_rounded,
      accent: Color(0xFF8B5CF6),
    ),
    _SavedPlace(
      title: 'Garage',
      subtitle: 'Apapa Yard, Dock Road Gate 3',
      icon: Icons.local_parking_rounded,
      accent: Color(0xFF10B981),
    ),
  ];

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
                    _HeaderButton(
                      icon: Icons.add_location_alt_outlined,
                      onTap: _onAddPlace,
                      background: Colors.white.withValues(alpha: 0.2),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      for (final place in _places) ...[
                        _PlaceCard(place: place),
                        const SizedBox(height: 14),
                      ],
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: theme.lineColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: theme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.tips_and_updates_outlined,
                                color: theme.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Saved places accelerate booking and improve dispatch accuracy for repeat trips.',
                                style: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                  useGoogleFonts: !theme.bodyMediumIsCustom,
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
            ],
          ),
        ),
      ),
    );
  }

  void _onAddPlace() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add saved place flow coming soon.'),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});

  final _SavedPlace place;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
              color: place.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(place.icon, color: place.accent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
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
                  place.subtitle,
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
            onSelected: (value) {
              final message = value == 'edit'
                  ? 'Edit place flow coming soon.'
                  : 'Place removed (demo).';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
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

class _SavedPlace {
  const _SavedPlace({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
}
