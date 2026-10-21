
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  void initState() {
    super.initState();

    // Memuat kuota dan riwayat saat halaman voting dibuka.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TraineeProvider>().loadUserData();
      }
    });
  }

  // Mengirim vote trainee yang sudah dipilih.
  Future<void> _sendVote() async {
    final provider = context.read<TraineeProvider>();

    final success = await provider.submitVote();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'vote berhasil disimpan.'
              : provider.lastVoteError ?? 'vote gagal disimpan.',
        ),
        backgroundColor: success
            ? const Color(0xFF252B50)
            : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // Mengatur pilihan radio menggunakan RadioGroup.
    return RadioGroup<int>(
      groupValue: provider.selectedVoteIndex == -1
          ? null
          : provider.selectedVoteIndex,
      onChanged: (value) {
        if (provider.hasReachedVoteLimit ||
            provider.isSubmittingVote) {
          return;
        }

        if (value != null) {
          provider.selectVote(value);
        }
      },

      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 32 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'vote trainee',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'pilih trainee yang ingin kamu dukung.',
                    style: TextStyle(
                      color: Color(0xFFAEB6D9),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Menampilkan sisa kuota vote pengguna.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151B3D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sisa vote kamu: ${provider.remainingVotes} '
                          'dari ${TraineeProvider.maxVotes}',
                      style: const TextStyle(
                        color: Color(0xFFB7AEFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Menampilkan daftar trainee yang dapat dipilih.
                  Expanded(
                    child: provider.isLoadingUserData
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8B7FFF),
                      ),
                    )
                        : ListView.separated(
                      itemCount: provider.trainees.length,
                      separatorBuilder: (_, _) =>
                      const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final trainee =
                        provider.trainees[index];

                        final name =
                        trainee['name'].toString();

                        final image =
                        trainee['image'].toString();

                        final isSelected =
                            provider.selectedVoteIndex == index;

                        return Card(
                          margin: EdgeInsets.zero,
                          color: isSelected
                              ? const Color(0xFF302A60)
                              : const Color(0xFF151B3D),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF8B7FFF)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: RadioListTile<int>(
                            value: index,
                            activeColor:
                            const Color(0xFF8B7FFF),
                            secondary: CircleAvatar(
                              backgroundColor:
                              const Color(0xFF252B50),
                              backgroundImage: image.isNotEmpty
                                  ? AssetImage(image)
                                  : null,
                              child: image.isEmpty
                                  ? const Icon(
                                Icons.person,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol mengirim vote ke Provider.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                      provider.selectedVoteIndex == -1 ||
                          provider.hasReachedVoteLimit ||
                          provider.isSubmittingVote
                          ? null
                          : _sendVote,
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
                      child: provider.isSubmittingVote
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        provider.hasReachedVoteLimit
                            ? 'kuota vote habis'
                            : 'kirim vote',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
