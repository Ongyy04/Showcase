// lib/services/database.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/models/gifticon.dart';
import 'package:my_app/models/login_event.dart';
import 'package:my_app/models/friend.dart';
import 'package:my_app/models/purchase.dart';

class DatabaseService {
  static const int starPerLogin = 100;
  static bool _initialized = false;

  // 필요 박스 캐시(선택)
  static late Box<Purchase> _purchases;

  // -------- init --------
  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // 안전 등록 헬퍼
    void safeRegister<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter<T>(adapter);
      }
    }

    // ✅ 모든 모델 어댑터 등록
    safeRegister<User>(UserAdapter());
    safeRegister<Gifticon>(GifticonAdapter());
    safeRegister<LoginEvent>(LoginEventAdapter());
    safeRegister<Friend>(FriendAdapter());   // <- Friend 어댑터 필수
    safeRegister<Purchase>(PurchaseAdapter());

    // 박스 오픈 헬퍼
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

    _purchases = Hive.box<Purchase>('purchases');
    _initialized = true;
  }

  // -------- Box getters --------
  static Box<User> get users => Hive.box<User>('users');
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

  // -------- Purchases / Gifticons (기존 그대로) --------
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
    return gifticons.values.where((g) => g.ownerUserKey == userKey).toList();
  }

  // -------- Friends --------
  static Future<int> addFriend(Friend f) => friends.add(f);

  static Future<void> updateFriend(int key, Friend f) => friends.put(key, f);

  static Future<void> deleteFriend(int key) => friends.delete(key);

  /// 현재 로그인 사용자의 친구 목록 (알파벳/가나다 정렬)
  static List<Friend> friendsOfCurrentUser({bool favoritesOnly = false}) {
    final owner = currentUserKey();
    if (owner == null) return [];
    final list = friends.values
        .where((f) => f.ownerUserKey == owner)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return favoritesOnly ? list.where((f) => f.isFavorite).toList() : list;
  }

  /// 임의 ownerKey의 친구 목록 가져오기 (하단 시트에서 사용)
  static Future<List<Friend>> getFriends(int ownerUserKey) async {
    final list = friends.values
        .where((f) => f.ownerUserKey == ownerUserKey)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }
}
