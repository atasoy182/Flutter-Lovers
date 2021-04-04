import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lovers/common_widgets/platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String baslik;
  final String icerik;
  final String anaButtonYazisi;
  final String iptalButtonYazisi;

  PlatformDuyarliAlertDialog(
      {@required this.baslik,
      @required this.icerik,
      @required this.anaButtonYazisi,
      this.iptalButtonYazisi});

  // Evet - hayır cevabı gelecekte olacağı için future bool kullanıldı.
  // this => widget nesnemizi temsil eder, neyi build edeceğini PlatformDuyarliWidget üst sınıfımızdan bilir.
  // böylece ana page'de platforma duyarlı widget oluşturulmuş olur.
  // showCupertinoDialog yada showDialog belirtmeden goster metodunda neyi show edeceği belirtilir.

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButtonlariniAyarla(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButtonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButtonlariniAyarla(BuildContext context) {
    final _tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (iptalButtonYazisi != null) {
        _tumButonlar.add(CupertinoDialogAction(
          child: Text(iptalButtonYazisi),
          onPressed: () => Navigator.of(context).pop(false),
        ));
      }

      _tumButonlar.add(CupertinoDialogAction(
        child: Text(anaButtonYazisi),
        onPressed: () => Navigator.of(context).pop(true),
      ));
    } else {
      if (iptalButtonYazisi != null) {
        _tumButonlar.add(FlatButton(
          child: Text(iptalButtonYazisi),
          onPressed: () => Navigator.of(context).pop(false),
        ));
      }

      _tumButonlar.add(FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(anaButtonYazisi)));
    }

    return _tumButonlar;
  }
}
