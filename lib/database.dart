import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>('users');
    await Hive.openBox('session');
  }

  static Box<User> get users => Hive.box<User>('users');
  static Box get session => Hive.box('session');

  static Future<void> setCurrentUserKey(dynamic key) async =>
      session.put('currentUserKey', key);

  static dynamic currentUserKey() => session.get('currentUserKey');

  static User? currentUser() {
    final k = currentUserKey();
    if (k == null) return null;
    return users.get(k);
  }

  static Future<void> signOut() async => session.delete('currentUserKey');

  // ---------- helpers ----------
  static bool usernameExists(String username) =>
      users.values.any((u) => u.username == username);

  static bool phoneExists(String phone) =>
      users.values.any((u) => u.phone == phone);

  static Future<dynamic> addUser(User u) => users.add(u);
}
