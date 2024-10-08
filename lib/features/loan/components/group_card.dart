import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internship_frontend/themes/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../data/models/group.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../routes/app_routes.dart';

class GroupCard extends StatefulWidget {
  const GroupCard({super.key,
    this.isActive = true,
    required this.group,
    this.press,
  });

  final bool isActive;
  final Group group;
  final VoidCallback? press;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  void initState() {
    super.initState();
  }

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
    final menuProvider = Provider.of<MenuProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kDefaultPadding / 2),
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.kDefaultPadding),
              decoration: BoxDecoration(
                color: widget.isActive ? ColorPalette.primaryColor : Theme.of(context).colorScheme.background,
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
                          widget.group.name[0].toUpperCase(),
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
                            text: "${widget.group.name} \n",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.isActive ? Colors.white : null,
                            ),
                            children: [
                              TextSpan(
                                text: "Created By : ${widget.group.createdBy}",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: widget.isActive ? Colors.white : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.group.isInGroup)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: (){
                                menuProvider.selectGroup( widget.group);
                                if(Responsive.isMobile(context)) {
                                  Navigator.pushNamed(context,
                                    AppRoutes.groupMenuScreen,
                                    arguments: widget.group,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.isActive ? ColorPalette.secondaryColor : ColorPalette.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                 child: Text(
                                  "Request",
                                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                         color: Colors.white
                                     )
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Container(),
                    ],
                  ),
                  const SizedBox(height: Constants.kDefaultPadding / 2),
                  Text(
                    widget.group.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: widget.isActive ? Colors.white70 : null,
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
