import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AuthService {
  final Account account;

  AuthService(Client client) : account = Account(client);

  Future<User> signUp(String email, String password, String name) async {
    return await account.create(
        userId: ID.unique(), name: name, email: email, password: password);
  }

  Future<Session> login(String email, String password) async {
    return await account.createEmailSession(email: email, password: password);
  }

  Future<void> logout() async {
    await account.deleteSessions();
  }

  Future<User> getUser() async {
    return await account.get();
  }
}
