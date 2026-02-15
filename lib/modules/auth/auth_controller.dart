import 'package:get/get.dart';
import '../../app/data/models/user_model.dart';
import '../../app/data/repositories/auth_repository.dart';

/// Auth state controller for login/signup/session.
class AuthController extends GetxController {
  final AuthRepository repo = AuthRepository();
  final user = Rxn<User>();
  final loading = false.obs;
  String? _pendingRoute;

  bool get isLoggedIn => user.value != null;
  String? consumePendingRoute() {
    final route = _pendingRoute;
    _pendingRoute = null;
    return route;
  }

  void setPendingRoute(String? route) {
    _pendingRoute = route;
  }

  @override
  void onInit() {
    user.value = repo.currentUser();
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    loading.value = true;
    try {
      user.value = await repo.login(email, password);
    } finally {
      loading.value = false;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    loading.value = true;
    try {
      user.value = await repo.signup(name, email, password);
    } finally {
      loading.value = false;
    }
  }

  void logout() {
    repo.logout();
    user.value = null;
  }

  void updateProfile({required String name, required String email, String? photoUrl}) {
    repo.updateProfile(name: name, email: email, photoUrl: photoUrl);
    user.value = User(name: name, email: email, photoUrl: photoUrl);
  }
}
