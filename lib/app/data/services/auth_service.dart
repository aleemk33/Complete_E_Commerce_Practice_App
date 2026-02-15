import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

/// Dummy auth service with local persistence.
class AuthService {
  final box = GetStorage();
  static const String _hardcodedEmail = 'demo.shop@gmail.com';
  static const String _hardcodedPassword = 'Shop@1234';

  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.trim() != _hardcodedEmail || password != _hardcodedPassword) {
      throw Exception('Invalid credentials');
    }
    final profile = box.read('profile') ?? {};
    final user = User(
      name: profile['name'] ?? 'Alex Johnson',
      email: _hardcodedEmail,
      photoUrl: profile['photoUrl'],
    );
    box.write('user', {
      'name': user.name,
      'email': user.email,
      'photoUrl': user.photoUrl,
    });
    return user;
  }

  Future<User> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final user = User(name: name, email: _hardcodedEmail, photoUrl: null);
    box.write('user', {
      'name': user.name,
      'email': user.email,
      'photoUrl': user.photoUrl,
    });
    box.write('profile', {
      'name': user.name,
      'email': _hardcodedEmail,
      'photoUrl': user.photoUrl,
    });
    return user;
  }

  User? currentUser() {
    final data = box.read('user');
    if (data == null) return null;
    return User(
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
    );
  }

  void logout() {
    box.remove('user');
  }

  void updateProfile({required String name, required String email, String? photoUrl}) {
    box.write('user', {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    });
    box.write('profile', {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    });
  }
}
