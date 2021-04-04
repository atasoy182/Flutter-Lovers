import 'package:flutter/material.dart';
import 'dart:io';

// Direkt sınıf üretmiyoruz. Button, switch gibi widgetları da türetmek isteyebiliriz. Bu nedenle abstract oluşturuyoruz.

abstract class PlatformDuyarliWidget extends StatelessWidget {
  Widget buildAndroidWidget(BuildContext context);
  Widget buildIosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIosWidget(context);
    } else {
      return buildAndroidWidget(context);
    }
  }
}
