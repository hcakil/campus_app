

import 'package:campusapp/model/user.dart';

abstract class AuthBase {
  Future<MyUser> currentUser();

  Future<bool> signOut();

  Future<MyUser> signInWithEmailAndPassword(String email, String sifre);
//  Future<MyUser> signInWithEmailAndPassword(String email, String sifre,);
  Future<MyUser> createUserWithSignInWithEmail(String email, String sifre,String interest);
}
