import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/preferences.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/button_widget.dart';
import '../../../data/models/user.dart';
import '../../../data/services/auth_service.dart';
import '../../onboarding/screens/page_right_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? username, password;

  final _authService = AuthService(); // Initialize AuthService

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(maxWidth: Constants.kMaxWidth ?? double.infinity),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Stack(
                      //fit: StackFit.loose,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            height: size.height,
                            width: size.width,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: Responsive.isMobile(context)?
                                          const EdgeInsets.all(0):
                                          const EdgeInsets.all(Constants.kDefaultPadding),
                                      child: Card(
                                        color: Theme.of(context).cardColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Image.asset(ImagePath.loginImage,
                                                  height: 200,),
                                                ),
                                                Text(
                                                  'Sign In',
                                                  style: theme.textTheme.headlineLarge?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                InputWidget(
                                                  obscureText: false,
                                                  hintText: 'Enter Username',
                                                  keyboardType: TextInputType.name,
                                                  prefixIcon: Icons.person,
                                                  onChanged: (String? value) => username = value!,
                                                  validator: (String? value) => value!.isEmpty ? "Field is required" : null,
                                                ),
                                                InputWidget(
                                                  obscureText: !showPassword,
                                                  hintText: 'Enter Password',
                                                  prefixIcon: Icons.lock,
                                                  maxLines: 1,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      showPassword ? Icons.visibility : Icons.visibility_off,
                                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        showPassword = !showPassword;
                                                      });
                                                    },
                                                  ),
                                                  onChanged: (String? value) => password = value!,
                                                  validator: (String? value) {
                                                    return value!.isEmpty
                                                        ? "Field is required"
                                                        : value.length < 6
                                                        ? "Password must be at least 6 characters"
                                                        : null;
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                AppButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState?.validate() ?? false) {
                                                      await _login(context);
                                                    }
                                                  },
                                                  text:  'Sign In',
                                                ),
                                                const SizedBox(height: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes.resetPassword,
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Forgot Password? ',
                                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                              color: theme.colorScheme.onBackground,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: 'Reset Here',
                                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                              color: theme.primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    const Expanded(child: Divider()),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Text('OR', style: theme.textTheme.bodyMedium),
                                                    ),
                                                    const Expanded(child: Divider()),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: theme.primaryColor),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 10),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      const Spacer(),
                                                      SizedBox(
                                                        height: 25,
                                                        child: Image.asset(ImagePath.google),
                                                      ),
                                                      const SizedBox(width: Constants.kDefaultPadding),
                                                      Text(
                                                        'Sign In with Google',
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          color: theme.colorScheme.onBackground,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes.register,
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'New to this app? ',
                                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                              color: theme.colorScheme.onBackground,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: 'Register',
                                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                              color: theme.primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Only show the right-side panel on desktop screens
                                if (Responsive.isDesktop(context)) // Adjust this to the right place
                                  const PageRightSide(
                                    title: "Welcome Back,\nLogin to continue your adventure! 👋",
                                    icon: ImagePath.loginSvg,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _login(BuildContext context) async {
    final user = User(
      username: username!,
      password: password!,
    );
    // Show loading dialog
    showLoadingDialog(context);

    try {
      final token = await _authService.login(context, user);
      if (token != null) {
        // Reset the form fields
        _formKey.currentState?.reset(); // Clear the form
        setState(() {
          username = null;
          password = null;
        });

        Navigator.pushReplacementNamed(
            context, AppRoutes.dashboard); // Navigate to mainScreen on success
      }
    } on AuthException catch (e) {
      // Check the status code and show the appropriate message
      if (!context.mounted) return ;
      if (e.statusCode == 401) {
        showErrorToast(context, e.message); // Handle unauthorized
      } else if (e.statusCode == 403) {
        showWarningToast(context, e.message); // Handle forbidden
      } else {
        showErrorToast(context, e.message); // Other errors
      }
    } catch (e) {
      if (!context.mounted) return ;
      showErrorToast(context, "An unexpected error occurred.");
    }
    finally {
      Navigator.of(context).pop();
    }
  }
}
