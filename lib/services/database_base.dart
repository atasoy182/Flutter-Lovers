import 'package:flutter_lovers/model/app_user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(AppUser appUser);
}
