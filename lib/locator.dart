import 'package:flutter_lovers/repository/user_repository.dart';
import 'package:flutter_lovers/services/bildirim_gonderme_servisi.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/services/firebase_storage_service.dart';
import 'package:flutter_lovers/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}
