import 'package:flutter/material.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  int selectedTrainee = -1;

  final List<String> trainees = [
    'jiyoon',
    'jeemin',
    'koko',
    'sarang',
  ];

  @override
  Widget build(BuildContext context) {
    // membangun halaman voting.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
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
                itemCount: trainees.length,
                itemBuilder: (context, index) {
                  // membuat pilihan trainee.
                  return Card(
                    color: const Color(0xFF151B3D),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selectedTrainee,

                      onChanged: (value) {
                        // menyimpan pilihan trainee.
                        setState(() {
                          selectedTrainee =
                              value ?? -1;
                        });
                      },

                      title: Text(
                        trainees[index],
                      ),

                      secondary:
                      const CircleAvatar(
                        backgroundColor:
                        Color(0xFF252B50),
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTrainee == -1
                    ? null
                    : submitVote,
                child: const Text(
                  'kirim vote',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitVote() {
    // menampilkan hasil vote.
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'vote untuk ${trainees[selectedTrainee]} berhasil.',
        ),
      ),
    );
  }
}