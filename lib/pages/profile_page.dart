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
  final TextEditingController _usernameController =
  TextEditingController();

  String _profilePicture = 'pp_1';
  bool _isSavingProfile = false;

  @override
  void initState() {
    super.initState();

    // Memuat data akun, riwayat voting, dan favorit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TraineeProvider>().loadUserData();
      }
    });

    // Memuat username dan foto profil dari Firestore.
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // Mengambil data profil sesuai UID pengguna yang login.
  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      final data = doc.data();

      setState(() {
        _usernameController.text =
            data?['username']?.toString() ?? 'pengguna';

        final savedPicture =
            data?['profilePicture']?.toString() ?? 'pp_1';

        // Mendukung nilai pp_1 maupun pp_1.jpg.
        _profilePicture = savedPicture.replaceAll('.jpg', '');

        if (!_isValidProfilePicture(_profilePicture)) {
          _profilePicture = 'pp_1';
        }
      });
    } catch (e) {
      debugPrint('Gagal memuat profil: $e');
    }
  }

  bool _isValidProfilePicture(String value) {
    return RegExp(r'^pp_(10|[1-9])$').hasMatch(value);
  }

  // Menampilkan pilihan 10 foto profil dalam bentuk grid.
  Future<void> _chooseProfilePicture() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B3D),
          title: const Text(
            'pilih foto profil',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 10,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final picture = 'pp_${index + 1}';
                final isSelected = _profilePicture == picture;

                return InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.pop(dialogContext, picture);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB7AEFF)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF252B50),
                      backgroundImage: AssetImage(
                        'assets/images/profiles/$picture.jpg',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('batal'),
            ),
          ],
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _profilePicture = selected;
      });
    }
  }

  // Menyimpan username dan foto profil ke Firestore.
  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('username tidak boleh kosong.'),
        ),
      );
      return;
    }

    if (username.length > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('username maksimal 30 karakter.'),
        ),
      );
      return;
    }

    setState(() {
      _isSavingProfile = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': user.email ?? '',
        'username': username,
        'profilePicture': _profilePicture,
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('profil berhasil disimpan.'),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('gagal menyimpan profil: ${e.message ?? e.code}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('terjadi kesalahan saat menyimpan profil.'),
        ),
      );
      debugPrint('Gagal menyimpan profil: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
      }
    }
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
        onRefresh: () async {
          await provider.loadUserData();
          await _loadProfile();
        },
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

            // Kartu profil pengguna.
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151B3D),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  // Foto profil dengan ikon edit kecil.
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: const Color(0xFF252B50),
                        backgroundImage: AssetImage(
                          'assets/images/profiles/$_profilePicture.jpg',
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: const Color(0xFF8B7FFF),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: user == null
                                ? null
                                : _chooseProfilePicture,
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Username berbeda dari email.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'username',
                      style: TextStyle(
                        color: Color(0xFFAEB6D9),
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: _usernameController,
                    enabled: user != null && !_isSavingProfile,
                    maxLength: 30,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'masukkan username',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAEB6D9),
                      ),
                      counterStyle: const TextStyle(
                        color: Color(0xFFAEB6D9),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF252B50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFFB7AEFF),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Email ditampilkan terpisah dan tidak ikut diedit.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'email',
                      style: TextStyle(
                        color: Color(0xFFAEB6D9),
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252B50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: Color(0xFFB7AEFF),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user?.email ?? 'belum login',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol menyimpan username dan foto profil.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: user == null || _isSavingProfile
                          ? null
                          : _saveProfile,
                      icon: _isSavingProfile
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isSavingProfile ? 'menyimpan...' : 'simpan profil',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B7FFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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

            // Riwayat voting pengguna.
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

            // Daftar trainee favorit pengguna.
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
                style: TextStyle(color: Color(0xFFAEB6D9)),
              )
            else
              ...provider.favoriteTrainees.map((trainee) {
                final name = trainee['name']?.toString() ?? 'trainee';

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
                      style: const TextStyle(color: Colors.white),
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