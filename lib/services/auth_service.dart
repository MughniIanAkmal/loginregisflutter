import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // In-memory data user terdaftar
  final List<UserModel> _users = [
    UserModel(
      fullName: 'Ahmad Fauzi',
      username: 'ahmadfauzi',
      email: 'ahmad@example.com',
      birthDate: DateTime(2001, 5, 20),
      gender: 'Laki-laki',
      phone: '081234567890',
      password: '123',
      address: 'Jl. Merdeka No. 10, Jakarta',
    ),
  ];

  UserModel? currentUser;

  bool register(UserModel user) {
    final exists = _users.any(
      (u) => u.username.toLowerCase() == user.username.toLowerCase(),
    );
    if (exists) return false;
    _users.add(user);
    return true;
  }

  UserModel? login(String username, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      currentUser = user;
      return user;
    } catch (_) {
      return null;
    }
  }

  void logout() {
    currentUser = null;
  }
}
