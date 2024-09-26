
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/loan.dart';
import 'package:internship_frontend/data/providers/loan_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
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

class LoanHistoryScreen extends StatefulWidget {
  final Group group;

  const LoanHistoryScreen({super.key, required this.group,});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();
  List<Loan> loans = [];

  Future<void> fetchLoans() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      showErrorToast(context, 'Token not found. Please log in again.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    try {
      final response = await _groupService.getLoansByGroup(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response!.body);
        // Convert the JSON data into a list of Loan objects
        List<Loan> fetchedLoans = data.map((loansJson) {
          return Loan.fromJson(loansJson);
        }).toList();
        // Update your state or provider with the fetched loans
        setState(() {
          loans = fetchedLoans;
          Provider.of<LoanProvider>(context, listen: false).setLoans(loans);
        });
      } else {
        // Handle the error if the status code is not 200
        throw Exception("Failed to load loans");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching loans: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLoans();
  }

  void _onLoanDeleted() {
    // Refresh the list after deletion
    fetchLoans();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              Header(group: selectedGroup!),
              const Divider(thickness: 1),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: InputWidget(
                        hintText: 'Search my loan here...',
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
