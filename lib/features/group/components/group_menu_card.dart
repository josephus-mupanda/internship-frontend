import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';

class GroupMenuCard extends StatefulWidget {
  final VoidCallback? press;
  final IconData icon;
  final Color iconColor;
  final String title;

  const GroupMenuCard({
    super.key,
    this.press,
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  State<GroupMenuCard> createState() => _GroupMenuCardState();
}

class _GroupMenuCardState extends State<GroupMenuCard> {
  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
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
                color:Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          child: Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.kDefaultPadding / 2),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

