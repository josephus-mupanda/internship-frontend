import 'package:flutter/material.dart';
import 'package:internship_frontend/features/authentication/screens/confirm_email_screen.dart';
// import 'screens/dashboard_screen.dart';
import '../features/authentication/screens/change_password_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/reset_password_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case AppRoutes.changePassword:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(token: args),
          );
        }
        return _errorRoute();

      case AppRoutes.confirmEmail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ConfirmEmailScreen(token: args),
          );
        }
        return _errorRoute();
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => DashboardScreen());
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
