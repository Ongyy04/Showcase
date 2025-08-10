// lib/database.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/gifticon.dart';
import 'models/login_event.dart';
import 'models/friend.dart';

class DatabaseService {
  static const int starPerLogin = 100;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return; // 중복 호출 가드
    await Hive.initFlutter();

    // 안전 등록 헬퍼
    void safeRegister<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter<T>(adapter);
      }
    }

    safeRegister<User>(UserAdapter());
    safeRegister<Gifticon>(GifticonAdapter());
    safeRegister<LoginEvent>(LoginEventAdapter());
    safeRegister<Friend>(FriendAdapter());

    // 안전 오픈 헬퍼
    Future<void> openBoxSafe<T>(String name) async {
      if (!Hive.isBoxOpen(name)) {
        await Hive.openBox<T>(name);
      }
    }

    await openBoxSafe<User>('users');
    await openBoxSafe<Gifticon>('gifticons');
    await openBoxSafe<LoginEvent>('login_events');
    await openBoxSafe<Friend>('friends');

    if (!Hive.isBoxOpen('session')) {
      await Hive.openBox('session');
    }

    _initialized = true;
  }

  static Box<User> get users => Hive.box<User>('users');
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons');
  static Box<LoginEvent> get loginEvents => Hive.box<LoginEvent>('login_events');
  static Box<Friend> get friends => Hive.box<Friend>('friends');

  static Future<void> setCurrentUserKey(int key) =>
      session.put('currentUserKey', key);

  static int? currentUserKey() => session.get('currentUserKey') as int?;

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

  static Future<int> addUser(User u) async => await users.add(u);

  static Future<void> logLogin(int userKey) async {
    await loginEvents.add(LoginEvent(userKey: userKey, at: DateTime.now()));
    final u = users.get(userKey);
    if (u != null) {
      u.starPoint += starPerLogin;
      await u.save();
    }
  }

  static int starPointOfUser(int userKey) =>
      users.get(userKey)?.starPoint ?? 0;

  static List<LoginEvent> loginHistoryOfUser(int userKey) {
    return loginEvents.values
        .where((e) => e.userKey == userKey)
        .toList()
      ..sort((a, b) => b.at.compareTo(a.at));
  }

  static Future<int> addFriend(Friend f) async => await friends.add(f);

  static Future<void> updateFriend(int key, Friend f) async =>
      await friends.put(key, f);

  static Future<void> deleteFriend(int key) async =>
      await friends.delete(key);

  static List<Friend> friendsOfCurrentUser({bool favoritesOnly = false}) {
    final owner = currentUserKey();
    if (owner == null) return [];
    final list =
        friends.values.where((f) => f.ownerUserKey == owner).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    return favoritesOnly ? list.where((f) => f.isFavorite).toList() : list;
  }
}
