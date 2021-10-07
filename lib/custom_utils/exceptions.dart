class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'email-already-in-use':
        return "Bu mail adresi zaten kullanımda lütfen farklı bir mail kullanınız";
        break;
      case 'user-not-found':
        return "Bu mail adresine ait hesap bulunamadı,Lütfen yeni kayıt oluşturunuz.";
        break;
      case 'ERROR_NETWORK_REQUEST_FAILED':
        return "Ağ bağlantınızda bir hata oluştu.Ağ bağlantınızı kontrol ediniz";
        break;
      case 'ERROR_ACCOUNT_EXIST_WITH_DIFFERENT_CREDENTIAL':
        return "Facebook hesabınızdaki mail adresi Gmail ya da Email ile giriş için kullanılmıştır. Lütfen Gmail ya da Email giriş yöntemini kullanınız.";
        break;
      default:
        return "Bir Hata Oluştu";
        break;
    }
  }
}
