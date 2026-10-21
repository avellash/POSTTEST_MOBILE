
import 'dart:async';

import 'package:flutter/material.dart';

class VotingCard extends StatefulWidget {
  const VotingCard({super.key});

  @override
  State<VotingCard> createState() => _VotingCardState();
}

class _VotingCardState extends State<VotingCard> {
  // Batas waktu voting adalah 1 hari 12 jam.
  late final DateTime endTime;

  // Menyimpan sisa waktu countdown.
  Duration remainingTime = Duration.zero;

  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    // Memulai countdown selama 36 jam dari sekarang.
    endTime = DateTime.now().add(
      const Duration(hours: 36),
    );

    // Menghitung sisa waktu pertama kali.
    updateCountdown();

    // Memperbarui countdown setiap detik.
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => updateCountdown(),
    );
  }

  // Menghitung sisa waktu menuju akhir voting.
  void updateCountdown() {
    final difference = endTime.difference(DateTime.now());

    if (!mounted) return;

    setState(() {
      remainingTime = difference.isNegative
          ? Duration.zero
          : difference;
    });

    // Menghentikan timer ketika voting berakhir.
    if (difference <= Duration.zero) {
      countdownTimer?.cancel();
    }
  }

  // Mengubah angka menjadi dua digit.
  String twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    // Membersihkan timer ketika widget tidak digunakan.
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = remainingTime.inDays;
    final hours = remainingTime.inHours % 24;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    final isFinished = remainingTime == Duration.zero;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151B3D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B7FFF),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: Color(0xFFE88BFF),
            size: 30,
          ),

          const SizedBox(height: 10),

          const Text(
            'WAKTU VOTING',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFAEB6D9),
            ),
          ),

          const SizedBox(height: 12),

          // Menampilkan countdown secara langsung.
          if (!isFinished)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${twoDigits(days)} : '
                    '${twoDigits(hours)} : '
                    '${twoDigits(minutes)} : '
                    '${twoDigits(seconds)}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          else
            const Text(
              'VOTING BERAKHIR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE88BFF),
              ),
            ),

          const SizedBox(height: 8),

          if (!isFinished)
            const Text(
              'HARI : JAM : MENIT : DETIK',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFAEB6D9),
              ),
            ),

          const SizedBox(height: 8),

          Text(
            isFinished
                ? 'periode voting telah selesai.'
                : 'voting berakhir pada '
                '${twoDigits(endTime.day)}/'
                '${twoDigits(endTime.month)}/'
                '${endTime.year}, '
                '${twoDigits(endTime.hour)}:'
                '${twoDigits(endTime.minute)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFAEB6D9),
            ),
          ),
        ],
      ),
    );
  }
}
