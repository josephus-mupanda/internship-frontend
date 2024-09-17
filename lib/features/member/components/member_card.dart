import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internship_frontend/core/utils/extensions.dart';

import '../../../constants.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/member.dart';
import '../../../extensions.dart';
import '../../../models/Member.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key,
    this.isActive = true,
    required this.member,
    this.press,
  });

  final bool isActive;
  final Member member;
  final VoidCallback? press;


  // Function to generate a random color
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
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.kDefaultPadding),
              decoration: BoxDecoration(
                color:kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor: getRandomColor(),
                          child: Text(
                            member.user![0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "${member.user} \n",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Join Date : ${member.joinDate}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "View",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: null,
                            ),
                          ),
                          const SizedBox(height: 5),
                            SvgPicture.asset(
                              "assets/Icons/Paperclip.svg",
                              color:  kGrayColor,
                            )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.kDefaultPadding / 2),
                ],
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: const Offset(5, 5),
              topShadowColor: Colors.white60,
              bottomShadowColor: const Color(0xFF234395).withOpacity(0.15),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: member.isActive == true ? const Color(0xFF23CF91):kBadgeColor ,
                ),
              ).addNeumorphism(
                blurRadius: 4,
                borderRadius: 8,
                offset: const Offset(2, 2),
              ),
            ),
            if (member.tagColor != null)
              Positioned(
                left: 8,
                top: 0,
                child: SvgPicture.asset(
                  "assets/Icons/Markup filled.svg",
                  height: 18,
                  color: member.tagColor,
                ),
              )
          ],
        ),
      ),
    );
  }
}
