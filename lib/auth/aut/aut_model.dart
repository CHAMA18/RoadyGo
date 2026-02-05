import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'aut_widget.dart' show AutWidget;
import 'package:flutter/material.dart';

class AutModel extends FlutterFlowModel<AutWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for MobileNumber widget.
  FocusNode? mobileNumberFocusNode;
  TextEditingController? mobileNumberTextController;
  String? Function(BuildContext, String?)? mobileNumberTextControllerValidator;
  
  // State field(s) for Country Code dropdown.
  String selectedCountryCode = '+1_US';
  
  // List of country codes
  static const List<Map<String, String>> countryCodes = [
    {'code': '+1', 'country': 'US', 'name': 'United States'},
    {'code': '+1', 'country': 'CA', 'name': 'Canada'},
    {'code': '+44', 'country': 'GB', 'name': 'United Kingdom'},
    {'code': '+49', 'country': 'DE', 'name': 'Germany'},
    {'code': '+33', 'country': 'FR', 'name': 'France'},
    {'code': '+39', 'country': 'IT', 'name': 'Italy'},
    {'code': '+34', 'country': 'ES', 'name': 'Spain'},
    {'code': '+351', 'country': 'PT', 'name': 'Portugal'},
    {'code': '+31', 'country': 'NL', 'name': 'Netherlands'},
    {'code': '+32', 'country': 'BE', 'name': 'Belgium'},
    {'code': '+41', 'country': 'CH', 'name': 'Switzerland'},
    {'code': '+43', 'country': 'AT', 'name': 'Austria'},
    {'code': '+46', 'country': 'SE', 'name': 'Sweden'},
    {'code': '+47', 'country': 'NO', 'name': 'Norway'},
    {'code': '+45', 'country': 'DK', 'name': 'Denmark'},
    {'code': '+358', 'country': 'FI', 'name': 'Finland'},
    {'code': '+48', 'country': 'PL', 'name': 'Poland'},
    {'code': '+420', 'country': 'CZ', 'name': 'Czech Republic'},
    {'code': '+36', 'country': 'HU', 'name': 'Hungary'},
    {'code': '+40', 'country': 'RO', 'name': 'Romania'},
    {'code': '+30', 'country': 'GR', 'name': 'Greece'},
    {'code': '+353', 'country': 'IE', 'name': 'Ireland'},
    {'code': '+7', 'country': 'RU', 'name': 'Russia'},
    {'code': '+380', 'country': 'UA', 'name': 'Ukraine'},
    {'code': '+90', 'country': 'TR', 'name': 'Turkey'},
    {'code': '+91', 'country': 'IN', 'name': 'India'},
    {'code': '+86', 'country': 'CN', 'name': 'China'},
    {'code': '+81', 'country': 'JP', 'name': 'Japan'},
    {'code': '+82', 'country': 'KR', 'name': 'South Korea'},
    {'code': '+852', 'country': 'HK', 'name': 'Hong Kong'},
    {'code': '+886', 'country': 'TW', 'name': 'Taiwan'},
    {'code': '+65', 'country': 'SG', 'name': 'Singapore'},
    {'code': '+60', 'country': 'MY', 'name': 'Malaysia'},
    {'code': '+62', 'country': 'ID', 'name': 'Indonesia'},
    {'code': '+63', 'country': 'PH', 'name': 'Philippines'},
    {'code': '+66', 'country': 'TH', 'name': 'Thailand'},
    {'code': '+84', 'country': 'VN', 'name': 'Vietnam'},
    {'code': '+92', 'country': 'PK', 'name': 'Pakistan'},
    {'code': '+880', 'country': 'BD', 'name': 'Bangladesh'},
    {'code': '+94', 'country': 'LK', 'name': 'Sri Lanka'},
    {'code': '+977', 'country': 'NP', 'name': 'Nepal'},
    {'code': '+61', 'country': 'AU', 'name': 'Australia'},
    {'code': '+64', 'country': 'NZ', 'name': 'New Zealand'},
    {'code': '+55', 'country': 'BR', 'name': 'Brazil'},
    {'code': '+54', 'country': 'AR', 'name': 'Argentina'},
    {'code': '+56', 'country': 'CL', 'name': 'Chile'},
    {'code': '+57', 'country': 'CO', 'name': 'Colombia'},
    {'code': '+51', 'country': 'PE', 'name': 'Peru'},
    {'code': '+58', 'country': 'VE', 'name': 'Venezuela'},
    {'code': '+52', 'country': 'MX', 'name': 'Mexico'},
    {'code': '+593', 'country': 'EC', 'name': 'Ecuador'},
    {'code': '+591', 'country': 'BO', 'name': 'Bolivia'},
    {'code': '+595', 'country': 'PY', 'name': 'Paraguay'},
    {'code': '+598', 'country': 'UY', 'name': 'Uruguay'},
    {'code': '+20', 'country': 'EG', 'name': 'Egypt'},
    {'code': '+27', 'country': 'ZA', 'name': 'South Africa'},
    {'code': '+234', 'country': 'NG', 'name': 'Nigeria'},
    {'code': '+254', 'country': 'KE', 'name': 'Kenya'},
    {'code': '+255', 'country': 'TZ', 'name': 'Tanzania'},
    {'code': '+256', 'country': 'UG', 'name': 'Uganda'},
    {'code': '+233', 'country': 'GH', 'name': 'Ghana'},
    {'code': '+212', 'country': 'MA', 'name': 'Morocco'},
    {'code': '+213', 'country': 'DZ', 'name': 'Algeria'},
    {'code': '+216', 'country': 'TN', 'name': 'Tunisia'},
    {'code': '+966', 'country': 'SA', 'name': 'Saudi Arabia'},
    {'code': '+971', 'country': 'AE', 'name': 'United Arab Emirates'},
    {'code': '+972', 'country': 'IL', 'name': 'Israel'},
    {'code': '+962', 'country': 'JO', 'name': 'Jordan'},
    {'code': '+961', 'country': 'LB', 'name': 'Lebanon'},
    {'code': '+965', 'country': 'KW', 'name': 'Kuwait'},
    {'code': '+968', 'country': 'OM', 'name': 'Oman'},
    {'code': '+974', 'country': 'QA', 'name': 'Qatar'},
    {'code': '+973', 'country': 'BH', 'name': 'Bahrain'},
    {'code': '+964', 'country': 'IQ', 'name': 'Iraq'},
    {'code': '+98', 'country': 'IR', 'name': 'Iran'},
    {'code': '+93', 'country': 'AF', 'name': 'Afghanistan'},
    {'code': '+370', 'country': 'LT', 'name': 'Lithuania'},
    {'code': '+371', 'country': 'LV', 'name': 'Latvia'},
    {'code': '+372', 'country': 'EE', 'name': 'Estonia'},
    {'code': '+375', 'country': 'BY', 'name': 'Belarus'},
    {'code': '+381', 'country': 'RS', 'name': 'Serbia'},
    {'code': '+385', 'country': 'HR', 'name': 'Croatia'},
    {'code': '+386', 'country': 'SI', 'name': 'Slovenia'},
    {'code': '+387', 'country': 'BA', 'name': 'Bosnia and Herzegovina'},
    {'code': '+389', 'country': 'MK', 'name': 'North Macedonia'},
    {'code': '+355', 'country': 'AL', 'name': 'Albania'},
    {'code': '+359', 'country': 'BG', 'name': 'Bulgaria'},
    {'code': '+421', 'country': 'SK', 'name': 'Slovakia'},
    {'code': '+354', 'country': 'IS', 'name': 'Iceland'},
    {'code': '+352', 'country': 'LU', 'name': 'Luxembourg'},
    {'code': '+356', 'country': 'MT', 'name': 'Malta'},
    {'code': '+357', 'country': 'CY', 'name': 'Cyprus'},
    {'code': '+995', 'country': 'GE', 'name': 'Georgia'},
    {'code': '+994', 'country': 'AZ', 'name': 'Azerbaijan'},
    {'code': '+374', 'country': 'AM', 'name': 'Armenia'},
    {'code': '+7', 'country': 'KZ', 'name': 'Kazakhstan'},
    {'code': '+998', 'country': 'UZ', 'name': 'Uzbekistan'},
    {'code': '+992', 'country': 'TJ', 'name': 'Tajikistan'},
    {'code': '+996', 'country': 'KG', 'name': 'Kyrgyzstan'},
    {'code': '+993', 'country': 'TM', 'name': 'Turkmenistan'},
    {'code': '+976', 'country': 'MN', 'name': 'Mongolia'},
    {'code': '+95', 'country': 'MM', 'name': 'Myanmar'},
    {'code': '+855', 'country': 'KH', 'name': 'Cambodia'},
    {'code': '+856', 'country': 'LA', 'name': 'Laos'},
    {'code': '+673', 'country': 'BN', 'name': 'Brunei'},
    {'code': '+670', 'country': 'TL', 'name': 'Timor-Leste'},
    {'code': '+675', 'country': 'PG', 'name': 'Papua New Guinea'},
    {'code': '+679', 'country': 'FJ', 'name': 'Fiji'},
    {'code': '+682', 'country': 'CK', 'name': 'Cook Islands'},
    {'code': '+685', 'country': 'WS', 'name': 'Samoa'},
    {'code': '+676', 'country': 'TO', 'name': 'Tonga'},
    {'code': '+678', 'country': 'VU', 'name': 'Vanuatu'},
    {'code': '+506', 'country': 'CR', 'name': 'Costa Rica'},
    {'code': '+507', 'country': 'PA', 'name': 'Panama'},
    {'code': '+503', 'country': 'SV', 'name': 'El Salvador'},
    {'code': '+502', 'country': 'GT', 'name': 'Guatemala'},
    {'code': '+504', 'country': 'HN', 'name': 'Honduras'},
    {'code': '+505', 'country': 'NI', 'name': 'Nicaragua'},
    {'code': '+501', 'country': 'BZ', 'name': 'Belize'},
    {'code': '+509', 'country': 'HT', 'name': 'Haiti'},
    {'code': '+1', 'country': 'DO', 'name': 'Dominican Republic'},
    {'code': '+53', 'country': 'CU', 'name': 'Cuba'},
    {'code': '+1', 'country': 'JM', 'name': 'Jamaica'},
    {'code': '+1', 'country': 'TT', 'name': 'Trinidad and Tobago'},
    {'code': '+1', 'country': 'BS', 'name': 'Bahamas'},
    {'code': '+1', 'country': 'BB', 'name': 'Barbados'},
    {'code': '+1', 'country': 'PR', 'name': 'Puerto Rico'},
    {'code': '+251', 'country': 'ET', 'name': 'Ethiopia'},
    {'code': '+237', 'country': 'CM', 'name': 'Cameroon'},
    {'code': '+225', 'country': 'CI', 'name': 'Ivory Coast'},
    {'code': '+221', 'country': 'SN', 'name': 'Senegal'},
    {'code': '+223', 'country': 'ML', 'name': 'Mali'},
    {'code': '+226', 'country': 'BF', 'name': 'Burkina Faso'},
    {'code': '+227', 'country': 'NE', 'name': 'Niger'},
    {'code': '+229', 'country': 'BJ', 'name': 'Benin'},
    {'code': '+228', 'country': 'TG', 'name': 'Togo'},
    {'code': '+243', 'country': 'CD', 'name': 'DR Congo'},
    {'code': '+242', 'country': 'CG', 'name': 'Congo'},
    {'code': '+244', 'country': 'AO', 'name': 'Angola'},
    {'code': '+258', 'country': 'MZ', 'name': 'Mozambique'},
    {'code': '+263', 'country': 'ZW', 'name': 'Zimbabwe'},
    {'code': '+260', 'country': 'ZM', 'name': 'Zambia'},
    {'code': '+267', 'country': 'BW', 'name': 'Botswana'},
    {'code': '+264', 'country': 'NA', 'name': 'Namibia'},
    {'code': '+261', 'country': 'MG', 'name': 'Madagascar'},
    {'code': '+230', 'country': 'MU', 'name': 'Mauritius'},
    {'code': '+250', 'country': 'RW', 'name': 'Rwanda'},
    {'code': '+249', 'country': 'SD', 'name': 'Sudan'},
    {'code': '+218', 'country': 'LY', 'name': 'Libya'},
  ];
  // State field(s) for terms agreement checkbox
  bool termsAccepted = false;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // State field(s) for repeatpassword widget.
  FocusNode? repeatpasswordFocusNode;
  TextEditingController? repeatpasswordTextController;
  late bool repeatpasswordVisibility;
  String? Function(BuildContext, String?)?
      repeatpasswordTextControllerValidator;
  // State field(s) for emailAddress22 widget.
  FocusNode? emailAddress22FocusNode;
  TextEditingController? emailAddress22TextController;
  String? Function(BuildContext, String?)?
      emailAddress22TextControllerValidator;
  // State field(s) for password22 widget.
  FocusNode? password22FocusNode;
  TextEditingController? password22TextController;
  late bool password22Visibility;
  String? Function(BuildContext, String?)? password22TextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    repeatpasswordVisibility = false;
    password22Visibility = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    mobileNumberFocusNode?.dispose();
    mobileNumberTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    repeatpasswordFocusNode?.dispose();
    repeatpasswordTextController?.dispose();

    emailAddress22FocusNode?.dispose();
    emailAddress22TextController?.dispose();

    password22FocusNode?.dispose();
    password22TextController?.dispose();
  }
}
