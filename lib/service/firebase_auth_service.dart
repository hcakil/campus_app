import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print(" Hata Current User  " + e.toString());
      return null;
    }
  }

  MyUser _userFromFirebase(User user) {
    if (user == null) return null;
    return MyUser(userID: user.uid, email: user.email);
  }



  @override
  Future<bool> signOut() async {
    try {
     // final _googleSignIn = GoogleSignIn();
      //final _facebookSignIn = FacebookLogin();

      //await _googleSignIn.signOut();
      //await _facebookSignIn.logOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(" Hata Firebase Sign Out  " + e.toString());
      return false;
    }
  }




  @override
  Future<MyUser> createUserWithSignInWithEmail(
      String email, String sifre,String interest) async {
    //try {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
    //} catch (e) {
    //  print(" Hata Create Email Password  " + e.toString());
    //return null;
    // }
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String sifre) async {
    // try {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
    // }
    // catch (e) {
    //   print(" Hata Sign in Email Password  " + e.toString());
    //   return null;
    // }
  }
}
