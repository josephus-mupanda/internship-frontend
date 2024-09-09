import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final String? text;

  const AppButton({super.key, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onPressed,
      child: Container(
          width: double.infinity,
          height: 40,
          //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color:Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
              child: Text(text!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                 color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
      )
    );
  }
}
