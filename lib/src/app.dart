import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mvc/controller/auth_wrapper.dart';
import 'settings/settings_controller.dart';
import 'tools/styles.dart';

const Color primary = Color(0xFF29734B);
const Color secondary = Color(0xFFffb33e);

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, widget) {
        return AnimatedBuilder(
          animation: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              restorationScopeId: 'app',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
              ],
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: getLightTheme(),
              darkTheme: getDarkTheme(),
              themeMode: settingsController.themeMode,
              locale: settingsController.localeMode,
              home: AuthWrapper(
                settingsController: settingsController,
              ),
            );
          },
        );
      },
    );
  }

  ThemeData getLightTheme() {
    return ThemeData.light(useMaterial3: false).copyWith(
      primaryColor: primary,
      colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: primary,
            secondary: secondary,
          ),
      scaffoldBackgroundColor: Colors.white, //headline5
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      buttonTheme: const ButtonThemeData(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withAlpha(100),
        selectionHandleColor: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: Styles.poppins(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: Styles.semiBold,
        ),
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.black),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          statusBarColor: Colors.transparent, //only for android
          statusBarIconBrightness: Brightness.dark, //only for android
          statusBarBrightness: Brightness.light, //only for iOS
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            displayLarge: const TextStyle(color: Color(0xFF000000)),
            displayMedium: const TextStyle(color: Color(0xFF0C121A)),
            displaySmall: const TextStyle(color: Color(0xFF565656)),
            headlineLarge: const TextStyle(color: Color(0xFFB4B4B4)),
            headlineMedium: const TextStyle(color: Color(0xFFE7E7E7)),
            headlineSmall: const TextStyle(color: Color(0xFFFFFFFF)),
            titleLarge: const TextStyle(color: Color(0xFFFFFFFF)),
          ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark(useMaterial3: false).copyWith(
      primaryColor: primary,
      colorScheme: ThemeData.light().colorScheme.copyWith(
            secondary: secondary,
          ),
      scaffoldBackgroundColor: Colors.black,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      buttonTheme: const ButtonThemeData(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withAlpha(100),
        selectionHandleColor: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: Styles.poppins(
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: Styles.semiBold,
        ),
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          statusBarColor: Colors.transparent, //only for android
          statusBarIconBrightness: Brightness.light, //only for android
          statusBarBrightness: Brightness.dark, //only for iOS
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            displayLarge: const TextStyle(color: Color(0xFFFFFFFF)),
            displayMedium: const TextStyle(color: Color(0xFFE7E7E7)),
            displaySmall: const TextStyle(color: Color(0xFFB4B4B4)),
            headlineLarge: const TextStyle(color: Color(0xFF565656)),
            headlineMedium: const TextStyle(color: Color(0xFF0C121A)),
            headlineSmall: const TextStyle(color: Color(0xFF000000)),
            titleLarge: const TextStyle(color: Color(0xFFFFFFFF)),
          ),
    );
  }
}
