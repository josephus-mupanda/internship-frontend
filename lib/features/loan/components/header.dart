import 'package:flutter/material.dart';
import 'package:internship_frontend/core/constants/constants.dart';

import 'package:websafe_svg/websafe_svg.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../data/models/group.dart';

class LoanHeader extends StatelessWidget {
  final Group group;

  const LoanHeader({super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.kDefaultPadding),
      child: Row(
        children: [
          // We need this back button on mobile only
          if (Responsive.isMobile(context)) BackButton(
            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: group.name   ?? "No Name",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text:  'Created by: ${group.createdBy ?? 'Unknown'}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // We don't need print option on mobile
          // if (Responsive.isDesktop(context))
          //   IconButton(
          //     icon: WebsafeSvg.asset(
          //       "assets/Icons/Printer.svg",
          //       width: 24,
          //     ),
          //     onPressed: () {},
          //   ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/Markup.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/More vertical.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
