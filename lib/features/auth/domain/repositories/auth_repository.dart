import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> login(String phone, String password);
  Future<User> register(User user, String password);
  Future<User> updateProfile(User user);
  Future<User> switchRole(String newRole);
  Future<void> logout();
}
