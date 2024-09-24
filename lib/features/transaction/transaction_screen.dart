// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import '../../core/constants/constants.dart';
// import '../../core/layout/responsive_widget.dart';
// import '../../core/widgets/input_widget.dart';
// import '../../data/models/transaction.dart';
// import '../main/components/side_menu.dart';
//
// class TransactionScreen extends StatefulWidget {
//   const TransactionScreen({super.key});
//
//   @override
//   State<TransactionScreen> createState() => _TransactionScreenState();
// }
//
// class _TransactionScreenState extends State<TransactionScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   bool _sortAscending = true;
//   int _sortColumnIndex = 0;
//   int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
//   String? _sortColumn;
//
//   List<Transaction> _transactions = transactions;
//
//   @override
//   void initState() {
//     super.initState();
//     _transactions = transactions; // Initially show all transactions
//   }
//
//   void _onSort(int columnIndex, bool ascending) {
//     if (columnIndex == 0) {
//       _transactions.sort((a, b) =>
//       ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
//     } else if (columnIndex == 2) {
//       _transactions.sort((a, b) =>
//       ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
//     }
//
//     setState(() {
//       _sortColumnIndex = columnIndex;
//       _sortAscending = ascending;
//     });
//   }
//
//   void _onSearch(String? query) {
//     setState(() {
//       if (query == null || query.isEmpty) {
//         _transactions = transactions; // Show all transactions if query is empty
//       } else {
//         _transactions = transactions
//             .where((transaction) =>
//         transaction.id.toString().contains(query) ||
//             transaction.groupId.toString().contains(query) ||
//             transaction.amount.toString().contains(query) ||
//             transaction.type.name.toLowerCase().contains(query.toLowerCase()) ||
//             DateFormat('yyyy-MM-dd').format(transaction.date).contains(query))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     final TextTheme textTheme = theme.textTheme;
//
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 250),
//         child: const SideMenu(),
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(
//             top: kIsWeb ? Constants.kDefaultPadding : 0),
//         color: theme.cardColor,
//         child: SafeArea(
//           right: false,
//           child: Column(
//             children: [
//               // Search bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: Constants.kDefaultPadding),
//                 child: Row(
//                   children: [
//                     if (!Responsive.isDesktop(context))
//                       IconButton(
//                         icon: Icon(
//                           Icons.menu,
//                           color: colorScheme.onSurface.withOpacity(0.5),
//                         ),
//                         onPressed: () {
//                           _scaffoldKey.currentState?.openDrawer();
//                         },
//                       ),
//                     if (!Responsive.isDesktop(context))
//                       const SizedBox(width: 5),
//                     Expanded(
//                       child: InputWidget(
//                         hintText: 'Search Transaction',
//                         keyboardType: TextInputType.name,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             FeatherIcons.search,
//                             color: colorScheme.onSurface.withOpacity(0.5),
//                           ),
//                           onPressed: () {},
//                         ),
//                         onChanged: _onSearch, // Use the onChanged callback
//                         validator: (String? value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a search term';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: Constants.kDefaultPadding),
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SingleChildScrollView(
//                     child: DataTable(
//                     sortAscending: _sortAscending,
//                     sortColumnIndex: _sortColumnIndex,
//                     columns: [
//                       DataColumn(
//                         label: Text(
//                           'ID',
//                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         onSort: (columnIndex, _) {
//                           _onSort(columnIndex, !_sortAscending);
//                         },
//                         tooltip: 'Sort by ID',
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Group ID',
//                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         onSort: (columnIndex, _) {
//                           _onSort(columnIndex, !_sortAscending);
//                         },
//                         tooltip: 'Group Identification',
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Amount',
//                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         onSort: (columnIndex, _) {
//                           _onSort(columnIndex, !_sortAscending);
//                         },
//                         tooltip: 'Sort by Amount',
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Date',
//                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         onSort: (columnIndex, _) {
//                           _onSort(columnIndex, !_sortAscending);
//                         },
//                         tooltip: 'Sort by Date',
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Type',
//                           style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                     rows: List<DataRow>.generate(
//                       transactions.length,
//                           (index) {
//                         final transaction = transactions[index];
//                         final isEven = index % 2 == 0;
//                         return DataRow(
//                           color: MaterialStateProperty.resolveWith<Color?>(
//                                 (Set<MaterialState> states) {
//                               return isEven
//                                   ? colorScheme.background.withOpacity(0.05)
//                                   : colorScheme.background.withOpacity(0.15);
//                             },
//                           ),
//                           cells: [
//                             DataCell(Text(transaction.id.toString())),
//                             DataCell(Text(transaction.groupId.toString())),
//                             DataCell(
//                               Text(NumberFormat.currency(symbol: '\$').format(transaction.amount)),
//                             ),
//                             DataCell(Text(
//                                 DateFormat('yyyy-MM-dd').format(transaction.date))),
//                             DataCell(
//                               _buildTransactionType(transaction.type, theme),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to build the customized transaction type container
//   Widget _buildTransactionType(TransactionType type, ThemeData theme) {
//     final Color typeColor;
//     final String typeLabel;
//
//     switch (type) {
//       case TransactionType.CONTRIBUTION:
//         typeColor = theme.colorScheme.primary;
//         typeLabel = 'Contribution';
//         break;
//       case TransactionType.DISBURSEMENT:
//         typeColor = theme.colorScheme.secondary;
//         typeLabel = 'Disbursement';
//         break;
//       case TransactionType.MEMBERSHIP_FEES:
//         typeColor = theme.colorScheme.error;
//         typeLabel = 'Membership';
//         break;
//       default:
//         typeColor = theme.colorScheme.onSurface;
//         typeLabel = 'Unknown';
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: typeColor.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         typeLabel,
//         style: theme.textTheme.bodyMedium?.copyWith(
//           color: typeColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/transaction.dart';
import '../main/components/side_menu.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String? _sortColumn;

  List<Transaction> _transactions = transactions;

  @override
  void initState() {
    super.initState();
    _transactions = transactions; // Initially show all transactions
  }

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _transactions.sort((a, b) =>
      ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
    } else if (columnIndex == 2) {
      _transactions.sort((a, b) =>
      ascending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
    }

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _onSearch(String? query) {
    setState(() {
      if (query == null || query.isEmpty) {
        _transactions = transactions; // Show all transactions if query is empty
      } else {
        _transactions = transactions.where((transaction) {
          return transaction.id.toString().contains(query) ||
              transaction.groupId.toString().contains(query) ||
              transaction.amount.toString().contains(query) ||
              transaction.type.name.toLowerCase().contains(query.toLowerCase()) ||
              DateFormat('yyyy-MM-dd').format(transaction.date).contains(query);
        }).toList();
      }
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
                        onChanged: _onSearch, // Use the onChanged callback for real-time search
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
                            'Group ID',
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, _) {
                            _onSort(columnIndex, !_sortAscending);
                          },
                          tooltip: 'Group Identification',
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
                      rows: List<DataRow>.generate(
                        _transactions.length, // Change to _transactions
                            (index) {
                          final transaction = _transactions[index];
                          final isEven = index % 2 == 0;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                return isEven
                                    ? colorScheme.background.withOpacity(0.05)
                                    : colorScheme.background.withOpacity(0.15);
                              },
                            ),
                            cells: [
                              DataCell(Text(transaction.id.toString())),
                              DataCell(Text(transaction.groupId.toString())),
                              DataCell(
                                Text(NumberFormat.currency(symbol: '\$').format(transaction.amount)),
                              ),
                              DataCell(Text(
                                  DateFormat('yyyy-MM-dd').format(transaction.date))),
                              DataCell(
                                _buildTransactionType(transaction.type, theme),
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
