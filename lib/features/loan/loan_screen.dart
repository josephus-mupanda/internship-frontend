import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internship_frontend/data/providers/menu_provider.dart';
import 'package:internship_frontend/features/group/components/header.dart';
import 'package:internship_frontend/features/loan/loan_onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/repay_loan_dialog.dart';
import '../../core/widgets/request_loan_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/loan.dart';
import '../../data/models/member.dart';
import '../../data/providers/loan_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/group_service.dart';
import '../../routes/app_routes.dart';
import '../../routes/route_generator.dart';
import '../group/empty_group_screen.dart';
import '../group/empty_join_group_screen.dart';
import 'components/loan_card.dart';

class LoanScreen extends StatefulWidget {
  final Group group;
  const LoanScreen({super.key, required this.group,});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {

  bool _showOnboarding = false;
  MyMember? currentMember;
  List<ReservedAmount> loans = [];

  bool _isLoading = true;
  bool _loading = true;

  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();

  @override
  void initState() {
    super.initState();
    Group selectedGroup = widget.group;
    _loadUsernameAndMember(selectedGroup);
    _checkUserInGroup();
    fetchLoans();
  }

  // Fetch the username from the token
  Future<void> _loadUsernameAndMember(Group selectedGroup) async {
    try {
      String? token = await _authService.getAccessToken();
      int? userId =  Preferences.getUserId();

      if (token != null && userId != null ) {
        final response = await _groupService.getMemberByUsername(token, selectedGroup.id!, userId, context);
        if (response != null) {
          setState(() {
            currentMember = MyMember.fromJson(jsonDecode(response.body));
            _isLoading = false;
            print('Current Member >>>>>>>>>>>>>>>>>>>>>>>>>>>>>: ${currentMember?.toJson()}');
          });
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showErrorToast(context, "Failed to load user data.");
    }
  }

  Future<void> fetchLoans() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      final response = await _groupService.getLoansByGroup(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<ReservedAmount> fetchedLoans = data.map((loansJson) {
          return ReservedAmount.fromJson(loansJson);
        }).toList();
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

  // Function to check if the user is in the group
  Future<void> _checkUserInGroup() async {
    String? token = await _authService.getAccessToken();
    int? userId =  Preferences.getUserId();
    if (token == null && userId == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      bool isInGroup = await _groupService.isUserInGroup(widget.group.id!, userId!, token!, context);
      print("isUserInGroup result: $isInGroup");
      if (mounted) {
        setState(() {
          widget.group.isInGroup = isInGroup;
          _loading = false;
        });
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred while checking membership.');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final selectedGroup = menuProvider.selectedGroup;

    if (_loading) {
      return  Scaffold(
        backgroundColor:theme.colorScheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    else
    if (!widget.group.isInGroup) {
      return const EmptyJoinGroupScreen();
    }
    else if (selectedGroup == null) {
      // No group selected (fallback)
      return const EmptyGroupScreen();
    }
    return _showOnboarding
        ?
    LoanOnboardingScreen(
        onboardingComplete: () {
            setState(() {
              _showOnboarding = false;
            });
          }
        )
        :
    Scaffold (
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              GroupHeader(group: selectedGroup),
              const Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.kDefaultPadding),
                  child: Column(
                    children: [
                      // Loan Card for Requesting a Loan
                      LoanCard(
                        icon: Icons.request_quote, // Choose an appropriate icon
                        iconColor: Colors.blue,
                        title: 'Request Loan',
                        press: () {
                          // Show Request Loan Dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return RequestLoanDialog(
                                group: selectedGroup,
                                title: 'Request Loan',
                                content: 'Enter the amount you wish to borrow.',
                                nameYes: 'Request',
                                nameNo: 'Cancel',
                                onLoanRequested: () {
                                  fetchLoans();
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Repaying a Loan
                      LoanCard(
                        icon: Icons.attach_money,
                        iconColor: Colors.green,
                        title: 'Repay Loan',
                        press: () {
                          // Show Repay Loan Dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return RepayLoanDialog(
                                group: selectedGroup,
                                title: 'Repay Loan',
                                content: 'Enter the amount you wish to repay.',
                                nameYes: 'Repay',
                                nameNo: 'Cancel',
                                onLoanRepaid: () {
                                  fetchLoans();
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Loan History
                      LoanCard(
                        icon: Icons.history,
                        iconColor: Colors.orange,
                        title: 'Loan History',
                        press: () {
                          if (currentMember != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.loanGroupScreen,
                              arguments: MyArguments(selectedGroup, currentMember!),
                            );
                          } else {
                            showErrorToast(context, 'Failed to load current member data.');
                          }
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      LoanCard(
                        icon: Icons.info,
                        iconColor: Colors.purple,
                        title: 'How Loans Work',
                        press: ()  async {
                          await Preferences.setHasSeenLoanOnboarding(false);
                          setState(() {
                            _showOnboarding = true;
                          });
                        },
                      ),
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
