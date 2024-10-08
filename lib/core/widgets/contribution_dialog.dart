
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/contribution.dart';
import 'package:internship_frontend/data/models/group.dart';
import 'package:internship_frontend/data/models/member.dart';
import 'package:internship_frontend/data/services/auth_service.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import '../../themes/color_palette.dart';
import '../constants/constants.dart';
import '../utils/loading.dart';
import '../utils/toast.dart';
import 'drop_down_widget.dart';
import 'input_widget.dart';

class ContributionDialog extends StatefulWidget {
  final Group group;
  final Member member;
  final String title;
  final String content;
  final String nameYes;
  final String nameNo;
  final VoidCallback onContributionCreated;

  const ContributionDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    required this.onContributionCreated,
    super.key, required this.group, required this.member});

  @override
  State<ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends State<ContributionDialog> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _groupService = GroupService();
  final _authService = AuthService();

  double? amount;
  String? selectedMonth;
  String? selectedYear;

  List<String> availableMonths = [];

  Future<void> fetchAvailableMonths() async {
    String? token = await _authService.getAccessToken();
    if (token != null) {
      List<String>? months = await _groupService.getAvailableMonths(widget.group.id!, token, context);
      if (months != null) {
        setState(() {
          availableMonths = months;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableMonths();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Center(
        child: Column(
          children: [
            const SizedBox(height: Constants.kDefaultPadding / 2),
            Text( widget.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.content,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: Constants.kDefaultPadding/2,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownWidget(
                    hintText: 'Select Month',
                    items: availableMonths,
                    onChanged: (String? value) {
                      setState(() {
                        selectedMonth = value?.split(' ')[0];
                        selectedYear = value?.split(' ')[1];
                      });
                    },
                    validator: (String? value) =>
                    value == null || value.isEmpty
                        ? "Please select a month"
                        : null,
                  ),
                  InputWidget(
                    obscureText: false,
                    hintText: 'Monthly Amount',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.monetization_on,
                    kInitialValue: '100',
                    kReadOnly: true,
                    onChanged: (String? value) => amount = double.tryParse(value ?? '100'),  // Set amount to default value
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Monthly amount is required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Constants.kDefaultPadding/2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child:  TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: ColorPalette.primaryColor,
                        //foregroundColor: kTextColor, // Set the text color here
                      ),
                      onPressed:()  async {
                        if (formKey.currentState?.validate() ?? false) {
                          await _createContribution();
                        }
                      },
                      icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                      label:Text(
                          widget.nameYes,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white
                          )
                      ),
                    )
                ),
                const SizedBox(
                  width: Constants.kDefaultPadding/2,
                ),
                Expanded(
                    child:  TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: theme.colorScheme.background,
                        // foregroundColor: kTextColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                      label: Text(
                        widget.nameNo,
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> _createContribution() async {
    if (selectedMonth == null || selectedYear == null) {
      showErrorToast(context, 'Please select a month and year');
      return;
    }
    final Contribution contribution = Contribution(
      memberId: widget.member.id!,
      amount: amount!,
      month: selectedMonth!,
      year: int.tryParse(selectedYear!),
    );

    // Show loading dialog
    showLoadingDialog(context);
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      await _groupService.createContribution(widget.group.id!,contribution, token,context);
      formKey.currentState?.reset();
      setState(() {
        amount = null;
        selectedMonth = null;
        selectedYear = null;
      });
      widget.onContributionCreated();
    } catch (e) {
      showErrorToast(context, 'An error occurred during creation');
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      Navigator.of(context).pop();
    }
  }
}