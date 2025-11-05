// lib/pages/gifticon_catalog_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/database.dart';
import '../models/gifticon.dart';
import '../models/user.dart'; // User 모델 import
import '../services/gifticon_service.dart';

class GifticonCatalogPage extends StatefulWidget {
  const GifticonCatalogPage({super.key});

  @override
  State<GifticonCatalogPage> createState() => _GifticonCatalogPageState();
}

class _GifticonCatalogPageState extends State<GifticonCatalogPage> {
  bool _initialized = false;

  User? get currentUser => DatabaseService.currentUser(); // 현재 로그인된 사용자 정보

  @override
  void initState() {
    super.initState();
    _seedIfEmpty();
  }

  Future<void> _seedIfEmpty() async {
    if (DatabaseService.gifticons.isEmpty) {
      try {
        await GifticonService.syncFromServer(
          'https://gist.githubusercontent.com/Kimjianz/c4bc6477671b874fff61658cd2321313/raw/36e34eeafb36456fde72f1ab18e98ebd7fea3ef8/catalog.json',
        );
      } catch (_) {
        await GifticonService.seedSamples();
      }
    }
    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기프티콘 카탈로그'),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<Box<Gifticon>>(
              valueListenable: DatabaseService.gifticons.listenable(),
              builder: (context, box, _) {
                final items = box.values.toList();
                if (items.isEmpty) {
                  return const Center(child: Text('데이터 없음'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final g = items[idx];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          // 🔴 수정: g.imageUrl 대신 g.imagePath 사용
                          imageUrl: g.imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const SizedBox(
                            width: 56,
                            height: 56,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(g.name),
                      subtitle: Text('${g.brand} · ${g.price}원'),
                      trailing: ElevatedButton(
                        onPressed: () => _showPurchaseDialog(context, g),
                        child: const Text('구매'),
                      ),
                      onTap: () => _showPurchaseDialog(context, g),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await GifticonService.syncFromServer(
            'https://gist.githubusercontent.com/Kimjianz/c4bc6477671b874fff61658cd2321313/raw/36e34eeafb36456fde72f1ab18e98ebd7fea3ef8/catalog.json',
          );
        },
        label: const Text('서버에서 동기화'),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, Gifticon gifticon) {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 후 이용해 주세요.')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${gifticon.name} 구매'),
        content: Text('정말로 ${gifticon.price}원을 사용하여 이 기프티콘을 구매하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (currentUser!.starPoint < gifticon.price) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('별점이 부족합니다.')),
                );
                return;
              }
              
              await DatabaseService.addPurchase(
                userId: currentUser!.username,
                productId: gifticon.id,
                quantity: 1,
              );
              
              currentUser!.starPoint -= gifticon.price;
              await currentUser!.save();
              
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${gifticon.name}을(를) 구매했습니다!')),
              );
            },
            child: const Text('구매'),
          ),
        ],
      ),
    );
  }
}