
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Data contoh untuk tampilan riwayat voting.
  // Nantinya data ini akan diambil dari Firebase.
  static const List<Map<String, String>> votingHistory = [
    {
      'name': 'Fuko',
      'image': 'assets/images/fuko_2.jpg',
    },
    {
      'name': 'Jeemin',
      'image': 'assets/images/jeemin_1.jpg',
    },
    {
      'name': 'Koko',
      'image': 'assets/images/koko_2.jpg',
    },
  ];

  // Data contoh untuk tampilan trainee favorit.
  static const List<Map<String, String>> favoriteTrainees = [
    {
      'name': 'Gyuri',
      'image': 'assets/images/gyuri_2.jpg',
    },
    {
      'name': 'Saebi',
      'image': 'assets/images/saebi_2.jpg',
    },
    {
      'name': 'Jiyoon',
      'image': 'assets/images/jiyoon_1.jpg',
    },
  ];

  // Warna yang mengikuti tema gelap aplikasi.
  static const Color backgroundColor = Color(0xFF101326);
  static const Color cardColor = Color(0xFF151B3D);
  static const Color accentColor = Color(0xFF8B7FFF);
  static const Color secondaryText = Color(0xFFAEB6D9);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return SafeArea(
      child: Center(
        // Membatasi lebar konten agar tetap rapi di layar besar.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul halaman profil.
                Row(
                  children: [
                    const Icon(
                      Icons.nightlight_round,
                      color: accentColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'my space',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 30 : 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Header profil pengguna.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF302A60),
                        Color(0xFF171C3D),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF514784),
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 43,
                        backgroundColor: Color(0xFF494078),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'user profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        '@iland_fan',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'your i-land journey starts here ✦',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD2CBFF),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tombol edit profil untuk tampilan sementara.
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'fitur edit profil akan ditambahkan nanti.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('edit profil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: accentColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Bagian riwayat voting.
                _buildSectionTitle(
                  icon: Icons.history,
                  title: 'riwayat voting',
                  subtitle: 'trainee yang pernah kamu pilih',
                ),

                const SizedBox(height: 14),

                ...votingHistory.map(
                      (trainee) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildTraineeCard(
                      trainee: trainee,
                      trailing: const Icon(
                        Icons.check_circle_outline,
                        color: accentColor,
                        size: 22,
                      ),
                      subtitle: 'pernah dipilih',
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Bagian trainee favorit.
                _buildSectionTitle(
                  icon: Icons.favorite,
                  title: 'trainee favorit',
                  subtitle: 'trainee yang kamu sukai',
                ),

                const SizedBox(height: 14),

                ...favoriteTrainees.map(
                      (trainee) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildTraineeCard(
                      trainee: trainee,
                      trailing: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF8FA3),
                        size: 22,
                      ),
                      subtitle: 'trainee favorit',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol logout, belum dihubungkan ke autentikasi.
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFFFF9DAE),
                    ),
                    title: const Text(
                      'logout',
                      style: TextStyle(
                        color: Color(0xFFFF9DAE),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: secondaryText,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'fitur logout akan dihubungkan nanti.',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'i-LAND 2 • fan space ✦',
                    style: TextStyle(
                      color: Color(0xFF777FA8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat judul dan deskripsi setiap bagian.
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: accentColor,
          size: 25,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Membuat kartu trainee yang digunakan di dua bagian.
  Widget _buildTraineeCard({
    required Map<String, String> trainee,
    required Widget trailing,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF252B50),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),

        // Menampilkan foto trainee dari folder assets.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            trainee['image']!,
            width: 52,
            height: 58,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 52,
                height: 58,
                color: const Color(0xFF252B50),
                child: const Icon(
                  Icons.person,
                  color: secondaryText,
                  size: 30,
                ),
              );
            },
          ),
        ),

        // Menampilkan nama dan keterangan trainee.
        title: Text(
          trainee['name']!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ),

        trailing: trailing,
      ),
    );
  }
}
