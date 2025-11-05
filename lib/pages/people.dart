// lib/pages/people_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database.dart';
import '../models/friend.dart';
import 'myinfo.dart'; // MyInfo 페이지 import 유지

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  int? _ownerKey;

  @override
  void initState() {
    super.initState();
    _ownerKey = DatabaseService.currentUserKey();
  }

void _toggleFavorite(Friend f) async {
  f.isFavorite = !f.isFavorite;     // ✅ 레벨 건드리지 않음
  await f.save();
  setState(() {});                   // 즉시 갱신
}

  Future<void> _goNewFriend() async {
    final result = await Navigator.pushNamed(context, '/newpeople');
    if (result == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final owner = _ownerKey;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/arrow.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('모바일 쿠폰마켓', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Image.asset('assets/images/people.png', width: 24, height: 24),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/home'),
                  child: Image.asset('assets/images/home.png', width: 24, height: 24),
                ),
              ],
            ),
          )
        ],
      ),
      body: owner == null
          ? const Center(child: Text('로그인 후 이용해주세요'))
          : ValueListenableBuilder<Box<Friend>>(
              valueListenable: DatabaseService.friends.listenable(),
              builder: (context, box, _) {
                final all = box.values.where((f) => f.ownerUserKey == owner).toList()
                  ..sort((a, b) => a.name.compareTo(b.name));
                final closeFriends = all.where((f) => f.isFavorite).toList();
                final others = all.where((f) => !f.isFavorite).toList();

                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('친구', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/myinfo'),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('내 정보', style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    GestureDetector(
                      onTap: _goNewFriend,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_circle_outline, color: Colors.black),
                              SizedBox(width: 8),
                              Text('새로운 친구 등록하기', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SectionTitle(title: '친한친구'),
                            ...closeFriends.map((f) => FriendCard(friend: f, onStarTap: () => _toggleFavorite(f))).toList(),
                            const SectionTitle(title: '모든친구'),
                            ...others.map((f) => FriendCard(friend: f, onStarTap: () => _toggleFavorite(f))).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}

class FriendCard extends StatelessWidget {
  final Friend friend;
  final VoidCallback onStarTap;

  const FriendCard({super.key, required this.friend, required this.onStarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(friend.imagePath, width: 40, height: 40, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${friend.name}   |   ${friend.birthday}', style: const TextStyle(fontSize: 14)),
                GestureDetector(
                  onTap: onStarTap,
                  child: Icon(
                    Icons.star,
                    size: 20,
                    color: friend.isFavorite ? const Color(0xFFFFC727) : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
