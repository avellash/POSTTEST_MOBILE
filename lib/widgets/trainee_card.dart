
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class TraineeCard extends StatelessWidget {
  final String name;
  final String image;
  final IconData icon;

  const TraineeCard({
    super.key,
    required this.name,
    required this.image,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();
    final isFavorite = provider.isFavorite(name);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF151B3D),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF252B50),
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        icon,
                        size: 60,
                        color: const Color(0xFFAEB6D9),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'hapus dari favorit'
                      : 'tambah ke favorit',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    final success =
                    await provider.toggleFavorite(name);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? (isFavorite
                              ? '$name dihapus dari favorit.'
                              : '$name ditambahkan ke favorit.')
                              : 'favorit gagal diperbarui. pastikan kamu sudah login.',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: const Color(0xFFFF80AB),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final index =
                  provider.voteTrainees.indexOf(name);

                  if (index >= 0 &&
                      !provider.hasReachedVoteLimit) {
                    provider.selectVote(index);
                  }

                  // Membuka halaman Vote Trainee, bukan halaman detail.
                  provider.changePage(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7FFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('vote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
