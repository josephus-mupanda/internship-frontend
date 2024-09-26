import 'package:flutter/material.dart';
import 'package:internship_frontend/features/group/components/header.dart';
import 'package:internship_frontend/features/loan/loan_onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/preferences.dart';
import '../../core/widgets/repay_loan_dialog.dart';
import '../../core/widgets/request_loan_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';
import 'components/header.dart';
import 'components/loan_card.dart';

class LoanScreen extends StatefulWidget {
  final Group group;

  const LoanScreen({super.key, required this.group,});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  bool _showOnboarding = false;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    return _showOnboarding
        ?
    LoanOnboardingScreen(
        onboardingComplete: () {
            // Handle completion of onboarding here if needed
            setState(() {
              _showOnboarding = false; // Go back to LoanScreen
            });
          }
        )
        :
    Scaffold (
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: selectedGroup == null
              ?
          const Center(child: Text("Select first a group ...."))
              :
          Column(
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
                                title: 'Request Loan',
                                content: 'Enter the amount you wish to borrow.',
                                nameYes: 'Request',
                                nameNo: 'Cancel',
                                onLoanRequested: () {
                                  // Refresh the UI or perform necessary actions
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
                                title: 'Repay Loan',
                                content: 'Enter the amount you wish to repay.',
                                nameYes: 'Repay',
                                nameNo: 'Cancel',
                                onLoanRepaid: () {
                                  // Refresh the UI or perform necessary actions
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
                          // Implement your logic for viewing loan history
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Explaining How Loans Work
                      LoanCard(
                        icon: Icons.info,
                        iconColor: Colors.purple,
                        title: 'How Loans Work',
                        press: ()  async {
                          await Preferences.setHasSeenLoanOnboarding(false);
                          setState(() {
                            _showOnboarding = true; // Set to true to show onboarding
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
