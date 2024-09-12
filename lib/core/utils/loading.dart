import 'package:flutter/material.dart';

import '../constants/constants.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: Constants.kDefaultPadding),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}