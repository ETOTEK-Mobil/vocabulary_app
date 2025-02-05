class AuthValidators {
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Kullanıcı adınızı girin';
    }
    if (username.length < 3) {
      return 'Kullanıcı adı en az 3 karakter olmalı';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'E-Posta adresinizi girin';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Şifre girin';
    }
    final passwordRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!passwordRegex.hasMatch(password)) {}
    if (password.length < 6) {
      return "Şifre uzunluğu 6'dan küçük olmamalı";
    }
    return null;
  }
}
