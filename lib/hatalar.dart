class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'emaıl-already-ın-use':
        return 'Bu mail adresi zaten kullanılıyor, Lütfen farklı bir mail kullanın !';
      default:
        return 'Bir hata oluştu';
    }
  }
}
