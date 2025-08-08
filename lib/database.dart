// lib/database.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/gifticon.dart'; // ✅ 추가
import 'models/login_event.dart';
import 'models/friend.dart';

class DatabaseService {
  static const int starPerLogin = 100;

  static Future<void> init() async {
    await Hive.initFlutter();

    // 어댑터 등록
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(GifticonAdapter()); // ✅ 추가

    // 박스 오픈
    await Hive.openBox<User>('users');
    await Hive.openBox('session');
    await Hive.openBox<Gifticon>('gifticons'); // ✅ 추가
    Hive.registerAdapter(LoginEventAdapter());
    Hive.registerAdapter(FriendAdapter()); // ✅ 추가

    await Hive.openBox<User>('users');
    await Hive.openBox('session');
    await Hive.openBox<LoginEvent>('login_events');
    await Hive.openBox<Friend>('friends'); // ✅ 추가
  }

  // 박스 게터
  static Box<User> get users => Hive.box<User>('users');
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons'); // ✅ 추가

  // 세션
  static Future<void> setCurrentUserKey(dynamic key) async =>
      session.put('currentUserKey', key);

  static dynamic currentUserKey() => session.get('currentUserKey');

  static Box<LoginEvent> get loginEvents => Hive.box<LoginEvent>('login_events');
  static Box<Friend> get friends => Hive.box<Friend>('friends'); // ✅ 추가

  static Future<void> setCurrentUserKey(int key) => session.put('currentUserKey', key);
  static int? currentUserKey() => session.get('currentUserKey');
  static User? currentUser() {
    final k = currentUserKey();
    if (k == null) return null;
    return users.get(k);
  }

  static Future<void> signOut() => session.delete('currentUserKey');

  static bool usernameExists(String username) =>
      users.values.any((u) => u.username == username);
  static bool phoneExists(String phone) =>
      users.values.any((u) => u.phone == phone);

  static Future<int> addUser(User u) async {
    final key = await users.add(u);
    return key;
  }

  static Future<void> logLogin(int userKey) async {
    await loginEvents.add(LoginEvent(userKey: userKey, at: DateTime.now()));
    final u = users.get(userKey);
    if (u != null) {
      u.starPoint += starPerLogin;
      await u.save();
    }
  }

  static int starPointOfUser(int userKey) {
    final u = users.get(userKey);
    return u?.starPoint ?? 0;
  }

  static List<LoginEvent> loginHistoryOfUser(int userKey) {
    return loginEvents.values
        .where((e) => e.userKey == userKey)
        .toList()
      ..sort((a, b) => b.at.compareTo(a.at));
  }

  // ===== Friends 관련 헬퍼 =====

  static Future<int> addFriend(Friend f) async {
    return await friends.add(f);
  }

  static Future<void> updateFriend(int key, Friend f) async {
    await friends.put(key, f);
  }

  static Future<void> deleteFriend(int key) async {
    await friends.delete(key);
  }

  static List<Friend> friendsOfCurrentUser({bool favoritesOnly = false}) {
    final owner = currentUserKey();
    if (owner == null) return [];
    final list = friends.values.where((f) => f.ownerUserKey == owner).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    if (favoritesOnly) {
      return list.where((f) => f.isFavorite).toList();
    }
    return list;
  }
}
