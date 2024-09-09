import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/widgets/button_widget.dart';
import '../../onboarding/screens/page_right_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String? email,username, password, confirmPassword, phoneNumber;

  bool showPassword = false;
  bool showConfirmPassword = false;

  final _phoneNumberRegex = RegExp(r'^\+?[0-9]{10,15}$'); // Example phone number regex
  final _emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"); // Example email regex

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
                                                  Center(child: Image.asset(ImagePath.registerImage, height: 100,)),
                                                  Text(
                                                    'Sign Up',
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
                                                    obscureText: false,
                                                    hintText: 'Enter Email',
                                                    keyboardType: TextInputType.emailAddress,
                                                    prefixIcon: Icons.alternate_email,
                                                    onChanged: (String? value) => email = value!,
                                                    validator: (String? value) {
                                                      return value!.isEmpty ? "Field is required" : !_emailRegex.hasMatch(value) ? "Invalid email format" : null;
                                                    },
                                                  ),
                                                  InputWidget(
                                                    obscureText: false,
                                                    hintText: 'Enter Phone number',
                                                    keyboardType: TextInputType.phone,
                                                    prefixIcon: Icons.phone,
                                                    onChanged: (String? value) => phoneNumber = value!,
                                                    validator: (String? value) {
                                                      return value!.isEmpty ? "Field is required" : !_phoneNumberRegex.hasMatch(value) ? "Invalid phone number format" : null;
                                                    },
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
                                                  InputWidget(
                                                    obscureText: !showConfirmPassword,
                                                    hintText: 'Confirm Password',
                                                    prefixIcon: Icons.lock,
                                                    maxLines: 1,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          showConfirmPassword = !showConfirmPassword;
                                                        });
                                                      },
                                                    ),
                                                    onChanged: (String? value) => confirmPassword = value!,
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
                                                    onPressed: () {
                                                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                                                    },
                                                    text:  'Sign Up',
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
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 10),
                                                    child: Row(
                                                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        const Spacer(),
                                                        SizedBox(
                                                          height: 25,
                                                          child: Image.asset(ImagePath.google),
                                                        ),
                                                        const SizedBox(width: Constants.kDefaultPadding,),
                                                        Text(
                                                          'Sign up with Google',
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
                                                      Navigator.pushReplacementNamed(
                                                        context,
                                                        AppRoutes.login,
                                                      );
                                                    },
                                                    child: Center(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Have an Account? ',
                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                color: theme.colorScheme.onBackground,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: 'Login',
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
                                      title: "Join Us,\nCreate an account and start exploring! ✨",
                                      icon: ImagePath.registerSvg,
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
