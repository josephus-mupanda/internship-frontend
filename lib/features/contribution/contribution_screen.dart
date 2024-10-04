
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/data/models/contribution.dart';
import 'package:internship_frontend/data/providers/contribution_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

import '../group/components/header.dart';

class ContributionScreen extends StatefulWidget {
  final Group group;

  const ContributionScreen({super.key, required this.group,});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<ContributionM> contributions = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  Future<void> fetchContributions() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    try {
      final response = await _groupService.getContributionsByGroup(widget.group.id!, token, context);
      if (response?.statusCode == 200) {
        List<dynamic> data = jsonDecode(response!.body);
        List<ContributionM> fetchedContributions = data.map((contributionsJson) {
          return ContributionM.fromJson(contributionsJson);
        }).toList();
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

  void _onSearch(String? query) {
    setState(() {
      if (query == null || query.isEmpty) {
        fetchContributions();
      } else {
        contributions = contributions.where((contribution) {
          return contribution.amount.toString().contains(query) ||
              contribution.group.toString().contains(query) ||
              contribution.id.toString().contains(query) ||
              contribution.user.toString().contains(query) ||
              DateFormat('yyyy-MM-dd').format(contribution.date).contains(query);
        }).toList();
      }
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      contributions.sort((a, b) =>
      ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
    } else if (columnIndex == 1) {
      contributions.sort((a, b) =>
      ascending ? a.group.compareTo(b.group) : b.group.compareTo(a.group));
    }
    else if (columnIndex == 2) {
      contributions.sort((a, b) =>
      ascending ? a.user.compareTo(b.user) : b.user.compareTo(a.user));
    }
    else if (columnIndex == 3) {
      contributions.sort((a, b) =>
      ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
    }
    else if (columnIndex == 4) {
      contributions.sort((a, b) =>
      ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    }

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Future<void> _onRefresh() async {
    await fetchContributions();
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body:  RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          color: theme.colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                GroupHeaderWithArrow(group: widget.group),
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
                          onChanged: _onSearch,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a search term';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.kDefaultPadding),
                Expanded(
                  child: contributions.isEmpty
                      ? _buildSkeletonTable(context)
                      : _buildContributionTable(context, textTheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSkeletonTable(BuildContext context) {
    final theme = Theme.of(context);
    final skeletonColor = theme.colorScheme.onSurface.withOpacity(0.1);
    final TextTheme textTheme = theme.textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Group Name')),
            DataColumn(label: Text('Members')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
          ],
          rows: List<DataRow>.generate(5, (index) {
            return DataRow(
              cells: List<DataCell>.generate(5, (cellIndex) {
                return DataCell(Container(
                  width: 100,
                  height: 20,
                  color: skeletonColor,
                ));
              }),
            );
          }),
        ),
      ),
    );
  }
  Widget _buildContributionTable(BuildContext context, TextTheme textTheme) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortAscending: _sortAscending,
          sortColumnIndex: _sortColumnIndex,
          columns: [
            DataColumn(
              label: Text(
                'ID',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort by ID',
            ),
            DataColumn(
              label: Text(
                'Group Name',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort by Group Name',
            ),
            DataColumn(
              label: Text(
                'Members',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort By Member',
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort by Amount',
            ),
            DataColumn(
              label: Text(
                'Date',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort by Date',
            ),
          ],
          rows:List<DataRow>.generate(
            contributions.length, (index) {
            final contribution = contributions[index];
            final isEven = index % 2 == 0;
              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    return isEven
                        ? theme.colorScheme.background.withOpacity(0.05)
                        : theme.colorScheme.background.withOpacity(0.15);
                  },
                ),
                cells: [
                  DataCell(Text(contribution.id.toString())),
                  DataCell(Text(contribution.group)),
                  DataCell(Text(contribution.user)),
                  DataCell(
                    Text(
                        NumberFormat.currency(symbol: '\$').format(contribution.amount)
                    ),
                  ),
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(contribution.date))),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

