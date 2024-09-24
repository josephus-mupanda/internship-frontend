import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
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
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: selectedGroup == null
              ?
          const Center(child: Text("Select first a group ...."))
              :
          Column(
            children: [
              LoanHeader(group: selectedGroup),
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
                          // Implement your logic for requesting a loan
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Repaying a Loan
                      LoanCard(
                        icon: Icons.attach_money, // Choose an appropriate icon
                        iconColor: Colors.green,
                        title: 'Repay Loan',
                        press: () {
                          // Implement your logic for repaying a loan
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Loan History
                      LoanCard(
                        icon: Icons.history, // Choose an appropriate icon
                        iconColor: Colors.orange,
                        title: 'Loan History',
                        press: () {
                          // Implement your logic for viewing loan history
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // Loan Card for Explaining How Loans Work
                      LoanCard(
                        icon: Icons.info, // Choose an appropriate icon
                        iconColor: Colors.purple,
                        title: 'How Loans Work',
                        press: () {
                          // Implement your logic for explaining loan workings
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
