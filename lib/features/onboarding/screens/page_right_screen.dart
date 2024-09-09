import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageRightSide extends StatelessWidget {
  final String title;
  final String icon;

  const PageRightSide({
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(), // This can be customized later
        child: Center(
          child: SizedBox(
            height: 500,
            child: Stack(
              children: [
                SvgPicture.asset(
                  icon,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 30, top: 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "🤞",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 30, top: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "🖐",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
