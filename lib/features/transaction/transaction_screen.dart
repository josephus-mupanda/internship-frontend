import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internship_frontend/core/utils/preferences.dart';
import 'package:internship_frontend/data/providers/transaction_provider.dart';
import 'package:internship_frontend/data/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/transaction.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/member_service.dart';
import '../../routes/app_routes.dart';
import '../main/components/side_menu.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  List<Transaction> transactions = [];
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  Future<void> fetchTransactions() async {
    // Retrieve the token from secure storage
    String? token = await _authService.getAccessToken();
    int? userId = Preferences.getUserId();

    if (token == null && userId == null) {
      await _authService.logout(context);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    try {
      final response = await _userService.getAllTransactionsByUserId(userId!, token!, context);
      if (response?.statusCode == 200) {
        // Decode the JSON data
        List<dynamic> data = jsonDecode(response!.body);
        List<Transaction> fetchedTransactions = data.map((transactionsJson) {
          return Transaction.fromJson(transactionsJson);
        }).toList();
        setState(() {
          transactions = fetchedTransactions;
          Provider.of<TransactionProvider>(context, listen: false).setTransactions(transactions);
        });
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching transactions: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void _onSearch(String? query) {
    setState(() {
      if (query == null || query.isEmpty) {
        fetchTransactions();
      } else {
        transactions = transactions.where((transaction) {
          return transaction.amount.toString().contains(query) ||
              transaction.id.toString().contains(query) ||
              transaction.group.name.toString().contains(query) ||
              transaction.type.name.toLowerCase().contains(query.toLowerCase()) ||
              DateFormat('yyyy-MM-dd').format(transaction.date).contains(query);
        }).toList();
      }
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      transactions.sort((a, b) =>
      ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
    } else if (columnIndex == 1) {
      transactions.sort((a, b) =>
      ascending ? a.group.name.compareTo(b.group.name) : b.group.name.compareTo(a.group.name));
    }
    else if (columnIndex == 2) {
      transactions.sort((a, b) =>
      ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
    }
    else if (columnIndex == 3) {
      transactions.sort((a, b) =>
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
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(),
      ),
      body: Container(
        padding: const EdgeInsets.only(
            top: kIsWeb ? Constants.kDefaultPadding : 0),
        color: theme.cardColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: InputWidget(
                        hintText: 'Search Transaction',
                        keyboardType: TextInputType.name,
                        suffixIcon: IconButton(
                          icon: Icon(
                            FeatherIcons.search,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            // You can add any additional functionality here if needed
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
                child: transactions.isEmpty
                    ? _buildSkeletonTable(context)
                    : _buildTransactionTable(context, textTheme),

              ),
            ],
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
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Type')),
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
  Widget _buildTransactionTable(BuildContext context, TextTheme textTheme) {
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
          ],
          rows:List<DataRow>.generate(
              transactions.length, (index) {
            final transaction = transactions[index];
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
                DataCell(Text(transaction.id.toString())),
                DataCell(Text(transaction.group.name)),
                DataCell(
                  Text(
                      NumberFormat.currency(symbol: '\$').format(transaction.amount)
                  ),
                ),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(transaction.date))),
                DataCell(
                  _buildTransactionType(transaction.type, theme),
                ),
              ],
            );
          }
          ),
        ),
      ),
    );
  }
  // Function to build the customized transaction type container
  Widget _buildTransactionType(TransactionType type, ThemeData theme) {
    final Color typeColor;
    final String typeLabel;

    switch (type) {
      case TransactionType.CONTRIBUTION:
        typeColor = theme.colorScheme.primary;
        typeLabel = 'Contribution';
        break;
      case TransactionType.DISBURSEMENT:
        typeColor = theme.colorScheme.secondary;
        typeLabel = 'Disbursement';
        break;
      case TransactionType.MEMBERSHIP_FEES:
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
