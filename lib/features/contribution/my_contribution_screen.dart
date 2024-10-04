
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/contribution.dart';
import 'package:internship_frontend/data/providers/contribution_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/contribution_dialog.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../group/components/header.dart';

class MyContributionScreen extends StatefulWidget {
  final Group group;
  final Member member;

  const MyContributionScreen({
    super.key,
    required this.group,
    required this.member
  });

  @override
  State<MyContributionScreen> createState() => _MyContributionScreenState();
}

class _MyContributionScreenState extends State<MyContributionScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<ContributionM> myContributions = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  
  Future<void> fetchMyContributions() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    if (token == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }
    try {
      final response = await _groupService.getContributionsByGroupAndMember(widget.group.id!,widget.member.id!,token, context);
      if (response?.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response!.body);
        List<ContributionM> fetchedMyContributions = data.map((contributionsJson) {
          return ContributionM.fromJson(contributionsJson);
        }).toList();
        setState(() {
          myContributions = fetchedMyContributions;
          Provider.of<ContributionProvider>(context, listen: false).setContributions(myContributions);
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
    fetchMyContributions();
  }

  void _onContributionDeleted() {
    // Refresh the list after deletion
    fetchMyContributions();
  }

  void _showContributionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContributionDialog(
          group: widget.group,
          member: widget.member,
          title: "Create a monthly Contribution",
          content: "Please fill in the details below:",
          nameYes: "Contribute",
          nameNo: "Cancel",
          onContributionCreated: () {
            fetchMyContributions();
          },
        );
      },
    );
  }


  void _onSearch(String? query) {
    setState(() {
      if (query == null || query.isEmpty) {
        fetchMyContributions();
      } else {
        myContributions = myContributions.where((contribution) {
          return contribution.amount.toString().contains(query) ||
              contribution.group.name.toString().contains(query) ||
              contribution.id.toString().contains(query) ||
              contribution.member.user!.username.toString().contains(query) ||
              DateFormat('yyyy-MM-dd').format(contribution.date).contains(query);
        }).toList();
      }
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      myContributions.sort((a, b) =>
      ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
    } else if (columnIndex == 1) {
      myContributions.sort((a, b) =>
      ascending ? a.group.name.compareTo(b.group.name) : b.group.name.compareTo(a.group.name));
    }
    else if (columnIndex == 2) {
      myContributions.sort((a, b) =>
      ascending ? a.member.user!.username.compareTo(b.member.user!.username) : b.member.user!.username.compareTo(a.member.user!.username));
    }
    else if (columnIndex == 3) {
      myContributions.sort((a, b) =>
      ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
    }
    else if (columnIndex == 4) {
      myContributions.sort((a, b) =>
      ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    }

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }
  Future<void> _onRefresh() async {
    await fetchMyContributions();
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
                  child:  myContributions.isEmpty?
                    const Center(
                        child: CircularProgressIndicator()
                    )
                      :
                  Row(
                    children: [
                      if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                      Expanded(
                        child: InputWidget(
                          hintText: 'Search my contribution here...',
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
                  child: SingleChildScrollView(
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
                            tooltip: 'Sort By Group Name',
                          ),
                          // New Member Username Column
                          DataColumn(
                            label: Text(
                              'Member',
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
                        rows: List<DataRow>.generate(
                          myContributions.length,
                              (index) {
                            final contribution = myContributions[index];
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
                                DataCell(Text(contribution.group.name)),
                                DataCell(Text(contribution.member.user!.username)),
                                DataCell(
                                  Text(
                                      NumberFormat.currency(symbol: '\$').format(contribution.amount)
                                  ),
                                ),
                                DataCell(
                                    Text(
                                      DateFormat('yyyy-MM-dd').format(contribution.date),
                                    )
                                ),

                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContributionDialog();
        },
        child: const Icon(Icons.add),
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
              myContributions.length, (index) {
            final contribution = myContributions[index];
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
                DataCell(Text(contribution.group.name)),
                DataCell(Text(contribution.member.user!.username)),
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