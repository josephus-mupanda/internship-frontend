
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/data/models/contribution.dart';
import 'package:internship_frontend/data/providers/contribution_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

import '../member/components/header.dart';

class ContributionScreen extends StatefulWidget {
  final Group group;

  const ContributionScreen({super.key, required this.group,});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();
  List<Contribution> contributions = [];

  Future<void> fetchContributions() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    try {
      final response = await _groupService.getContributionsByGroup(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response!.body);
        // Convert the JSON data into a list of Contribution objects
        List<Contribution> fetchedContributions = data.map((contributionsJson) {
          return Contribution.fromJson(contributionsJson);
        }).toList();
        // Update your state or provider with the fetched contributions
        setState(() {
          contributions = fetchedContributions;
          Provider.of<ContributionProvider>(context, listen: false).setContributions(contributions);
        });
      } else {
        // Handle the error if the status code is not 200
        throw Exception("Failed to load contributions");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching contributions: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContributions();
  }

  void _onContributionDeleted() {
    // Refresh the list after deletion
    fetchContributions();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              MemberHeader(group: widget.group),
              const Divider(thickness: 1),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: InputWidget(
                        hintText: 'Search contribution here...',
                        keyboardType: TextInputType.name,
                        suffixIcon: IconButton(
                          icon: Icon(
                            FeatherIcons.search,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                          },
                        ),
                        onChanged: (String? value) {},
                        validator: (String? value) {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.chevronDown,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Sort by date",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Icon(
                      FeatherIcons.filter,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Constants.kDefaultPadding),
                  child: Column(
                    children: [
                      // This is our Search bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

