// lib/database.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/gifticon.dart'; // ✅ 추가

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // 어댑터 등록
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(GifticonAdapter()); // ✅ 추가

    // 박스 오픈
    await Hive.openBox<User>('users');
    await Hive.openBox('session');
    await Hive.openBox<Gifticon>('gifticons'); // ✅ 추가
  }

  // 박스 게터
  static Box<User> get users => Hive.box<User>('users');
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons'); // ✅ 추가

  // 세션
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
