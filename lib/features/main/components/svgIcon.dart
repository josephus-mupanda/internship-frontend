import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String asset;
  final Color? color;
  final double? size;

  const SvgIcon({super.key, required this.asset, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: size ?? 20,
      color: color ?? Colors.grey,
    );
  }
}
