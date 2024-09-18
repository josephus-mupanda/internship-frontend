
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../core/widgets/input_widget.dart';
import '../../data/models/group.dart';
import '../../data/models/member.dart';
import '../../data/providers/group_provider.dart';
import 'components/header.dart';
import 'components/member_card.dart';

class MemberScreen extends StatelessWidget {
  final Group? group;

  const MemberScreen({super.key, this.group,});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: selectedGroup == null
              ?
          const Center(child: Text("Select first a group ...."))
              :
          Column(
              children: [
              Header(group: selectedGroup),
              const Divider(thickness: 1),
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
                        onChanged: (String? value) {},
                        validator: (String? value) {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.chevronDown,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Sort by date",
                      style: TextStyle(),
                    ),
                    const Spacer(),
                    Icon(
                      FeatherIcons.filter,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.kDefaultPadding),
                  child: Column(
                    children: [
                      // This is our Search bar
                      ListView.builder(
                        shrinkWrap: true, // Let it take only required space
                        physics: const NeverScrollableScrollPhysics(), // Disable scroll of ListView
                        itemCount: members.length,
                        itemBuilder: (context, index) => MemberCard(
                          member: members[index],
                          // press: () {
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add), // Customize the FAB color as needed
    ),
    );
  }
}
