import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/l10n/roadygo_i18n.dart';
import 'my_vehicles_model.dart';

export 'my_vehicles_model.dart';

class MyVehiclesWidget extends StatefulWidget {
  const MyVehiclesWidget({super.key});

  static String routeName = 'MyVehicles';
  static String routePath = '/myVehicles';

  @override
  State<MyVehiclesWidget> createState() => _MyVehiclesWidgetState();
}

class _MyVehiclesWidgetState extends State<MyVehiclesWidget> {
  late MyVehiclesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _primaryVehicleId = 'sedan';

  final _vehicles = const <_Vehicle>[
    _Vehicle(
      id: 'sedan',
      name: 'Tesla Model 3',
      plate: 'B 9242 RG',
      color: 'Midnight Silver',
      status: 'ACTIVE',
      icon: Icons.electric_car_rounded,
      accent: Color(0xFF0EA5E9),
    ),
    _Vehicle(
      id: 'suv',
      name: 'Toyota RAV4',
      plate: 'B 1530 AA',
      color: 'Pearl White',
      status: 'AVAILABLE',
      icon: Icons.directions_car_filled_rounded,
      accent: Color(0xFF22C55E),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyVehiclesModel());
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
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    _HeaderButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => context.safePop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tr('my_vehicles'),
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
                      icon: Icons.add,
                      onTap: _onAddVehicle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
                  child: Column(
                    children: [
                      for (final vehicle in _vehicles) ...[
                        _VehicleCard(
                          vehicle: vehicle,
                          isPrimary: vehicle.id == _primaryVehicleId,
                          onSetPrimary: () {
                            setState(() => _primaryVehicleId = vehicle.id);
                          },
                        ),
                        const SizedBox(height: 14),
                      ],
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF0EA5E9),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Primary vehicle is used for your preferred towing profile and dispatch details.',
                                style: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: const Color(0xFF334155),
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

  void _onAddVehicle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add vehicle flow coming soon.'),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.isPrimary,
    required this.onSetPrimary,
  });

  final _Vehicle vehicle;
  final bool isPrimary;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? vehicle.accent : const Color(0xFFE2E8F0),
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: vehicle.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(vehicle.icon, color: vehicle.accent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name,
                      style: theme.titleMedium.override(
                        fontFamily: theme.titleMediumFamily,
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.titleMediumIsCustom,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle.plate,
                      style: theme.bodySmall.override(
                        fontFamily: theme.bodySmallFamily,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        useGoogleFonts: !theme.bodySmallIsCustom,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: vehicle.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  vehicle.status,
                  style: TextStyle(
                    color: vehicle.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Color: ${vehicle.color}',
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: const Color(0xFF4B5563),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: isPrimary ? null : onSetPrimary,
                child: Text(isPrimary ? 'Primary' : 'Set primary'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

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
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Vehicle {
  const _Vehicle({
    required this.id,
    required this.name,
    required this.plate,
    required this.color,
    required this.status,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String name;
  final String plate;
  final String color;
  final String status;
  final IconData icon;
  final Color accent;
}
