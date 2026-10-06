import 'package:flutter/material.dart';

class TraineeDetailPage extends StatefulWidget {
  final String traineeName;

  const TraineeDetailPage({
    super.key,
    required this.traineeName,
  });

  @override
  State<TraineeDetailPage> createState() =>
      _TraineeDetailPageState();
}

class _TraineeDetailPageState
    extends State<TraineeDetailPage> {
  bool isFavorite = false;
  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    // membangun halaman detail trainee.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'detail trainee',
        ),

        actions: [
          IconButton(
            onPressed: () {
              // mengubah status favorit.
              setState(() {
                isFavorite = !isFavorite;
              });
            },

            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavorite
                  ? Colors.pink
                  : Colors.white,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Hero(
              tag:
              'trainee-${widget.traineeName}',
              child: const CircleAvatar(
                radius: 70,
                backgroundColor:
                Color(0xFF252B50),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Color(0xFFAEB6D9),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.traineeName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'trainee pilihan dalam aplikasi voting.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFAEB6D9),
              ),
            ),

            const SizedBox(height: 30),

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: hasVoted
                    ? const Color(0xFF252B50)
                    : const Color(0xFF151B3D),
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: Text(
                hasVoted
                    ? 'kamu sudah melakukan vote.'
                    : 'belum melakukan vote.',
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasVoted
                    ? null
                    : voteTrainee,
                child: const Text(
                  'vote sekarang',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void voteTrainee() {
    // mengubah status menjadi sudah vote.
    setState(() {
      hasVoted = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'vote untuk ${widget.traineeName} berhasil.',
        ),
      ),
    );
  }
}