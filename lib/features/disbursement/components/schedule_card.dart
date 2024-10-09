import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internship_frontend/data/models/Schedule.dart';
import 'package:internship_frontend/themes/color_palette.dart';

import '../../../core/constants/constants.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;
  const ScheduleCard({super.key,
    required this.schedule
  });
  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                      radius: 30,
                      // backgroundColor: getRandomColor(),
                      child: Text(
                        widget.schedule.memberUsername[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(width: Constants.kDefaultPadding / 2),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "${widget.schedule.memberUsername} \n",
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: "Amount : ${widget.schedule.amount}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          widget.schedule.month,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white
                          )
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
