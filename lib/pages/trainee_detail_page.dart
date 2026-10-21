
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class TraineeDetailPage extends StatelessWidget {
  final String traineeName;

  const TraineeDetailPage({
    super.key,
    required this.traineeName,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();

    // Mencari data trainee berdasarkan nama.
    final trainee = provider.trainees.firstWhere(
          (item) =>
      item['name'].toString().toLowerCase() ==
          traineeName.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );

    // Menampilkan halaman jika data trainee tidak ditemukan.
    if (trainee.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B1028),
        appBar: AppBar(
          backgroundColor: const Color(0xFF151B3D),
          title: const Text('detail trainee'),
        ),
        body: const Center(
          child: Text(
            'data trainee tidak ditemukan.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final name = trainee['name'].toString();
    final image = trainee['image']?.toString() ?? '';
    final description =
        trainee['description']?.toString() ??
            'belum ada deskripsi.';
    final isFavorite = provider.isFavorite(name);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1028),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151B3D),
        title: const Text('detail trainee'),
        actions: [
          // Tombol untuk menambah atau menghapus favorit.
          IconButton(
            tooltip:
            isFavorite ? 'hapus favorit' : 'tambah favorit',
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Area foto trainee.


              LayoutBuilder(
                builder: (context, constraints) {
                  // Menentukan lebar foto sesuai lebar halaman.
                  final imageWidth = constraints.maxWidth;

                  return Container(
                    width: imageWidth,
                    height: imageWidth * 5 / 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151B3D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: image.isNotEmpty
                        ? Image.asset(
                      image,
                      width: imageWidth,
                      height: imageWidth * 5 / 4,
                      fit: BoxFit.fill,
                      errorBuilder: (_, _, _) {
                        return const Icon(
                          Icons.person,
                          size: 100,
                          color: Color(0xFFAEB6D9),
                        );
                      },
                    )
                        : const Icon(
                      Icons.person,
                      size: 100,
                      color: Color(0xFFAEB6D9),
                    ),
                  );
                },
              ),


              const SizedBox(height: 22),

              // Nama trainee.
              Text(
                name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // Judul bagian deskripsi.
              const Text(
                'tentang trainee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB7AEFF),
                ),
              ),

              const SizedBox(height: 8),

              // Deskripsi trainee.
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFFAEB6D9),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol untuk menuju halaman voting.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final index =
                    provider.voteTrainees.indexOf(name);

                    // Memilih trainee sebelum berpindah halaman.
                    if (index >= 0 &&
                        !provider.hasReachedVoteLimit) {
                      provider.selectVote(index);
                    }

                    // Berpindah ke halaman voting.
                    provider.changePage(1);

                    // Menutup halaman detail.
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.how_to_vote),
                  label: const Text('vote trainee ini'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7FFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
