import 'package:flutter/material.dart';
import 'package:internship_frontend/core/constants/constants.dart';

import 'package:websafe_svg/websafe_svg.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../../data/models/group.dart';

class MemberHeader extends StatelessWidget {
  final Group group;

  const MemberHeader({super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.kDefaultPadding),
      child: Row(
        children: [
          // We need this back button on mobile only
           BackButton(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),

          CircleAvatar(
            radius: 25,
            child: Text(
              group.name.isNotEmpty
                  ? group.name[0].toUpperCase()
                  : 'G',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: Constants.kDefaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name ?? "No Name",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Created by: ${group.createdBy ?? 'Unknown'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
