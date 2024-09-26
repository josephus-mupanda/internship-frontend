import 'package:flutter/material.dart';
import 'package:internship_frontend/features/group/components/group_menu_card.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';
import '../../data/services/auth_service.dart';
import 'components/header.dart';

class GroupMenuScreen extends StatefulWidget {
  final Group group;

  const GroupMenuScreen({super.key, required this.group,});

  @override
  State<GroupMenuScreen> createState() => _GroupMenuScreenState();
}

class _GroupMenuScreenState extends State<GroupMenuScreen> {
  String? _username;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Fetch the username from the token
  Future<void> _loadUsername() async {
    try {
      String? username = await _authService.getUsernameFromToken();
      if (mounted) {
        setState(() {
          _username = username;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold (
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
                      GroupMenuCard(
                        icon: Icons.request_quote,
                        iconColor: Colors.blue,
                        title: 'All members',
                        press: () {

                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),

                      if (_username == selectedGroup.createdBy) ...[
                        GroupMenuCard(
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          title: 'All Contributions',
                          press: () {
                            // Action for All Contributions
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                        GroupMenuCard(
                          icon: Icons.money_off,
                          iconColor: Colors.red,
                          title: 'All Loans',
                          press: () {
                            // Action for All Loans
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPadding),
                      ],
                      // My Contributions (visible to all users)
                      GroupMenuCard(
                        icon: Icons.history,
                        iconColor: Colors.orange,
                        title: 'My Contributions',
                        press: () {
                          // Action for My Contributions
                        },
                      ),
                      const SizedBox(height: Constants.kDefaultPadding),
                      // My Loans (visible to all users)
                      GroupMenuCard(
                        icon: Icons.monetization_on,
                        iconColor: Colors.purple,
                        title: 'My Loans',
                        press: () {
                          // Action for My Loans
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
