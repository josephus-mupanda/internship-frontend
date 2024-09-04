import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// import 'screens/onboarding_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/reset_password_screen.dart';
// import 'screens/dashboard_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case AppRoutes.splash:
      //   return MaterialPageRoute(builder: (_) => SplashScreen());
      // case AppRoutes.onboarding:
      //   return MaterialPageRoute(builder: (_) => OnboardingScreen());
      // case AppRoutes.login:
      //   return MaterialPageRoute(builder: (_) => LoginScreen());
      // case AppRoutes.register:
      //   return MaterialPageRoute(builder: (_) => RegisterScreen());
      // case AppRoutes.resetPassword:
      //   return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => DashboardScreen());
    // Handle other routes here...
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }
}
