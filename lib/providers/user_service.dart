class UserService {
  // Singleton
  static final UserService instance = UserService._internal();

  UserService._internal();

  // Token del usuario
  String _token = '';

  String get token => _token;

  void setToken(String token) {
    _token = token;
  }

  // Puedes agregar más lógica si es necesario
}
