
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';
import 'trainee_detail_page.dart';

class TraineePage extends StatelessWidget {
  const TraineePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'daftar trainee',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.separated(
                itemCount: provider.trainees.length,
                separatorBuilder: (_, _) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final trainee = provider.trainees[index];
                  final name = trainee['name'].toString();
                  final image = trainee['image'].toString();
                  final isFavorite = provider.isFavorite(name);

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF151B3D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF252B50),
                        backgroundImage: image.isNotEmpty
                            ? AssetImage(image)
                            : null,
                        child: image.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: isFavorite
                                ? 'hapus favorit'
                                : 'tambah favorit',
                            onPressed: () async {
                              final success =
                              await provider.toggleFavorite(name);

                              if (!context.mounted) return;

                              if (!success) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'favorit gagal diperbarui. pastikan kamu sudah login.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFFFF80AB),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFAEB6D9),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TraineeDetailPage(
                              traineeName: name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
