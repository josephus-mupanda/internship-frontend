import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/toast.dart';
import '../../../core/widgets/button_widget.dart';
import '../../../data/services/user_service.dart';
import '../../onboarding/screens/page_right_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  String? email;

  final _emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"); // Example email regex

  final _userService = UserService(); // Initialize UserService

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                          padding: Responsive.isMobile(context)?
                                          const EdgeInsets.all(0):
                                          const EdgeInsets.all(Constants.kDefaultPadding),
                                          child: Card(
                                            color: Theme.of(context).cardColor,
                                            child: Padding(
                                              padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                              child: Form(
                                                key:_formKey,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Center(child: Image.asset(ImagePath.resetPasswordImage,height: 100,)),
                                                    Text(
                                                      'Forgot\nPassword',
                                                      style: theme.textTheme.headlineLarge?.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 30),
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
                                                    const SizedBox(height: 10),
                                                    AppButton(
                                                      onPressed: () async {
                                                        if (_formKey.currentState?.validate() ?? false) {
                                                          await _resetPassword(context);
                                                        }
                                                      },
                                                      text:  'Reset Password',
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
                                  ),
                                  // Only show the right-side panel on desktop screens
                                  if (Responsive.isDesktop(context)) // Adjust this to the right place
                                    const PageRightSide(
                                      title: "Forgot Your Password?\nWe'll help you reset it! 🔒",
                                      icon: ImagePath.resetPasswordSvg,
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

  Future<void> _resetPassword(BuildContext context) async {
    if (email == null || email!.isEmpty) {
      showErrorToast(context, "Email is required");
      return;
    }
    // Show loading dialog
    showLoadingDialog(context);

    final response = await _userService.resetPassword(email!);

    final responseBody = jsonDecode(response.body);
    String message = responseBody['message'] ?? 'An error occurred';
    // Check if the widget is still mounted
    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      showSuccessToast(context, message);
      // Reset the form fields
      _formKey.currentState?.reset();
      setState(() {
        email = null;
      });
      //Navigator.pushNamed(context, AppRoutes.login);
    } else if (response.statusCode == 400) {
      showErrorToast(context, message);
    } else if (response.statusCode == 404) {
      showErrorToast(context, message);
    } else {
      showErrorToast(context, "An unexpected error occurred");
    }
  }
}
