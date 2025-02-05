class AuthRepository {
  Future<void> login() async {
    print('giriş yapiliyor');
    Future.delayed(const Duration(seconds: 2));
    print('giriş yapıldı');
  }
}
