import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/database/sample_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  User _currentUser = SampleData.currentUser;

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<User> login(String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = _currentUser.copyWith(phone: phone);
    return _currentUser;
  }

  @override
  Future<User> register(User user, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = user;
    return _currentUser;
  }

  @override
  Future<User> updateProfile(User user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = user;
    return _currentUser;
  }

  @override
  Future<User> switchRole(String newRole) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentUser = _currentUser.copyWith(role: newRole);
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
