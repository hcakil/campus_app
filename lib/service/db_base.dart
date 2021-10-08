import 'package:campusapp/model/user.dart';


abstract class DBBase {
  Future<bool> saveUserWithEmailAndPassword(MyUser user,String interest);
//  Future<bool> updateUserName(String userID, String yeniUserName);
  Future<MyUser> readUser(String userID);
  Future<bool> updateProfilPhoto(String userID, String profilPhotoUrl);
  Future<bool> updateInterest(String userID, String newInterest);
  // Future<List<User>> getAllUser();
  //Future<List<MyUser>> getUserWithPagination(MyUser enSonGetirilenUser, int getirilecekElemanSayisi);
  //Future<List<Konusma>> getAllConversations(String userID);
  //Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
 // Future<bool> saveMessages(Mesaj kaydedilecekMesaj);
  //Future<DateTime> saatiGoster(String userID);
}
