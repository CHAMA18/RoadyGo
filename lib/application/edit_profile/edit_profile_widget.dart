import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  static String routeName = 'EditProfile';
  static String routePath = '/editProfile';

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _model.yourNameFocusNode ??= FocusNode();

    _model.phoneNumberFocusNode ??= FocusNode();

    _model.emailFocusNode ??= FocusNode();
    _model.locationFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        List<PassengerRecord> editProfilePassengerRecordList = snapshot.data!;
        final editProfilePassengerRecord =
            editProfilePassengerRecordList.isNotEmpty
                ? editProfilePassengerRecordList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () async {
                              context.pushNamed(
                                  PassengerDetailsWidget.routeName);
                            },
                          ),
                        ),
                        Center(
                          child: Text(
                            context.tr('complete_profile'),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .titleMediumIsCustom,
                                ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      child: Column(
                        children: [
                          Text(
                            context.tr('complete_profile_desc'),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodySmallFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.0,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .bodySmallIsCustom,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // UI only, no backend changes.
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 96,
                                            height: 96,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withValues(alpha: 0.08),
                                              border: Border.all(
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .primary
                                                    .withValues(alpha: 0.25),
                                                width: 3,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCnUNZK2NoQ_qVFN9ET0amv4YQa3e9xS-LheyAcMA659It97TAv0rdnDTNR0H43f4cYuuRaBBjIY9uCjox2OLlbbEziy53_ZYMfico3tXroINm0TAw2G8l5oOlEooNLCS1hACRTqsivzW0J9Yv3HiW6Rbv_dEQ6Vj2DWDh2x0SOgvy1VFFtNbm50AjPVoeOR3uHgz_w1Q_0k7F9-65HFB_Y__lX6AHZ3AI67rtkQn_XKhG7tKUW_BvKPbRkJ2TKYaH5CIFbT-GS6A',
                                                fit: BoxFit.cover,
                                                color: Colors.black
                                                    .withValues(alpha: 0.3),
                                                colorBlendMode:
                                                    BlendMode.darken,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.1),
                                                  blurRadius: 6,
                                                  offset:
                                                      const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.photo_camera,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        context.tr('upload_photo'),
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelSmallIsCustom,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller:
                                      _model.yourNameTextController ??=
                                          TextEditingController(
                                    text: editProfilePassengerRecord?.name !=
                                                null &&
                                            editProfilePassengerRecord?.name !=
                                                ''
                                        ? editProfilePassengerRecord?.name
                                        : ' ',
                                  ),
                                  focusNode: _model.yourNameFocusNode,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  decoration: InputDecoration(
                                    labelText: context.tr('full_name'),
                                    prefixIcon: const Icon(Icons.person),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .lineColor,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.2,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  validator: _model
                                      .yourNameTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    if (!isAndroid && !isiOS)
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        return TextEditingValue(
                                          selection: newValue.selection,
                                          text: newValue.text.toCapitalization(
                                              TextCapitalization.words),
                                        );
                                      }),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller:
                                      _model.phoneNumberTextController ??=
                                          TextEditingController(
                                    text: editProfilePassengerRecord
                                                    ?.mobileNumber !=
                                                null &&
                                            editProfilePassengerRecord
                                                    ?.mobileNumber !=
                                                ''
                                        ? editProfilePassengerRecord
                                            ?.mobileNumber
                                        : ' ',
                                  ),
                                  focusNode: _model.phoneNumberFocusNode,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: context.tr('phone_number'),
                                    prefixIcon:
                                        const Icon(Icons.phone_iphone),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .lineColor,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.2,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  maxLength: 10,
                                  buildCounter: (context,
                                          {required currentLength,
                                          required isFocused,
                                          maxLength}) =>
                                      null,
                                  validator: _model
                                      .phoneNumberTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    if (!isAndroid && !isiOS)
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        return TextEditingValue(
                                          selection: newValue.selection,
                                          text: newValue.text.toCapitalization(
                                              TextCapitalization.words),
                                        );
                                      }),
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'))
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller:
                                      _model.emailTextController ??=
                                          TextEditingController(
                                    text: editProfilePassengerRecord?.email !=
                                                null &&
                                            editProfilePassengerRecord?.email !=
                                                ''
                                        ? editProfilePassengerRecord?.email
                                        : ' ',
                                  ),
                                  focusNode: _model.emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: context.tr('email_address'),
                                    prefixIcon: const Icon(Icons.mail_outline),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .lineColor,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.2,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  validator: _model
                                      .emailTextControllerValidator
                                      .asValidator(context),
                                  inputFormatters: [
                                    if (!isAndroid && !isiOS)
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        return TextEditingValue(
                                          selection: newValue.selection,
                                          text: newValue.text.toCapitalization(
                                              TextCapitalization.words),
                                        );
                                      }),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller:
                                      _model.locationTextController ??=
                                          TextEditingController(
                                    text: editProfilePassengerRecord
                                                    ?.location !=
                                                null &&
                                            editProfilePassengerRecord
                                                    ?.location !=
                                                ''
                                        ? editProfilePassengerRecord?.location
                                        : ' ',
                                  ),
                                  focusNode: _model.locationFocusNode,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: context.tr('location'),
                                    prefixIcon: const Icon(Icons.place),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .lineColor,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1.2,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  validator: _model
                                      .locationTextControllerValidator
                                      .asValidator(context),
                                ),
                                const SizedBox(height: 24),
                                InkWell(
                                  onTap: () async {
                                    final nameValue = _model
                                        .yourNameTextController
                                        ?.text
                                        .trim();
                                    final phoneValue = _model
                                        .phoneNumberTextController
                                        ?.text
                                        .trim();
                                    final emailValue = _model
                                        .emailTextController
                                        ?.text
                                        .trim();
                                    final locationValue = _model
                                        .locationTextController
                                        ?.text
                                        .trim();
                                    await editProfilePassengerRecord!.reference
                                        .update(createPassengerRecordData(
                                      name: nameValue?.isNotEmpty == true
                                          ? nameValue
                                          : editProfilePassengerRecord.name,
                                      mobileNumber:
                                          phoneValue?.isNotEmpty == true
                                              ? phoneValue
                                              : editProfilePassengerRecord
                                                  .mobileNumber,
                                      email: emailValue?.isNotEmpty == true
                                          ? emailValue
                                          : editProfilePassengerRecord.email,
                                      location:
                                          locationValue?.isNotEmpty == true
                                              ? locationValue
                                              : editProfilePassengerRecord
                                                  .location,
                                    ));

                                    context.pushNamed(
                                        PassengerDetailsWidget.routeName);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFE53935),
                                          Color(0xFFFF5252),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE53935)
                                              .withValues(alpha: 0.3),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context.tr('finish_setup'),
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.tr('finish_legal'),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelSmallFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .labelSmallIsCustom,
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
      },
    );
  }
}
