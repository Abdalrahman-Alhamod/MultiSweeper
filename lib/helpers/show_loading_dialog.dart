import 'package:flutter/material.dart';

import 'custom_loading_indicator.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const CustomLoadingIndicator(
        color: Colors.grey,
        size: 80,
      );
    },
    barrierDismissible: false,
  );
}
