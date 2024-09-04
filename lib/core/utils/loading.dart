import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          //color: Theme.of(context).colorScheme.secondary, // Use secondary color from theme
          //backgroundColor: Theme.of(context).colorScheme.background, // Use background color from theme
        ),
      );
    },
  );
}