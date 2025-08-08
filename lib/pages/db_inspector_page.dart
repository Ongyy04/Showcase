import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database.dart';
import '../models/user.dart';

class DbInspectorPage extends StatelessWidget {
  const DbInspectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = DatabaseService.currentUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('DB 확인'),
        actions: [
          IconButton(
            onPressed: () async {
              await DatabaseService.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃 완료')),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('현재 사용자: ${current?.username ?? '(없음)'}'),
            subtitle: Text('전화번호: ${current?.phone ?? '-'}'),
          ),
          const Divider(height: 1),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: DatabaseService.users.listenable(),
              builder: (context, Box<User> box, _) {
                final keys = box.keys.toList();
                if (keys.isEmpty) {
                  return const Center(child: Text('저장된 사용자 없음'));
                }
                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (_, i) {
                    final k = keys[i];
                    final u = box.get(k);
                    if (u == null) return const SizedBox.shrink();
                    return ListTile(
                      title: Text(u.username),
                      subtitle: Text('key: $k, phone: ${u.phone}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => box.delete(k),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
