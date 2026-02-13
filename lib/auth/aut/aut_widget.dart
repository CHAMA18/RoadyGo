import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:go_taxi_rider/flutter_flow/flutter_flow_animations.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_theme.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_util.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_widgets.dart';
import 'package:go_taxi_rider/index.dart';
import 'package:go_taxi_rider/auth/firebase_auth/auth_util.dart';
import '/l10n/roadygo_i18n.dart';
import 'aut_model.dart';
export 'aut_model.dart';

class AutWidget extends StatefulWidget {
  const AutWidget({super.key});

  static String routeName = 'Aut';
  static String routePath = '/aut';

  @override
  State<AutWidget> createState() => _AutWidgetState();
}

class _AutWidgetState extends State<AutWidget> with TickerProviderStateMixin {
  late AutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  final animationsMap = <String, AnimationInfo>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AutModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nameTextController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.mobileNumberTextController ??= TextEditingController();
    _model.mobileNumberFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.repeatpasswordTextController ??= TextEditingController();
    _model.repeatpasswordFocusNode ??= FocusNode();

    _model.emailAddress22TextController ??= TextEditingController();
    _model.emailAddress22FocusNode ??= FocusNode();

    _model.password22TextController ??= TextEditingController();
    _model.password22FocusNode ??= FocusNode();

    animationsMap.addAll({
      'logoOnPageLoad': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOutQuart,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeOutBack,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'sheetOnPageLoad': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOutQuart,
            delay: 200.0.ms,
            duration: 700.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'formOnPageLoad': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOutCubic,
            delay: 500.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutCubic,
            delay: 500.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await authManager.signInWithGoogle(context);
      if (user != null && mounted) {
        context.goNamed(AuthHomePageWidget.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await authManager.signInWithApple(context);
      if (user != null && mounted) {
        context.goNamed(AuthHomePageWidget.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isShortScreen = size.height < 700;
    final logoHeight = size.height * (isShortScreen ? 0.28 : 0.35);
    final sheetInitialSize = isShortScreen ? 0.8 : 0.72;
    final sheetMinSize = isShortScreen ? 0.55 : 0.5;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background with Logo
            SafeArea(
              child: Container(
                width: double.infinity,
                height: logoHeight,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Center(
                  child: _buildLogo(context),
                ),
              ),
            ),

            // Main Content Sheet
            DraggableScrollableSheet(
              initialChildSize: sheetInitialSize,
              minChildSize: sheetMinSize,
              maxChildSize: 0.95,
              snap: true,
              snapSizes: isShortScreen
                  ? const [0.55, 0.8, 0.95]
                  : const [0.5, 0.72, 0.95],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 40.0,
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0.0, -10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Drag Handle
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                        child: Container(
                          width: 48.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                      ),

                      // Tab Bar
                      _buildTabBar(context),

                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            _buildSignUpTab(context, scrollController),
                            _buildLoginTab(context, scrollController),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animateOnPageLoad(animationsMap['sheetOnPageLoad']!);
              },
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 240.0,
      height: 240.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 30.0,
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
            offset: const Offset(0.0, 15.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.12),
                width: 1.0,
              ),
            ),
            child: Image.asset(
              'assets/images/RoadyGoImage.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Center(
                child: Text(
                  'Logo',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleSmallFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context)
                            .titleSmallIsCustom,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['logoOnPageLoad']!);
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
        ),
        child: TabBar(
          controller: _model.tabBarController,
          labelColor: FlutterFlowTheme.of(context).primaryText,
          unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
          labelStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
              ),
          unselectedLabelStyle:
              FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleSmallIsCustom,
                  ),
          indicatorColor: FlutterFlowTheme.of(context).primary,
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: context.tr('create_account')),
            Tab(text: context.tr('log_in')),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab(BuildContext context, ScrollController scrollController) {
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + 24.0;
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, bottomPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name Field
            _buildTextField(
              controller: _model.nameTextController!,
              focusNode: _model.nameFocusNode!,
              label: context.tr('full_name'),
              hint: context.tr('enter_full_name'),
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 16.0),

            // Email Field
            _buildTextField(
              controller: _model.emailAddressTextController!,
              focusNode: _model.emailAddressFocusNode!,
              label: context.tr('email_address'),
              hint: context.tr('email_hint'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16.0),

            // Mobile Number Field with Country Code
            _buildPhoneField(context),
            const SizedBox(height: 16.0),

            // Password Field
            _buildTextField(
              controller: _model.passwordTextController!,
              focusNode: _model.passwordFocusNode!,
              label: context.tr('password'),
              hint: context.tr('create_password'),
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              passwordVisible: _model.passwordVisibility,
              onTogglePassword: () {
                safeSetState(
                    () => _model.passwordVisibility = !_model.passwordVisibility);
              },
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 16.0),

            // Confirm Password Field
            _buildTextField(
              controller: _model.repeatpasswordTextController!,
              focusNode: _model.repeatpasswordFocusNode!,
              label: context.tr('confirm_password'),
              hint: context.tr('reenter_password'),
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              passwordVisible: _model.repeatpasswordVisibility,
              onTogglePassword: () {
                safeSetState(() => _model.repeatpasswordVisibility =
                    !_model.repeatpasswordVisibility);
              },
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 20.0),

            // Terms Checkbox
            _buildTermsCheckbox(context),
            const SizedBox(height: 24.0),

            // Get Started Button
            _buildPrimaryButton(
              context: context,
              text: context.tr('get_started'),
              onPressed: _handleSignUp,
            ),
            const SizedBox(height: 24.0),

            // Social Auth Divider
            _buildDivider(context, context.tr('or_continue_with')),
            const SizedBox(height: 20.0),

            // Social Auth Buttons
            _buildSocialAuthButtons(context),
            const SizedBox(height: 24.0),

            // Quick Ride Divider
            _buildDivider(context, context.tr('or_get_a')),
            const SizedBox(height: 16.0),

            // Quick Ride Button
            _buildQuickRideButton(context),
          ],
        ).animateOnPageLoad(animationsMap['formOnPageLoad']!),
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context, ScrollController scrollController) {
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + 24.0;
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, bottomPadding),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Back Header
            Text(
              context.tr('welcome_back'),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).headlineMediumFamily,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              context.tr('sign_in_to_continue'),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
            const SizedBox(height: 32.0),

            // Email Field
            _buildTextField(
              controller: _model.emailAddress22TextController!,
              focusNode: _model.emailAddress22FocusNode!,
              label: context.tr('email_address'),
              hint: context.tr('email_hint'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16.0),

            // Password Field
            _buildTextField(
              controller: _model.password22TextController!,
              focusNode: _model.password22FocusNode!,
              label: context.tr('password'),
              hint: context.tr('enter_password'),
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              passwordVisible: _model.password22Visibility,
              onTogglePassword: () {
                safeSetState(() =>
                    _model.password22Visibility = !_model.password22Visibility);
              },
              autofillHints: const [AutofillHints.password],
            ),
            const SizedBox(height: 12.0),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                ),
                child: Text(
                  context.tr('forgot_password'),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodySmallIsCustom,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Sign In Button
            _buildPrimaryButton(
              context: context,
              text: context.tr('sign_in'),
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 24.0),

            // Social Auth Divider
            _buildDivider(context, context.tr('or_continue_with')),
            const SizedBox(height: 20.0),

            // Social Auth Buttons
            _buildSocialAuthButtons(context),
            const SizedBox(height: 24.0),

            // Quick Ride Divider
            _buildDivider(context, context.tr('or_get_a')),
            const SizedBox(height: 16.0),

            // Quick Ride Button
            _buildQuickRideButton(context),
          ],
        ).animateOnPageLoad(animationsMap['formOnPageLoad']!),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool passwordVisible = false,
    VoidCallback? onTogglePassword,
    List<String>? autofillHints,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword && !passwordVisible,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      style: FlutterFlowTheme.of(context).bodyLarge.override(
            fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
          ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color:
                  FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.6),
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
        prefixIcon: Icon(
          icon,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 22.0,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 22.0,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 18.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          // Country Code Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _model.selectedCountryCode,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 18.0,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
                selectedItemBuilder: (BuildContext context) {
                  return AutModel.countryCodes.map((country) {
                    final flag = AutModel.countryCodeToFlag(country['country']!);
                    return Center(
                      child: Text(
                        '$flag ${country['code']}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    );
                  }).toList();
                },
                items: AutModel.countryCodes.map((country) {
                  final flag = AutModel.countryCodeToFlag(country['country']!);
                  return DropdownMenuItem<String>(
                    value: '${country['code']}_${country['country']}',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          flag,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          country['country']!,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context)
                                        .bodyMediumIsCustom,
                                  ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          country['code']!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily:
                                    FlutterFlowTheme.of(context).bodySmallFamily,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodySmallIsCustom,
                              ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    safeSetState(() => _model.selectedCountryCode = value);
                  }
                },
                dropdownColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          // Phone Number Input
          Expanded(
            child: TextFormField(
              controller: _model.mobileNumberTextController,
              focusNode: _model.mobileNumberFocusNode,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                  ),
              decoration: InputDecoration(
                hintText: context.tr('mobile_number'),
                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withValues(alpha: 0.6),
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 18.0, 20.0, 18.0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: Checkbox(
            value: _model.termsAccepted,
            onChanged: (value) {
              safeSetState(() => _model.termsAccepted = value ?? false);
            },
            activeColor: FlutterFlowTheme.of(context).primary,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            side: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodySmallIsCustom,
                  ),
              children: [
                TextSpan(text: context.tr('i_agree_to_the')),
                TextSpan(
                  text: context.tr('terms_of_service'),
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: context.tr('and_word')),
                TextSpan(
                  text: context.tr('privacy_policy'),
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: text,
      options: FFButtonOptions(
        width: double.infinity,
        height: 56.0,
        padding: EdgeInsets.zero,
        color: FlutterFlowTheme.of(context).primary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
            ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(28.0),
      ),
    );
  }

  Widget _buildDivider(BuildContext context, String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodySmallIsCustom,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialAuthButtons(BuildContext context) {
    return Row(
      children: [
        // Google Button
        Expanded(
          child: _buildSocialButton(
            context: context,
            icon: const FaIcon(FontAwesomeIcons.google, size: 20.0, color: Colors.white),
            label: 'Google',
            backgroundColor: const Color(0xFF4285F4),
            textColor: Colors.white,
            onPressed: _handleGoogleSignIn,
          ),
        ),
        const SizedBox(width: 12.0),
        // Apple Button
        Expanded(
          child: _buildSocialButton(
            context: context,
            icon: const FaIcon(FontAwesomeIcons.apple, size: 22.0, color: Colors.white),
            label: 'Apple',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            onPressed: _handleAppleSignIn,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: 52.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10.0),
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickRideButton(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(28.0),
      child: InkWell(
        onTap: () => context.pushNamed(HomePageWidget.routeName),
        borderRadius: BorderRadius.circular(28.0),
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: Text(
            context.tr('quick_ride'),
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleSmallIsCustom,
                ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final email = _model.emailAddressTextController.text.trim();
    final password = _model.passwordTextController.text;
    final repeatPassword = _model.repeatpasswordTextController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('enter_email_password'))),
      );
      return;
    }

    if (password != repeatPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('passwords_do_not_match'))),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('password_min_6'))),
      );
      return;
    }

    if (!_model.termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('agree_terms_privacy'))),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await authManager.createAccountWithEmail(
        context,
        email,
        password,
      );

      if (user != null && mounted) {
        await authManager.refreshUser();
        context.goNamed(OnboardingWidget.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    final email = _model.emailAddress22TextController.text.trim();
    final password = _model.password22TextController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('enter_email_password'))),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await authManager.signInWithEmail(
        context,
        email,
        password,
      );

      if (user != null && mounted) {
        await authManager.refreshUser();
        context.goNamed(AuthHomePageWidget.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _model.emailAddress22TextController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('enter_email_to_reset'))),
      );
      return;
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('enter_valid_email'))),
      );
      return;
    }

    await authManager.resetPassword(
      email: email,
      context: context,
    );
  }
}
