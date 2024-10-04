
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/loan.dart';
import 'package:internship_frontend/data/providers/loan_provider.dart';
import 'package:internship_frontend/data/services/group_service.dart';
import 'package:internship_frontend/features/group/components/header.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoanHistoryScreen extends StatefulWidget {
  final Group group;

  const LoanHistoryScreen({super.key, required this.group,});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {

  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();

  List<ReservedAmount> loans = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

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

  @override
  void initState() {
    super.initState();
    fetchLoans();
  }

  Future<void> _onRefresh() async {
    await fetchLoans();
  }
  void _onLoanDeleted() {
    // Refresh the list after deletion
    fetchLoans();
  }

  void _onSearch(String? query) {
    setState(() {
      if (query == null || query.isEmpty) {
        fetchLoans();
      } else {
        loans = loans.where((loan) {
          return loan.amount.toString().contains(query) ||
              loan.group.toString().contains(query) ||
              loan.id.toString().contains(query) ||
              loan.user.toString().contains(query) ||
              loan.reservedAmountType.toLowerCase().contains(query.toLowerCase()) ||
              DateFormat('yyyy-MM-dd').format(loan.date).contains(query);
        }).toList();
      }
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      loans.sort((a, b) =>
      ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
    } else if (columnIndex == 1) {
      loans.sort((a, b) =>
      ascending ? a.group.compareTo(b.group) : b.group.compareTo(a.group));
    }
    else if (columnIndex == 2) {
      loans.sort((a, b) =>
      ascending ? a.user.compareTo(b.user) : b.user.compareTo(a.user));
    }
    else if (columnIndex == 3) {
      loans.sort((a, b) =>
      ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
    }
    else if (columnIndex == 4) {
      loans.sort((a, b) =>
      ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    }

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
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
                  child:  loans.isEmpty
                      ? _buildSkeletonTable(context)
                      : _buildLoanTable(context, textTheme),
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
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Original Loan Amount')),
          ],
          rows: List<DataRow>.generate(5, (index) {
            return DataRow(
              cells: List<DataCell>.generate(7, (cellIndex) {
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
  Widget _buildLoanTable(BuildContext context, TextTheme textTheme) {
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
              tooltip: 'Group Identification',
            ),
            DataColumn(
              label: Text(
                'Members',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, _) {
                _onSort(columnIndex, !_sortAscending);
              },
              tooltip: 'Sort By Members',
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
            DataColumn(
              label: Text(
                'Type',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Original Loan Amount',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: loans.map((loan) {
            return DataRow(
              cells: [
                DataCell(Text(loan.id.toString())),
                DataCell(Text(loan.group)),
                DataCell(Text(loan.user)),
                DataCell(
                  Text(
                      NumberFormat.currency(symbol: '\$').format(loan.amount)
                  ),
                ),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(loan.date))),
                DataCell(
                  _buildLoanType(loan.reservedAmountType, theme),
                ),
                DataCell(
                  Text(
                      NumberFormat.currency(symbol: '\$').format(loan.originalLoanAmount)
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Function to build the customized transaction type container
  Widget _buildLoanType(String type, ThemeData theme) {
    final Color typeColor;
    final String typeLabel;

    switch (type) {
      case "LOAN":
        typeColor = theme.colorScheme.primary;
        typeLabel = 'Loan';
        break;
      case "DISBURSEMENT":
        typeColor = theme.colorScheme.secondary;
        typeLabel = 'Disbursement';
        break;
      case "MEMBERSHIP_FEES":
        typeColor = theme.colorScheme.error;
        typeLabel = 'Membership';
        break;
      default:
        typeColor = theme.colorScheme.onSurface;
        typeLabel = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        typeLabel,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: typeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
