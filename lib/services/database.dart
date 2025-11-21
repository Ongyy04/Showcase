// lib/services/database.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  static late Box<User> _userBox;
  static late Box<Purchase> _purchases;
  static late Box _couponBox;

  static Box get coupons => _couponBox;

  static Future<void> init() async {
    if (_initialized) return;

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

    Future<Box<T>> openBoxSafe<T>(String name) async {
      if (kIsWeb) {
        return await Hive.openBox<T>(name);
      }

      try {
        return await Hive.openBox<T>(name);
      } catch (_) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/hive/$name.hive');
        if (await file.exists()) {
          await file.delete();
        }
        return await Hive.openBox<T>(name);
      }
    }

    _couponBox = await openBoxSafe('coupons');
    _userBox = await openBoxSafe<User>('users');
    await openBoxSafe<Gifticon>('gifticons');
    await openBoxSafe<LoginEvent>('login_events');
    await openBoxSafe<Friend>('friends');
    _purchases = await openBoxSafe<Purchase>('purchases');
    await openBoxSafe('session');

    _initialized = true;
  }

  static Box<User> get users => _userBox;
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons');
  static Box<LoginEvent> get loginEvents => Hive.box<LoginEvent>('login_events');
  static Box<Friend> get friends => Hive.box<Friend>('friends');
  static Box<Purchase> get purchases => _purchases;

  // ---- Session ----
  static Future<void> setCurrentUserKey(int key) async =>
      session.put('currentUserKey', key);

  static int? currentUserKey() => session.get('currentUserKey') as int?;

  static User? currentUser() {
    final k = currentUserKey();
    if (k == null) return null;
    return users.get(k);
  }

  static Future<void> signOut() => session.delete('currentUserKey');

  // 추가된 함수
  static Future<void> clearCurrentUserKey() => signOut();

  // ---- User ----
  static bool usernameExists(String username) =>
      users.values.any((u) => u.username == username);

  static bool phoneExists(String phone) =>
      users.values.any((u) => u.phone == phone);

  static Future<int> addUser(User u) => users.add(u);

  static Future<void> logLogin(int userKey) async {
    await loginEvents.add(LoginEvent(userKey: userKey, at: DateTime.now()));

    DatabaseTriggers.runTrigger("login", {"userKey": userKey});
  }

  static int starPointOfUser(int userKey) =>
      users.get(userKey)?.starPoint ?? 0;

  static List<LoginEvent> loginHistoryOfUser(int userKey) =>
      (loginEvents.values.where((e) => e.userKey == userKey).toList()
        ..sort((a, b) => b.at.compareTo(a.at)));

  // ---- Purchase ----
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

    DatabaseTriggers.runTrigger("purchase", {
      "userId": userId,
      "productId": productId,
      "quantity": quantity,
    });
  }

  static Future<void> deleteGifticon(int key) async => gifticons.delete(key);

  static List<Gifticon> gifticonsOfCurrentUser() {
    final userKey = currentUserKey();
    if (userKey == null) return [];
    return gifticons.values
        .where((g) => g.ownerUserKey == userKey)
        .toList();
  }

  // ---- Friends ----
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

  // ---- Transaction ----
  static Future<void> addTransaction({
    required int userKey,
    required String actionType,
    required String brand,
    required String itemName,
    required int price,
    required int balanceBefore,
    required int balanceAfter,
    required String useStore,
    required String paymentMethod,
    required String paymentDetails,
  }) async {
    final user = users.get(userKey);
    if (user == null) return;

    List<Map<String, dynamic>> history = user.transactionHistory;

    history.add({
      "actionType": actionType,
      "brand": brand,
      "itemName": itemName,
      "price": price,
      "balanceBefore": balanceBefore,
      "balanceAfter": balanceAfter,
      "useStore": useStore,
      "paymentMethod": paymentMethod,
      "paymentDetails": paymentDetails,
      "timestamp": DateTime.now().toIso8601String(),
    });

    user.transactionHistory = history;
    await user.save();

    DatabaseTriggers.runTrigger("transaction", {
      "userKey": userKey,
      "actionType": actionType,
      "brand": brand,
      "itemName": itemName,
      "price": price,
    });
  }
}

// ---- Trigger System ----
extension DatabaseTriggers on DatabaseService {
  static final Map<String, List<Function(dynamic)>> _triggers = {};

  static void registerTrigger(
      String eventName, Function(dynamic payload) callback) {
    _triggers.putIfAbsent(eventName, () => []);
    _triggers[eventName]!.add(callback);
  }

  static Future<void> runTrigger(String eventName, dynamic payload) async {
    if (!_triggers.containsKey(eventName)) return;

    for (final cb in _triggers[eventName]!) {
      await cb(payload);
    }
  }
}
