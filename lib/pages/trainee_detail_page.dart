
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
    // Mengambil data trainee dari Provider.
    final provider = context.watch<TraineeProvider>();

    // Mencari data trainee berdasarkan nama.
    final trainee = provider.trainees.firstWhere(
          (item) =>
      item['name'].toString().toLowerCase() ==
          traineeName.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );

    // Menampilkan pesan jika trainee tidak ditemukan.
    if (trainee.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B1028),
        appBar: AppBar(
          title: const Text('Detail Trainee'),
        ),
        body: const Center(
          child: Text(
            'Data trainee tidak ditemukan.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Mengambil informasi trainee.
    final name = trainee['name'].toString();
    final image = trainee['image']?.toString() ?? '';
    final description =
        trainee['description']?.toString() ?? 'Belum ada deskripsi.';
    final votes = trainee['votes'] ?? 0;

    // Memeriksa ukuran layar untuk menentukan layout.
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1028),

      // Menampilkan app bar halaman detail.
      appBar: AppBar(
        backgroundColor: const Color(0xFF151B3D),
        foregroundColor: Colors.white,
        title: const Text('Detail Trainee'),
      ),

      // Membuat konten dapat di-scroll pada layar kecil.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 20),
        child: Center(
          // Membatasi lebar konten di desktop.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: isDesktop
            // Layout dua kolom untuk desktop.
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan foto trainee.
                Expanded(
                  flex: 5,
                  child: buildTraineeImage(image),
                ),

                const SizedBox(width: 32),

                // Menampilkan informasi trainee.
                Expanded(
                  flex: 6,
                  child: buildTraineeInfo(
                    context,
                    provider,
                    name,
                    description,
                    votes,
                  ),
                ),
              ],
            )
            // Layout satu kolom untuk mobile.
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTraineeImage(image),

                const SizedBox(height: 24),

                buildTraineeInfo(
                  context,
                  provider,
                  name,
                  description,
                  votes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat foto trainee yang menyesuaikan ukuran kontainer.
  Widget buildTraineeImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: image.isNotEmpty
            ? Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return buildImagePlaceholder();
          },
        )
            : buildImagePlaceholder(),
      ),
    );
  }

  // Menampilkan ikon pengganti jika foto tidak tersedia.
  Widget buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF252B50),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        size: 100,
        color: Color(0xFFAEB6D9),
      ),
    );
  }

  // Membuat informasi, deskripsi, jumlah vote, dan tombol vote.
  Widget buildTraineeInfo(
      BuildContext context,
      TraineeProvider provider,
      String name,
      String description,
      dynamic votes,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan nama trainee.
        Text(
          name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 24),

        // Menampilkan judul deskripsi.
        const Text(
          'Tentang Trainee',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAEB6D9),
          ),
        ),

        const SizedBox(height: 12),

        // Menampilkan deskripsi dengan jarak antarbaris.
        Text(
          description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 24),

        // Menampilkan jumlah vote trainee.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151B3D),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Color(0xFFFF80AB),
                size: 26,
              ),
              const SizedBox(width: 12),
              const Text(
                'Total Vote',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '$votes',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Membuat tombol vote untuk trainee.
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Menambahkan vote untuk trainee melalui Provider.
              provider.voteForTrainee(name);

              // Menampilkan notifikasi setelah vote.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vote untuk $name berhasil!'),
                  backgroundColor: const Color(0xFF252B50),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Vote Trainee'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6979F8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
