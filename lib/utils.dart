import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const double middlePadding = 16.0;
const double smallPadding = 12.0;
const double xSmallPadding = 8.0;
const TextStyle body1 = TextStyle(
  color: Color(0xff2c3f52),
  fontWeight: FontWeight.w400,
  fontFamily: "Roboto",
  fontStyle: FontStyle.normal,
  letterSpacing: 0.1,
  height: 1.5,
  fontSize: 16.0,
);

Future<T?> showSampleDialog<T>({
  required BuildContext context,
  required Widget modalPage,
}) async {
  final screenHeight = MediaQuery.of(context).size.height;
  final statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
  return await showCupertinoModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) => SizedBox(
      height: screenHeight - statusBarHeight - xSmallPadding,
      child: modalPage,
    ),
  );
}

void hideKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
