import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<Friend> closeFriends = [
    Friend('김현정', '2005.03.09', 4, 'g'),
    Friend('김지안', '2005.07.13', 3, 'b'),
    Friend('김지성', '2005.07.20', 4, 'g'),
  ];

  List<Friend> allFriends = [
    Friend('김지안', '2005.07.13', 2, 'b'),
    Friend('김지안', '2005.07.13', 1, 'b'),
    Friend('김지안', '2005.07.13', 2, 'g'),
    Friend('김지안', '2005.07.13', 1, 'g'),
    Friend('김지안', '2005.07.13', 2, 'b'),
  ];

  void toggleFavorite(Friend friend) {
    setState(() {
      if (closeFriends.contains(friend)) {
        closeFriends.remove(friend);
        allFriends.add(friend.copyWith(level: friend.level < 2 ? 1 : friend.level - 1));
      } else {
        allFriends.remove(friend);
        closeFriends.add(friend.copyWith(level: friend.level >= 4 ? 4 : friend.level + 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('친구', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('내 정보', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SectionTitle(title: '친한친구'),
                  ...closeFriends.map((friend) => FriendCard(friend: friend, onStarTap: () => toggleFavorite(friend))).toList(),
                  const SectionTitle(title: '모든친구'),
                  ...allFriends.map((friend) => FriendCard(friend: friend, onStarTap: () => toggleFavorite(friend))).toList(),
                ],
              ),
            ),
          )
        ],
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

class Friend {
  final String name;
  final String birthday;
  final int level; // 1~4
  final String type; // 'g' 또는 'b'

  Friend(this.name, this.birthday, this.level, this.type);

  String get imagePath => 'assets/images/chick_${type}${level}.png';
  bool get isFavorite => level >= 3;

  Friend copyWith({String? name, String? birthday, int? level, String? type}) {
    return Friend(
      name ?? this.name,
      birthday ?? this.birthday,
      level ?? this.level,
      type ?? this.type,
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
