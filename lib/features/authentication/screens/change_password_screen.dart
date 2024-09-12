import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/images.dart';
import 'package:internship_frontend/core/widgets/button_widget.dart';
import 'package:internship_frontend/core/widgets/input_widget.dart';
import 'package:internship_frontend/routes/app_routes.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../core/utils/loading.dart';
import '../../../core/utils/toast.dart';
import '../../../data/services/user_service.dart';
import '../../onboarding/screens/page_right_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String token;

  const ChangePasswordScreen({required this.token, super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? newPassword, confirmNewPassword;

  final _userService = UserService(); // Initialize UserService

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;

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
                                              padding: Responsive.isMobile(context)?
                                              const EdgeInsets.all(0):
                                              const EdgeInsets.all(Constants.kDefaultPadding),
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Center(child: Image.asset(ImagePath.changePasswordImage,height: 200,)),
                                                    Text(
                                                      'Change Password',
                                                      style: theme.textTheme.headlineLarge?.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 30),
                                                    InputWidget(
                                                      obscureText: !showPassword,
                                                      hintText: 'Enter New Password',
                                                      prefixIcon: Icons.lock,
                                                      maxLines: 1,
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          showPassword
                                                              ? Icons.visibility
                                                              : Icons.visibility_off,
                                                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            showPassword = !showPassword;
                                                          });
                                                        },
                                                      ),
                                                      onChanged: (String? value) => newPassword = value!,
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
                                                      hintText: 'Confirm New Password',
                                                      prefixIcon: Icons.lock,
                                                      maxLines: 1,
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          showConfirmPassword
                                                              ? Icons.visibility
                                                              : Icons.visibility_off,
                                                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            showConfirmPassword = !showConfirmPassword;
                                                          });
                                                        },
                                                      ),
                                                      onChanged: (String? value) => confirmNewPassword = value!,
                                                      validator: (String? value) {
                                                        return value!.isEmpty
                                                            ? "Field is required"
                                                            : value.length < 6
                                                            ? "Password must be at least 6 characters"
                                                            : value != newPassword
                                                            ? "Passwords do not match"
                                                            : null;
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    AppButton(
                                                      onPressed: () async {
                                                        if (_formKey.currentState?.validate() ?? false) {
                                                          await _changePassword(context);
                                                        }
                                                      },
                                                      text:  'Change Password',
                                                    ),
                                                    const SizedBox(height: 20),
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
                                  if (Responsive.isDesktop(context))
                                    const PageRightSide(
                                      title: "Set a New Password,\nKeep your account secure! 🔐",
                                      icon: ImagePath.changePasswordSvg,
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

  Future<void> _changePassword(BuildContext context) async {

    // Show loading dialog
    showLoadingDialog(context);

    final response = await _userService.changePassword(widget.token, newPassword!);

    final responseBody = jsonDecode(response.body);
    String message = responseBody['message'] ?? 'An error occurred';

    // Check if the widget is still mounted
    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      showSuccessToast(context, message);
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      showErrorToast(context, message);
    }
  }
}
