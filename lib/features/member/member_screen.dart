
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:websafe_svg/websafe_svg.dart';
import '../../core/constants/constants.dart';
import '../../core/layout/responsive_widget.dart';
import '../../data/models/group.dart';
import '../../data/providers/group_provider.dart';
import '../../models/Member.dart';
import '../../providers/group_provider.dart';
import '../../responsive.dart';
import '../main/components/member_card.dart';

class MemberScreen extends StatelessWidget {
  final Group? group;

  const MemberScreen({super.key, this.group,});

  @override
  Widget build(BuildContext context) {

    final groupProvider = Provider.of<GroupProvider>(context);
    final selectedGroup = groupProvider.selectedGroup;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: selectedGroup == null
              ?
          const Center(child: Text("Select first a group ...."))
              :
          Column(
              children: [
              //Header(),
              Header(group: selectedGroup),
              const Divider(thickness: 1),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(
                                Constants.kDefaultPadding * 0.75), //15
                            child: WebsafeSvg.asset(
                              "assets/Icons/Search.svg",
                              width: 24,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
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
                    SvgPicture.asset(
                      "assets/Icons/Angle down.svg",
                      width: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Sort by date",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    MaterialButton(
                      minWidth: 20,
                      onPressed: () {},
                      child: WebsafeSvg.asset(
                        "assets/Icons/Sort.svg",
                        width: 16,
                      ),
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
