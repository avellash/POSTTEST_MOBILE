
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil pilihan voting dari Provider.
    final provider = context.watch<TraineeProvider>();

    // Menentukan lebar layar untuk menyesuaikan tampilan.
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return SafeArea(
      child: Center(
        // Membatasi lebar konten agar nyaman dibaca di desktop.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan judul halaman voting.
                Text(
                  'vote trainee',
                  style: TextStyle(
                    fontSize: isDesktop ? 32 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'pilih satu trainee favoritmu.',
                  style: TextStyle(
                    color: Color(0xFFAEB6D9),
                  ),
                ),

                const SizedBox(height: 20),

                // Menampilkan daftar trainee yang dapat dipilih.
                Expanded(
                  child: provider.voteTrainees.isEmpty
                      ? const Center(
                    child: Text(
                      'belum ada trainee untuk dipilih.',
                      style: TextStyle(
                        color: Color(0xFFAEB6D9),
                      ),
                    ),
                  )
                      : ListView.separated(
                    itemCount: provider.voteTrainees.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final trainee =
                      provider.voteTrainees[index];

                      // Memeriksa apakah trainee sedang dipilih.
                      final isSelected =
                          provider.selectedVoteIndex == index;

                      return Card(
                        margin: EdgeInsets.zero,
                        color: isSelected
                            ? const Color(0xFF302A60)
                            : const Color(0xFF151B3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF8B7FFF)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: RadioListTile<int>(
                          value: index,
                          groupValue: provider.selectedVoteIndex,

                          // Menyimpan pilihan trainee ke Provider.
                          onChanged: (value) {
                            if (value != null) {
                              provider.selectVote(value);
                            }
                          },

                          title: Text(
                            trainee,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          secondary: CircleAvatar(
                            backgroundColor:
                            const Color(0xFF252B50),
                            child: Icon(
                              Icons.person,
                              color: isSelected
                                  ? const Color(0xFFB7AEFF)
                                  : const Color(0xFFAEB6D9),
                            ),
                          ),

                          activeColor:
                          const Color(0xFF8B7FFF),
                          controlAffinity:
                          ListTileControlAffinity.trailing,
                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Menampilkan tombol kirim vote.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.selectedVoteIndex == -1
                        ? null
                        : () {
                      // Mengambil nama trainee yang dipilih.
                      final trainee = provider.voteTrainees[
                      provider.selectedVoteIndex];

                      // Menampilkan konfirmasi pilihan voting.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'vote untuk $trainee berhasil.',
                          ),
                          backgroundColor:
                          const Color(0xFF252B50),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B7FFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'kirim vote',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}
