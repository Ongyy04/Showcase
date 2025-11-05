// lib/services/database.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/gifticon.dart';
import '../models/login_event.dart';
import '../models/friend.dart';
import '../models/purchase.dart';

class DatabaseService {
  static const int starPerLogin = 100;
  static bool _initialized = false;
  static late Box<Purchase> purchases;

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();

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

    Future<void> openBoxSafe<T>(String name) async {
      if (!Hive.isBoxOpen(name)) {
        await Hive.openBox<T>(name);
      }
    }

    await openBoxSafe<User>('users');
    await openBoxSafe<Gifticon>('gifticons');
    await openBoxSafe<LoginEvent>('login_events');
    await openBoxSafe<Friend>('friends');
    await openBoxSafe<Purchase>('purchases');

    if (!Hive.isBoxOpen('session')) {
      await Hive.openBox('session');
    }

    purchases = Hive.box<Purchase>('purchases');

    _initialized = true;
  }

  static Box<User> get users => Hive.box<User>('users');
  static Box get session => Hive.box('session');
  static Box<Gifticon> get gifticons => Hive.box<Gifticon>('gifticons');
  static Box<LoginEvent> get loginEvents => Hive.box<LoginEvent>('login_events');
  static Box<Friend> get friends => Hive.box<Friend>('friends');
  static Box<Purchase> get purchase => Hive.box<Purchase>('purchases');

  static Future<void> setCurrentUserKey(int key) =>
      session.put('currentUserKey', key);

  static int? currentUserKey() => session.get('currentUserKey') as int?;

  static User? currentUser() {
    final k = currentUserKey();
    if (k == null) return null;
    return users.get(k);
  }

  static Future<void> signOut() => session.delete('currentUserKey');

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

  static Future<void> deleteGifticon(int key) async {
    await gifticons.delete(key);
  }

  static List<Gifticon> gifticonsOfCurrentUser() {
    final userKey = currentUserKey();
    if (userKey == null) {
      return [];
    }
    return gifticons.values.where((g) => g.ownerUserKey == userKey).toList();
  }

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