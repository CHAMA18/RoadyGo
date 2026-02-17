import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/l10n/roadygo_i18n.dart';
import 'payment_methods_model.dart';

export 'payment_methods_model.dart';

class PaymentMethodsWidget extends StatefulWidget {
  const PaymentMethodsWidget({super.key});

  static String routeName = 'PaymentMethods';
  static String routePath = '/paymentMethods';

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  late PaymentMethodsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _defaultMethodId = 'visa_4242';

  final _methods = const <_PaymentMethod>[
    _PaymentMethod(
      id: 'visa_4242',
      brand: 'Visa',
      masked: '**** **** **** 4242',
      expiry: '09/28',
      accent: Color(0xFF2563EB),
    ),
    _PaymentMethod(
      id: 'master_9921',
      brand: 'Mastercard',
      masked: '**** **** **** 9921',
      expiry: '03/29',
      accent: Color(0xFFEA580C),
    ),
    _PaymentMethod(
      id: 'mobile_money',
      brand: 'Mobile Money',
      masked: 'Airtel Money •••• 781',
      expiry: 'Verified',
      accent: Color(0xFF0EA5A4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodsModel());
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
        backgroundColor: const Color(0xFFF3F4F6),
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
                    colors: [Color(0xFF111827), Color(0xFF1F2937)],
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
                        context.tr('payment_methods'),
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
                      onTap: _onAddMethod,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    children: [
                      for (final method in _methods) ...[
                        _MethodCard(
                          method: method,
                          isDefault: method.id == _defaultMethodId,
                          onSetDefault: () {
                            setState(() => _defaultMethodId = method.id);
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
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: Color(0xFF16A34A),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'All payments are tokenized and secured with bank-grade encryption.',
                                style: theme.bodyMedium.override(
                                  fontFamily: theme.bodyMediumFamily,
                                  color: const Color(0xFF4B5563),
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

  void _onAddMethod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add payment method flow coming soon.'),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.isDefault,
    required this.onSetDefault,
  });

  final _PaymentMethod method;
  final bool isDefault;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            method.accent.withValues(alpha: 0.95),
            method.accent.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: method.accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                method.brand,
                style: theme.titleMedium.override(
                  fontFamily: theme.titleMediumFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.titleMediumIsCustom,
                ),
              ),
              const Spacer(),
              if (isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            method.masked,
            style: theme.headlineSmall.override(
              fontFamily: theme.headlineSmallFamily,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              useGoogleFonts: !theme.headlineSmallIsCustom,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Expiry ${method.expiry}',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodySmallIsCustom,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: isDefault ? null : onSetDefault,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('Set as default'),
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
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _PaymentMethod {
  const _PaymentMethod({
    required this.id,
    required this.brand,
    required this.masked,
    required this.expiry,
    required this.accent,
  });

  final String id;
  final String brand;
  final String masked;
  final String expiry;
  final Color accent;
}
