import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "ÇakmaUserId";
  String email = "ÇakmaUserEmail";

  @override
  Future<MyUser> currentUser() async {
    return await Future.value(MyUser(userID: userID, email: email));
  }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(
        Duration(seconds: 2), () => MyUser(userID: userID, email: email));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),
        () => MyUser(userID: "googleSignIn_" + userID, email: email));
  }

  @override
  Future<MyUser> signInWithFacebook() async {
    return await Future.delayed(Duration(seconds: 2),
        () => MyUser(userID: "FacebookSignIn_" + userID, email: email));
  }

  @override
  Future<MyUser> createUserWithSignInWithEmail(
      String email, String sifre) async {
    return await Future.delayed(Duration(seconds: 2),
        () => MyUser(userID: "Created_User_SignIn_" + userID, email: email));
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => MyUser(
            userID: "Signed_In_Email_User_SignIn_" + userID, email: email));
  }
}
