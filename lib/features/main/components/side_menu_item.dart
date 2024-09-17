import 'package:flutter/material.dart';
import 'package:outlook/components/svgIcon.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';
import 'counter_badge.dart';

class MenuItem extends StatefulWidget {
  final String? title;
  final icon;
  final double size, mb;
  final value, groupValue;
  final Function(dynamic value)? onChanged;
  const MenuItem(
      {super.key,
        this.icon,
        this.title,
        this.value,
        this.groupValue,
        this.size = 20,
        this.onChanged,
        this.mb = 20});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.value == widget.groupValue;
    return InkWell(
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.groupValue);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: widget.mb),
        decoration: BoxDecoration(
            gradient: isHover
                ? LinearGradient(
                colors: [
                  kPrimaryColor.withOpacity(.01),
                  Colors.white
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0, 0.7])
                : null),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 2.5,
              decoration: BoxDecoration(
                  boxShadow: [
                    if (isSelected)
                      const BoxShadow(
                          color: kPrimaryColor,
                          offset: Offset(3, -1),
                          blurRadius: 5)
                  ],
                  color: isSelected
                      ? kPrimaryColor
                      : Colors.transparent),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            if (widget.icon is String)
              SvgIcon(
                asset: widget.icon,
                // color: isSelected
                //     ? kDefaultPadding
                //     : Color(0xFF707C97),
                size: widget.size,
              ),
            if (widget.icon is IconData)
              Icon(
                widget.icon,
                size: widget.size,
                color: isSelected
                    ? kPrimaryColor
                    : const Color(0xFF707C97),
              ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.title!,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}



// class SideMenuItem extends StatelessWidget {
//   const SideMenuItem({super.key,
//     this.isActive,
//     this.isHover = false,
//     this.itemCount,
//     this.showBorder = true,
//     required this.iconSrc,
//     required this.title,
//     required this.press,
//   });
//
//   final bool? isActive, isHover, showBorder;
//   final int? itemCount;
//   final String? iconSrc, title;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: kDefaultPadding),
//       child: InkWell(
//         onTap: press,
//         child: Row(
//           children: [
//             (isActive! || isHover!)
//                 ? WebsafeSvg.asset(
//                     "assets/Icons/Angle right.svg",
//                     width: 15,
//                   )
//                 : const SizedBox(width: 15),
//             const SizedBox(width: kDefaultPadding / 4),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.only(bottom: 15, right: 5),
//                 decoration: showBorder!
//                     ? const BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(color: Color(0xFFDFE2EF)),
//                         ),
//                       )
//                     : null,
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(
//                       iconSrc!,
//                       height: 20,
//                       color: (isActive! || isHover!) ? kPrimaryColor : kGrayColor,
//                     ),
//                     const SizedBox(width: kDefaultPadding * 0.75),
//                     Text(
//                       title!,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color:
//                                 (isActive! || isHover!) ? kTextColor : kGrayColor,
//                           ),
//                     ),
//                     const Spacer(),
//                    // CounterBadge(itemCount!)
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
