// lib/services/database.dart
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_app/models/user.dart';
import 'package:my_app/models/gifticon.dart';
import 'package:my_app/models/login_event.dart';
import 'package:my_app/models/friend.dart';
import 'package:my_app/models/purchase.dart';

class DatabaseService {
  static const int starPerLogin = 100;
  static bool _initialized = false;

  // 캐시 박스
  static late Box<User> _userBox;
  static late Box<Purchase> _purchases;

  // -------- init --------
  static Future<void> init() async {
    if (_initialized) return;

    // 안전 어댑터 등록
    void safeRegister<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter<T>(adapter);
      }
    }

    safeRegister<User>(UserAdapter());
    safeRegister<Gifticon>(GifticonAdapter());
    safeRegister<LoginEvent>(LoginEventAdapter());
    safeRegister<Friend>(FriendAdapter());
    safeRegister<Purchase>(PurchaseAdapter());

    // 안전 박스 열기
    Future<Box<T>> openBoxSafe<T>(String name) async {
      try {
        return await Hive.openBox<T>(name);
      } catch (_) {
        // 깨진 박스 삭제 후 재생성
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/hive/$name.hive');
        if (await file.exists()) await file.delete();
        return await Hive.openBox<T>(name);
      }
    }

    _userBox = await openBoxSafe<User>('users');
    await openBoxSafe<Gifticon>('gifticons');
    await openBoxSafe<LoginEvent>('login_events');
    await openBoxSafe<Friend>('friends');
    _purchases = await openBoxSafe<Purchase>('purchases');
    await openBoxSafe('session');

    _initialized = true;
  }

  // -------- Box getters --------
  static Box<User> get users => _userBox;
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons');
  static Box<LoginEvent> get loginEvents => Hive.box<LoginEvent>('login_events');
  static Box<Friend> get friends => Hive.box<Friend>('friends');
  static Box<Purchase> get purchases => _purchases;

  // -------- Session / User --------
  static Future<void> setCurrentUserKey(int key) async =>
      session.put('currentUserKey', key);

  static int? currentUserKey() => session.get('currentUserKey') as int?;

  static User? currentUser() {
    final k = currentUserKey();
    if (k == null) return null;
    return users.get(k);
  }

  static Future<void> signOut() => session.delete('currentUserKey');

  // -------- Users --------
  static bool usernameExists(String username) =>
      users.values.any((u) => u.username == username);

  static bool phoneExists(String phone) =>
      users.values.any((u) => u.phone == phone);

  static Future<int> addUser(User u) => users.add(u);

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

  static List<LoginEvent> loginHistoryOfUser(int userKey) =>
      (loginEvents.values.where((e) => e.userKey == userKey).toList()
        ..sort((a, b) => b.at.compareTo(a.at)));

  // -------- Purchases / Gifticons --------
  static Future<void> addPurchase({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final purchase = Purchase(
      userId: userId,
      productId: productId,
      purchaseDate: DateTime.now(),
      quantity: quantity,
    );
    await purchases.add(purchase);
  }

  static Future<void> deleteGifticon(int key) async => gifticons.delete(key);

  static List<Gifticon> gifticonsOfCurrentUser() {
    final userKey = currentUserKey();
    if (userKey == null) return [];
    return gifticons.values
        .where((g) => g.ownerUserKey == userKey)
        .toList();
  }

  // -------- Friends --------
  static Future<int> addFriend(Friend f) => friends.add(f);

  static Future<void> updateFriend(int key, Friend f) => friends.put(key, f);

  static Future<void> deleteFriend(int key) => friends.delete(key);

  static List<Friend> friendsOfCurrentUser({bool favoritesOnly = false}) {
    final owner = currentUserKey();
    if (owner == null) return [];
    final list = friends.values
        .where((f) => f.ownerUserKey == owner)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return favoritesOnly ? list.where((f) => f.isFavorite).toList() : list;
  }

  static Future<List<Friend>> getFriends(int ownerUserKey) async {
    final list = friends.values
        .where((f) => f.ownerUserKey == ownerUserKey)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }
}
