import 'package:flutter/material.dart';

class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'emaıl-already-ın-use':
        return 'Bu mail adresi zaten kullanılıyor, Lütfen farklı bir mail kullanın !';
      case 'user-not-found':
        return 'Bu kullanıcı sistemde bulunmamaktadır. Lütfen Kullanıcı Oluşturunuz !';
      default:
        return 'Bir hata oluştu';
    }
  }
}
