import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../onboarding/screens/page_right_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? username, password;

  bool showPassword = false;

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
                      fit: StackFit.loose,
                      children: [
                        Center(
                          child: SingleChildScrollView(
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
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                          child: Card(
                                            color: Theme.of(context).cardColor,
                                            child: Padding(
                                              padding: const EdgeInsets.all(Constants.kDefaultPadding),
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacementNamed(
                                                        context,
                                                        AppRoutes.dashboard,
                                                      );
                                                    },
                                                    child: Container(
                                                      width: size.width,
                                                      decoration: BoxDecoration(
                                                        color: theme.primaryColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 10, vertical: 20),
                                                      child: Center(
                                                        child: Text(
                                                          'Sign In',
                                                          style: theme.textTheme.labelLarge?.copyWith(
                                                            color: theme.colorScheme.onPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacementNamed(
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
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 15),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                          child: Image.asset(ImagePath.google),
                                                        ),
                                                        Text(
                                                          'Sign In with Google',
                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                            color: theme.colorScheme.onBackground,
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacementNamed(
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
}
