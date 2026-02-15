import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Repository for auth/session data.
class AuthRepository {
  final AuthService service;
  AuthRepository({AuthService? service}) : service = service ?? AuthService();

  Future<User> login(String email, String password) =>
      service.login(email, password);

  Future<User> signup(String name, String email, String password) =>
      service.signup(name, email, password);

  User? currentUser() => service.currentUser();

  void logout() => service.logout();

  void updateProfile({required String name, required String email, String? photoUrl}) {
    service.updateProfile(name: name, email: email, photoUrl: photoUrl);
  }
}
