import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/group.dart';
import 'package:internship_frontend/data/services/auth_service.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/data/services/loan_service.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/loading.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/loan.dart';
import '../../routes/app_routes.dart';

class RequestLoanDialog extends StatefulWidget {
  final Group group;
  final String title;
  final String content;
  final String nameYes;
  final String nameNo;
  final VoidCallback onLoanRequested;

  const RequestLoanDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    required this.onLoanRequested,
    super.key, required this.group,
  });

  @override
  State<RequestLoanDialog> createState() => _RequestLoanDialogState();
}

class _RequestLoanDialogState extends State<RequestLoanDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoanService _loanService = LoanService();
  final AuthService _authService = AuthService();
  String? amount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Center(
        child: Column(
          children: [
            const SizedBox(height: Constants.kDefaultPadding / 2),
            Text(
              widget.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.request_quote,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: Constants.kDefaultPadding / 2),
            Text(
              widget.content,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.kDefaultPadding / 2),
            Form(
              key: formKey,
              child: InputWidget(
                obscureText: false,
                hintText: 'Enter Loan Amount',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.monetization_on,
                onChanged: (String? value) => amount = value!,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Loan amount is required";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter a valid amount";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: Constants.kDefaultPadding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        await _requestLoan();
                      }
                    },
                    icon: const Icon(FeatherIcons.check, color: Colors.white, size: 16),
                    label: Text(
                      widget.nameYes,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: Constants.kDefaultPadding / 2),
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: theme.colorScheme.background,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(FeatherIcons.x, color: Colors.black, size: 16),
                    label: Text(
                      widget.nameNo,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestLoan() async {
    final Loan loan = Loan(
        groupId: widget.group.id! ,
        amount: double.parse(amount!)
    );
    // Show loading dialog
    showLoadingDialog(context);

    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
       await _loanService.requestLoan(loan, token, context);
      formKey.currentState?.reset();
      setState(() {
        amount = null;
      });
      widget.onLoanRequested();
    } catch (e) {
      // Handle errors and show a toast or dialog with the error message
      showErrorToast(context, 'An error occurred during loan request');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.of(context).pop(); // Close the dialog
    }
  }
}
