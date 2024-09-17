import 'package:flutter/material.dart';
import 'package:internship_frontend/features/main/components/svgIcon.dart';
import '../../../core/constants/constants.dart';
import '../../../themes/color_palette.dart';


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
                  ColorPalette.primaryColor.withOpacity(.01),
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
                          color: ColorPalette.primaryColor,
                          offset: Offset(3, -1),
                          blurRadius: 5)
                  ],
                  color: isSelected
                      ? ColorPalette.primaryColor
                      : Colors.transparent),
            ),
            const SizedBox(
              width: Constants.kDefaultPadding,
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
                    ? ColorPalette.primaryColor
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

