

import 'package:campusapp/repository/user_repository.dart';
import 'package:campusapp/service/fake_auth_service.dart';
import 'package:campusapp/service/firebase_auth_service.dart';
import 'package:campusapp/service/firebase_storage_service.dart';
import 'package:campusapp/service/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  //locator.registerLazySingleton(() => NotificationSendService());
}
