import 'package:flutter/material.dart';
import 'package:my_app/models/friend.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/pages/newpeople.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final String brand = args['brand'] ?? '스타벅스';
    final String name = args['name'] ?? '카페라떼 (ICE)';
    final String imageAsset = args['imageAsset'] ?? 'assets/images/starcafe.png';
    final int originalPrice = args['originalPrice'] ?? 4500;
    final int salePrice = args['salePrice'] ?? 4050;
    final int discountPercent = args['discountPercent'] ?? 10;

    const divider = Color(0xFFE7E8EC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '상품 상세 페이지',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        // ▼ 여기만 변경됨
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              'assets/images/people.png',
              width: 24,
              height: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              'assets/images/home.png',
              width: 24,
              height: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Image.asset(
              'assets/images/more.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                ],
                border: Border.all(color: divider),
              ),
              child: SizedBox(
                width: 280,
                height: 280,
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '[$brand] $name',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_money(originalPrice)}원',
                style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 13),
              ),
              const SizedBox(width: 12),
              Text('$discountPercent%',
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 6),
              Text('${_money(salePrice)}원',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: divider),
          const SizedBox(height: 16),
          const Text('상품 설명',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const _BulletLine('부드러운 우유가 들어있는 커피로 전세계적으로 스타벅스에서 가장 인기있는 음료중 하나입니다.'),
          const _BulletLine('Only ICE'),
          const SizedBox(height: 20),
          const Text('이용 안내',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const _BulletLine('상기 이미지는 연출된 컷으로 실제와 다를 수 있습니다.'),
          const _BulletLine('일부 매장 재고, 상황에 따라 동일 상품으로 교환이 불가능할 수 있습니다.'),
          const _BulletLine('동일 상품 교환이 불가할 경우 다른 상품으로 교환이 가능합니다.'),
          const SizedBox(height: 80),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
            ],
            border: Border.all(color: divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/payment',
                      arguments: {
                        'brand': brand,
                        'name': name,
                        'imageAsset': imageAsset,
                        'salePrice': salePrice,
                        'qty': 1,
                        'selfGift': true,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: divider),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('나에게 선물',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await _openFriendPicker(context);
                    if (result != null && context.mounted) {
                      final friend = result['friend'] as Friend;
                      final qty = result['qty'] as int;

                      Navigator.pushNamed(
                        context,
                        '/payment',
                        arguments: {
                          'brand': brand,
                          'name': name,
                          'imageAsset': imageAsset,
                          'salePrice': salePrice,
                          'friend': friend,
                          'qty': qty,
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9DB63),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('친구에게 선물',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _money(int v) =>
      v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}

class _BulletLine extends StatelessWidget {
  final String text;
  const _BulletLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.35)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.35))),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> _openFriendPicker(BuildContext context) async {
  final owner = DatabaseService.currentUserKey();
  if (owner == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('로그인이 필요합니다')));
    return null;
  }
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FriendPickerSheet(ownerUserKey: owner),
  );
}

class FriendPickerSheet extends StatefulWidget {
  final int ownerUserKey;
  const FriendPickerSheet({super.key, required this.ownerUserKey});

  @override
  State<FriendPickerSheet> createState() => _FriendPickerSheetState();
}

class _FriendPickerSheetState extends State<FriendPickerSheet> {
  Friend? selected;
  final _search = TextEditingController();
  int _qty = 1;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<Friend>> _load() async =>
      DatabaseService.getFriends(widget.ownerUserKey);

  @override
  Widget build(BuildContext context) {
    const divider = Color(0xFFE7E8EC);

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.40,
      maxChildSize: 0.92,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -6))
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                        child: Text('친구 선택',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700))),
                    TextButton.icon(
                      onPressed: () async {
                        final ok = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewPeoplePage()));
                        if (ok == true && mounted) setState(() {});
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF383C59)),
                      icon: const Icon(Icons.person_add_alt_1,
                          size: 18, color: Color(0xFF383C59)),
                      label: const Text('친구추가',
                          style: TextStyle(
                              color: Color(0xFF383C59),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: '이름으로 검색',
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: FutureBuilder<List<Friend>>(
                  future: _load(),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('불러오기 실패: ${snap.error}'));
                    }
                    var list = snap.data ?? [];
                    final q = _search.text.trim();
                    if (q.isNotEmpty) {
                      list = list.where((f) => f.name.contains(q)).toList();
                    }

                    if (list.isEmpty) {
                      return const Center(
                          child: Text('등록된 친구가 없습니다.\n오른쪽 상단에서 추가하세요.',
                              textAlign: TextAlign.center));
                    }

                    return ListView.separated(
                      controller: controller,
                      itemCount: list.length,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final f = list[i];
                        final isSelected = identical(selected, f);
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => selected = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6))
                              ],
                              border: Border.all(
                                  color: isSelected ? Colors.black : divider),
                            ),
                            child: Row(
                              children: [
                                _AvatarFromFriend(f),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(f.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                      const SizedBox(width: 8),
                                      const Text('｜',
                                          style:
                                              TextStyle(color: Colors.black87)),
                                      const SizedBox(width: 8),
                                      Text(f.birthday,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black26),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              if (selected != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: divider),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QtyIconButton(
                          icon: Icons.remove,
                          onTap:
                              _qty > 1 ? () => setState(() => _qty--) : null,
                        ),
                        Text('$_qty',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        _QtyIconButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE7E8EC)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('닫기',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, {
                            'friend': selected,
                            'qty': _qty,
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9DB63),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text('선물하기',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QtyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFF383C59) : Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: enabled ? Colors.white : Colors.black38, size: 22),
        ),
      ),
    );
  }
}

class _AvatarFromFriend extends StatelessWidget {
  final Friend f;
  const _AvatarFromFriend(this.f);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF383C59),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          f.imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
