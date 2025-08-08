import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../database.dart';
import '../models/gifticon.dart';
import '../services/gifticon_service.dart';

class GifticonCatalogPage extends StatefulWidget {
  const GifticonCatalogPage({super.key});

  @override
  State<GifticonCatalogPage> createState() => _GifticonCatalogPageState();
}

class _GifticonCatalogPageState extends State<GifticonCatalogPage> {
  bool _initialized = false;

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
        // 서버 실패 시 샘플 데이터로 채움
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
                          imageUrl: g.imageUrl,
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
}
