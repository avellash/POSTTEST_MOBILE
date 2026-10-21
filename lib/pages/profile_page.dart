
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    // Memuat data akun, riwayat, dan favorit dari Firestore.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TraineeProvider>().loadUserData();
      }
    });
  }

  String _formatDate(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year • $hour:$minute';
    }

    return 'waktu belum tersedia';
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF151B3D),
        title: const Text(
          'keluar akun?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'kamu akan keluar dari akun saat ini.',
          style: TextStyle(color: Color(0xFFAEB6D9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      final provider = context.read<TraineeProvider>();
      await provider.loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: provider.loadUserData,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'profil saya',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151B3D),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFF252B50),
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Color(0xFFB7AEFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.email ?? 'belum login',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'vote digunakan: ${provider.voteCount}/${TraineeProvider.maxVotes}',
                    style: const TextStyle(
                      color: Color(0xFFB7AEFF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'sisa vote: ${provider.remainingVotes}',
                    style: const TextStyle(
                      color: Color(0xFFAEB6D9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: user == null ? null : _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('keluar akun'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'riwayat voting',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            if (provider.isLoadingUserData)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Color(0xFF8B7FFF),
                  ),
                ),
              )
            else if (user == null)
              const Text(
                'login untuk melihat riwayat voting.',
                style: TextStyle(color: Color(0xFFAEB6D9)),
              )
            else if (provider.votingHistory.isEmpty)
                const Text(
                  'belum ada riwayat voting.',
                  style: TextStyle(color: Color(0xFFAEB6D9)),
                )
              else
                ...provider.votingHistory.map((vote) {
                  final traineeName =
                      vote['traineeName']?.toString() ??
                          'trainee tidak diketahui';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151B3D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF252B50),
                        child: Icon(
                          Icons.how_to_vote,
                          color: Color(0xFFB7AEFF),
                        ),
                      ),
                      title: Text(
                        traineeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(vote['votedAt']),
                        style: const TextStyle(
                          color: Color(0xFFAEB6D9),
                        ),
                      ),
                    ),
                  );
                }),

            const SizedBox(height: 24),

            const Text(
              'trainee favorit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            if (provider.favoriteTrainees.isEmpty)
              const Text(
                'belum ada trainee favorit. tekan ikon hati pada kartu trainee untuk menambahkannya.',
                style: TextStyle(
                  color: Color(0xFFAEB6D9),
                ),
              )
            else
              ...provider.favoriteTrainees.map((trainee) {
                final name =
                    trainee['name']?.toString() ?? 'trainee';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151B3D),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF80AB),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'hapus favorit',
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Color(0xFFFF80AB),
                      ),
                      onPressed: () async {
                        await provider.toggleFavorite(name);
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
