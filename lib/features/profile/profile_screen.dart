import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/loading.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/button_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/user.dart';
import '../../data/providers/user_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../routes/app_routes.dart';
import '../main/components/side_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();


  String _username = "";
  String _email = "";
  String _phoneNumber = "";

  final _userService = UserService();
  final _authService = AuthService();

  final _phoneNumberRegex = RegExp(r'^\+?[0-9]{10,15}$');
  final _emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Function to load user data
  Future<void> _loadUserProfile() async {
    // Show loading dialog
    showLoadingDialog(context);
    try {
      // Retrieve the token and username from secure storage
      String? token = await _authService.getAccessToken();
      String? username = await _authService.getUsernameFromToken();

      if (token == null || username == null) {
        //showErrorToast(context, 'Session expired. Please log in again.');
        // Use logout method to clear session data and redirect to login
        await _authService.logout(context);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        return;
      }
      // Call the UserService to get the user details
      final response = await _userService.getUserByUsername(username, token, context);
      if (response != null) {
        // Update the state with the fetched user data
        setState(() {
          _username = response.username;
          _email = response.email!;
          _phoneNumber = response.phoneNumber!;

          // Update controllers with fetched values
          _usernameController.text = _username;
          _emailController.text = _email;
          _phoneNumberController.text = _phoneNumber;

        });
      }
    } catch (e) {
      showErrorToast(context, 'Failed to load user profile');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
        color:Theme.of(context).cardColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Search bar
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(
                            Icons.menu,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),
              // User Profile Update Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update Profile", style: theme.textTheme.titleLarge),
                      const SizedBox(height: Constants.kDefaultPadding),

                      // Username Field
                      InputWidget(
                        kController: _usernameController,
                        //hintText: "Username",
                        prefixIcon: Icons.person,
                        onChanged: (value) {
                          setState(() {
                            _username = value; // Update username on change
                          });
                        },
                        //kInitialValue: _username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),

                      // Email Field
                      InputWidget(
                        kController: _emailController,
                        //hintText: "Email",
                        prefixIcon: Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _email = value; // Update email on change
                          });
                        },
                        //kInitialValue: _email,
                        validator: (String? value) {
                          return value!.isEmpty ? "Field is required" : !_emailRegex.hasMatch(value) ? "Invalid email format" : null;
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),

                      // Phone Number Field
                      InputWidget(
                        kController: _phoneNumberController,
                        //hintText: "Phone Number",
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            _phoneNumber = value; // Update phone number on change
                          });
                        },
                        //kInitialValue: _phoneNumber,
                        validator: (String? value) {
                          return value!.isEmpty ? "Field is required" : !_phoneNumberRegex.hasMatch(value) ? "Invalid phone number format" : null;
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      AppButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _updateProfile(context);
                          }
                        },
                        text:  'Update Profile',
                      ),
                    ]
                  ),
                )
              ),
            ]
          )
        )
      )
    );
  }

  Future<void> _updateProfile(BuildContext context) async {
    // Create User object with updated data
    final user = User(
      username: _username,
      email: _email,
      phoneNumber: _phoneNumber,
    );
    // Show loading dialog
    showLoadingDialog(context);

    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (!context.mounted) return;
    if (token == null) {
      //showErrorToast(context, 'Session expired. Please log in again.');
      // Use logout method to clear session data and redirect to login
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    try {
      final response = await _userService.updateUser(user, token, context);
      _formKey.currentState?.reset();
      setState(() {
        _username = user.username;
        _email = user.email!;
        _phoneNumber = user.phoneNumber!;
      });
      // Update the UserProvider with the new user data
      Provider.of<UserProvider>(context, listen: false).updateUser(user);

      showSuccessToast(context, "Profile updated successfully");
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'Failed to update profile');
    } finally {
      Navigator.of(context).pop();
    }
  }
}
