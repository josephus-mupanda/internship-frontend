import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/view_member_dialog.dart';
import '../../../data/models/member.dart';

class MemberCard extends StatefulWidget {
  final MyMember member;

  const MemberCard({super.key, required this.member,});

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {

  @override
  void initState() {
    super.initState();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Red value
      random.nextInt(256), // Green value
      random.nextInt(256), // Blue value
    );
  }
  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kDefaultPadding / 2),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.kDefaultPadding),
            decoration: BoxDecoration(
              color:Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      // backgroundColor: getRandomColor(),
                      radius : 30,
                      child: Text(
                        widget.member.user![0],
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.kDefaultPadding / 2),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text : "${widget.member.user} \n",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "Join Date : ${widget.member.joinDate}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon:Icon(Icons.visibility,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            // Show the member view dialog on button press
                            showDialog(
                              context: context,
                              builder: (context) => ViewMemberDialog(
                                title: "View Member Details",
                                member: widget.member,
                                username: widget.member.user!,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

