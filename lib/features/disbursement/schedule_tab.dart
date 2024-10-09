import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internship_frontend/data/models/Schedule.dart';
import 'package:internship_frontend/data/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/utils/preferences.dart';
import '../../data/models/group.dart';
import 'components/schedule_card.dart';


class ScheduleTab extends StatefulWidget {

  final Group group;

  const ScheduleTab({super.key, required this.group});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool? _isDisbursementAutomated;

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
      await fetchUpdatedSchedule(); // Fetch schedule if disbursement is automated
    }
  }

  Future<void> fetchUpdatedSchedule() async {
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    await scheduleProvider.fetchSchedule(widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    // Display loading spinner while checking the disbursement status
    if (_isDisbursementAutomated == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return  RefreshIndicator(
      onRefresh:fetchUpdatedSchedule,
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
                  ],
                ),
              ),
              const SizedBox(height: Constants.kDefaultPadding),
              // Check if disbursement is automated
              _isDisbursementAutomated == true?
                Expanded(
                  child: ListView.builder(
                      itemCount: scheduleProvider.schedule.length,
                      itemBuilder: (context, index) {
                        return ScheduleCard(
                          schedule: scheduleProvider.schedule[index],
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
                        "Please automate disbursement first to view the schedule.",
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