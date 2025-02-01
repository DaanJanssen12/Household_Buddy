import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Account account;

  AuthService(Client client) : account = Account(client);

  Future<User> signUp(String email, String password, String name) async {
    return await account.create(
        userId: ID.unique(), name: name, email: email, password: password);
  }

  Future<Session?> login(String email, String password) async {
    try {
      var session = await account.createEmailPasswordSession(
          email: email, password: password);
      return session;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString('sessionToken');
    await prefs.remove('sessionToken');
    await account.deleteSession(sessionId: sessionId ?? 'current');
  }

  Future<User> getUser() async {
    return await account.get();
  }

  Future<bool> checkIfLoggedIn() async {
    // var sessions = await account.listSessions();
    // for (var session in sessions.sessions) {
    //   print(session.$id);
    // }

    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('sessionToken');

    if (sessionToken != null) {
      try {
        final session = await account.getSession(sessionId: sessionToken);

        if (session.$id.isNotEmpty) {
          return true;
        }
      } catch (e) {
        print("Session invalid, user must log in again.");
      }
    }
    return false;
  }
}
