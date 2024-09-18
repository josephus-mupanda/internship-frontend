import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/group.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key,
    this.isActive = true,
    required this.group,
    this.press,
  });

  final bool isActive;
  final Group group;
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
                color: isActive ? ColorPalette.primaryColor : Theme.of(context).colorScheme.background,
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
                            group.name[0].toUpperCase(),
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
                            text: "${group.name} \n",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Created by : ${group.createdBy}",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isActive ? Colors.white : null,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          // maxLines: 1,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Join",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isActive ? Colors.white70 : null,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.kDefaultPadding / 2),
                  Text(
                    group.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: isActive ? Colors.white70 : null,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
