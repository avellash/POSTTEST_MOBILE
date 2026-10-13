
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil pilihan voting dari Provider.
    final provider = context.watch<TraineeProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'vote trainee',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
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

            Expanded(
              child: ListView.builder(
                itemCount: provider.voteTrainees.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF151B3D),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: provider.selectedVoteIndex,

                      // Menyimpan pilihan ke Provider.
                      onChanged: (value) {
                        if (value != null) {
                          provider.selectVote(value);
                        }
                      },

                      title: Text(provider.voteTrainees[index]),

                      secondary: const CircleAvatar(
                        backgroundColor: Color(0xFF252B50),
                        child: Icon(Icons.person),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.selectedVoteIndex == -1
                    ? null
                    : () {
                  final trainee = provider.voteTrainees[
                  provider.selectedVoteIndex];

                  // Menampilkan konfirmasi pilihan voting.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'vote untuk $trainee berhasil.',
                      ),
                    ),
                  );
                },
                child: const Text('kirim vote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
