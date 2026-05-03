import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/firebase_auth/firebase_user_provider.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'l10n/roadygo_i18n.dart';

class AppInitialization {
  static final AppInitialization _instance = AppInitialization._internal();
  static AppInitialization get instance => _instance;

  AppInitialization._internal();

  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  Completer<void> _initializationCompleter = Completer();

  bool get isInitialized => _isInitialized;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  Future<void> get initialization => _initializationCompleter.future;

  Future<void> initializeApp() async {
    if (_isInitialized) return;
    if (_hasError) {
      // Reset if previous initialization failed
      _hasError = false;
      _errorMessage = null;
      _initializationCompleter = Completer();
    }

    try {
      // Step 1: Initialize Firebase with timeout
      await _initializeFirebaseWithTimeout();
      debugPrint('✅ Firebase initialized');

      // Step 5: Initialize app state
      final appState = FFAppState();
      await appState.initializePersistedState();
      debugPrint('✅ App state initialized');

      // Step 6: Setup router
      _appStateNotifier = AppStateNotifier.instance;
      _router = createRouter(_appStateNotifier);
      debugPrint('✅ Router configured');

      // Step 7: Setup user stream
      userStream = goTaxiRiderFirebaseUserStream()
        ..listen((user) {
          _appStateNotifier.update(user);
        });
      debugPrint('✅ User stream configured');

      // Step 8: Stop splash screen after delay
      await Future.delayed(const Duration(milliseconds: 1000));
      _appStateNotifier.stopShowingSplashImage();
      debugPrint('✅ Splash screen hidden');

      _isInitialized = true;
      _initializationCompleter.complete();
    } catch (e, stackTrace) {
      debugPrint('❌ App initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      _hasError = true;
      _errorMessage = e.toString();
      _initializationCompleter.completeError(e);
    }
  }

  Future<void> _initializeFirebaseWithTimeout() async {
    try {
      await Future.any([
        initFirebase(),
        Future.delayed(const Duration(seconds: 15)).then((_) {
          throw TimeoutException(
              'Firebase initialization timed out after 15 seconds');
        }),
      ]);
    } catch (e) {
      // Try fallback initialization
      debugPrint('⚠️ Firebase initialization error, attempting fallback: $e');
      try {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyCLc4nd9hTZiYoD4HWgF6A_6CYQYFpOTc0",
            authDomain: "max-taxi-admin-7n82h1.firebaseapp.com",
            projectId: "max-taxi-admin-7n82h1",
            storageBucket: "max-taxi-admin-7n82h1.appspot.com",
            messagingSenderId: "843578977445",
            appId: "1:843578977445:web:c1fb0f52caf163b4a4314c",
          ),
        );
        debugPrint('✅ Firebase fallback successful');
      } catch (fallbackError) {
        throw Exception(
            'Firebase initialization failed after retry: $fallbackError');
      }
    }
  }

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Stream<BaseAuthUser> userStream;

  GoRouter get router => _router;
  AppStateNotifier get appStateNotifier => _appStateNotifier;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  static const Set<String> _supportedLanguageCodes = {
    'en',
    'sq',
    'mk',
    'tr',
    'sr',
    'hr',
    'fr',
    'de',
    'es',
    'it',
    'pt',
    'nl',
    'sv',
    'nb',
    'nn',
    'da',
    'fi',
    'pl',
    'cs',
    'sk',
    'hu',
    'ro',
    'bg',
    'el',
    'sl',
    'lt',
    'lv',
    'et',
    'is',
    'ga',
    'mt',
    'bs',
    'uk',
    'ru',
    'be',
    'ca',
    'eu',
    'gl',
    'lb',
    'cy',
  };

  static const List<Locale> _supportedLocales = [
    Locale('en', ''),
    Locale('sq', ''),
    Locale('mk', ''),
    Locale('tr', ''),
    Locale('sr', ''),
    Locale('hr', ''),
    Locale('fr', ''),
    Locale('de', ''),
    Locale('es', ''),
    Locale('it', ''),
    Locale('pt', ''),
    Locale('nl', ''),
    Locale('sv', ''),
    Locale('nb', ''),
    Locale('nn', ''),
    Locale('da', ''),
    Locale('fi', ''),
    Locale('pl', ''),
    Locale('cs', ''),
    Locale('sk', ''),
    Locale('hu', ''),
    Locale('ro', ''),
    Locale('bg', ''),
    Locale('el', ''),
    Locale('sl', ''),
    Locale('lt', ''),
    Locale('lv', ''),
    Locale('et', ''),
    Locale('is', ''),
    Locale('ga', ''),
    Locale('mt', ''),
    Locale('bs', ''),
    Locale('uk', ''),
    Locale('ru', ''),
    Locale('be', ''),
    Locale('ca', ''),
    Locale('eu', ''),
    Locale('gl', ''),
    Locale('lb', ''),
    Locale('cy', ''),
  ];

  static const List<LocalizationsDelegate<dynamic>> _localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AppInitialization.instance.initializeApp();
    } catch (e) {
      debugPrint('App initialization failed: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  void setThemeMode(ThemeMode mode) {
    FFAppState().themeMode = mode.name;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<FFAppState?>() ?? FFAppState();
    final appInit = AppInitialization.instance;

    final persistedMode = appState.themeMode;
    final computedThemeMode = switch (persistedMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final selectedLanguageCode =
        _supportedLanguageCodes.contains(appState.languageCode)
            ? appState.languageCode
            : 'en';

    final materialLocale = GlobalMaterialLocalizations.delegate
            .isSupported(Locale(selectedLanguageCode))
        ? Locale(selectedLanguageCode)
        : const Locale('en');

    // Show loading screen during initialization
    if (!appInit.isInitialized) {
      return RoadyGoLanguageScope(
        languageCode: selectedLanguageCode,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RoadyGo',
          localizationsDelegates: _localizationsDelegates,
          supportedLocales: _supportedLocales,
          themeMode: computedThemeMode,
          locale: materialLocale,
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    appInit.hasError
                        ? 'Error loading app: ${appInit.errorMessage}'
                        : 'Initializing RoadyGo...',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  if (appInit.hasError) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _initializeApp(),
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    final lightTheme = LightModeTheme();
    final darkTheme = DarkModeTheme();

    return RoadyGoLanguageScope(
      languageCode: selectedLanguageCode,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'RoadyGo',
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: _supportedLocales,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: false,
          fontFamily: 'Satoshi',
          fontFamilyFallback: const [
            'Noto Sans',
            'Roboto',
            'Arial',
            'sans-serif'
          ],
          primaryColor: lightTheme.primary,
          scaffoldBackgroundColor: lightTheme.primaryBackground,
          cardColor: lightTheme.secondaryBackground,
          dividerColor: lightTheme.lineColor,
          colorScheme: ColorScheme.light(
            primary: lightTheme.primary,
            secondary: lightTheme.secondary,
            surface: lightTheme.secondaryBackground,
            error: lightTheme.error,
            onPrimary: lightTheme.primaryBtnText,
            onSecondary: lightTheme.primaryBtnText,
            onSurface: lightTheme.primaryText,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: lightTheme.primaryBackground,
            foregroundColor: lightTheme.primaryText,
            elevation: 0,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: lightTheme.secondaryBackground,
            titleTextStyle: TextStyle(
              color: lightTheme.primaryText,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            contentTextStyle: TextStyle(
              color: lightTheme.secondaryText,
              fontFamily: 'Satoshi',
              fontSize: 14,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: lightTheme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: lightTheme.lineColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: lightTheme.lineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: lightTheme.primary, width: 1.5),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: lightTheme.primaryText,
            contentTextStyle: TextStyle(color: lightTheme.secondaryBackground),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: false,
          fontFamily: 'Satoshi',
          fontFamilyFallback: const [
            'Noto Sans',
            'Roboto',
            'Arial',
            'sans-serif'
          ],
          primaryColor: darkTheme.primary,
          scaffoldBackgroundColor: darkTheme.primaryBackground,
          cardColor: darkTheme.secondaryBackground,
          dividerColor: darkTheme.lineColor,
          colorScheme: ColorScheme.dark(
            primary: darkTheme.primary,
            secondary: darkTheme.secondary,
            surface: darkTheme.secondaryBackground,
            error: darkTheme.error,
            onPrimary: darkTheme.primaryBtnText,
            onSecondary: darkTheme.primaryBtnText,
            onSurface: darkTheme.primaryText,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: darkTheme.primaryBackground,
            foregroundColor: darkTheme.primaryText,
            elevation: 0,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: darkTheme.secondaryBackground,
            titleTextStyle: TextStyle(
              color: darkTheme.primaryText,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            contentTextStyle: TextStyle(
              color: darkTheme.secondaryText,
              fontFamily: 'Satoshi',
              fontSize: 14,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: darkTheme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: darkTheme.lineColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: darkTheme.lineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: darkTheme.primary, width: 1.5),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: darkTheme.secondaryBackground,
            contentTextStyle: TextStyle(color: darkTheme.primaryText),
          ),
        ),
        themeMode: computedThemeMode,
        locale: materialLocale,
        routerConfig: appInit.router,
      ),
    );
  }
}
