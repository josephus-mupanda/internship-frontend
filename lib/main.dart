import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internship_frontend/data/providers/contribution_provider.dart';
import 'package:internship_frontend/data/providers/loan_provider.dart';
import 'package:internship_frontend/data/providers/theme_provider.dart';
import 'package:internship_frontend/data/providers/transaction_provider.dart';
import 'package:internship_frontend/data/providers/user_provider.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:internship_frontend/routes/route_generator.dart';
import 'package:internship_frontend/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'core/utils/preferences.dart';
import 'data/providers/group_provider.dart';
import 'data/providers/menu_provider.dart';
import 'data/providers/member_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPreferences
  await Preferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => ContributionProvider(),),
        ChangeNotifierProvider(create: (_) => TransactionProvider(),),
        ChangeNotifierProvider(create: (_) => LoanProvider(),)
      ],
      child: const MyApp(),
    ),
  );
  // Handle incoming links
  handleIncomingLinks();
}

void handleIncomingLinks() async {
  final appLinks = AppLinks();

  // Handle the initial link (mobile platforms)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {

    final Uri? initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      _handleIncomingUrl(initialLink);
    }
    // Handle future incoming links (mobile platforms)
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.hasQuery) {
        _handleIncomingUrl(uri);
      }
    });
  }
  // Web URL handling
  if (kIsWeb) {
    final Uri uri = Uri.base; // Gets the current URL in the browser
    if (uri.hasQuery) {
      _handleIncomingUrl(uri);
    }
  }
}

void _handleIncomingUrl(Uri uri) {
  final String? token = uri.queryParameters['token'];
  final String? action = uri.queryParameters['action'];

  if (token != null) {
    // Ensure navigatorKey is defined in your app for navigation
    if (navigatorKey.currentContext != null) {
      if (action == 'reset-password') {
        Navigator.pushReplacementNamed(
          navigatorKey.currentContext!,
          AppRoutes.resetPassword,
          arguments: token,
        );
      } else if (action == 'confirm-email') {
        Navigator.pushReplacementNamed(
          navigatorKey.currentContext!,
          AppRoutes.confirmEmail,
          arguments: token,
        );
      } else {
        if (kDebugMode) {
          print('Unknown action: $action');
        }
      }
    } else {
      if (kDebugMode) {
        print('No context available for navigation');
      }
    }
  } else {
    if (kDebugMode) {
      print('No token found in URL');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ikimina',
      theme: !themeProvider.isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: navigatorKey, // Use the global navigatorKey
    );
  }
}

// Define a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
