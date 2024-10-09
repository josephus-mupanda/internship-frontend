import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/preferences.dart';
import '../../core/utils/toast.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/providers/member_provider.dart';
import '../member/components/member_card.dart';

class MembersToReceiveTab extends StatefulWidget {
  final Group group;

  const MembersToReceiveTab({super.key, required this.group});

  @override
  State<MembersToReceiveTab> createState() => _MembersToReceiveTabState();
}

class _MembersToReceiveTabState extends State<MembersToReceiveTab> {
  bool? _isDisbursementAutomated;

  Future<void> fetchUpdatedMembers() async {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    await memberProvider.fetchMembers(widget.group.id!);
    setState(() {});
  }

  void filterMembers(String query) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.filterMembersToReceive(query);
  }

  void sortMembers(bool ascending) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.sortMembersToReceive(ascending);
    showSuccessToast(context, ascending ? 'Sorted by ascending' : 'Sorted by descending');
  }

  @override
  void initState() {
    super.initState();
    _checkDisbursementStatus();
  }

  Future<void> _checkDisbursementStatus() async {
    bool? status = Preferences.getDisbursementStatus() ?? false; // Fetch disbursement status from preferences
    setState(() {
      _isDisbursementAutomated = status; // Update the local state
    });
    if (status == true) {
      await fetchUpdatedMembers(); // Fetch schedule if disbursement is automated
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final memberProvider = Provider.of<MemberProvider>(context);
    final membersToReceive = memberProvider.filteredMembersToReceive; //membersToReceive;

    // Display loading spinner while checking the disbursement status
    if (_isDisbursementAutomated == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchUpdatedMembers,
      child: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: InputWidget(
                        hintText: 'Search member here...',
                        keyboardType: TextInputType.name,
                        suffixIcon: IconButton(
                          icon: Icon(
                            FeatherIcons.search,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                          },
                        ),
                        onChanged: (String? value) {
                          filterMembers(value ?? "");
                        },
                        validator: (String? value) {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Sort by username",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.arrow_upward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      onPressed: () {
                        sortMembers(true); // Ascending
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_downward, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      onPressed: () {
                        sortMembers(false); // Descending
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),

              _isDisbursementAutomated == true ?
                Expanded(
                  child: ListView.builder(
                      itemCount: membersToReceive.length,
                      itemBuilder: (context, index) {
                        MyMember member = membersToReceive[index];
                        return MemberCard(
                          member: member,
                        );
                      }
                  ),
                )
                  :
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Please automate disbursement first to view these members",
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
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