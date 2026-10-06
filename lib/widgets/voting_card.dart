import 'package:flutter/material.dart';

class VotingCard extends StatelessWidget {
  const VotingCard({super.key});

  @override
  Widget build(BuildContext context) {
    // membuat kartu waktu voting.
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

          const SizedBox(height: 5),

          const Text(
            '02 : 15 : 30',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'voting berakhir hari ini, 23:59',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFAEB6D9),
            ),
          ),
        ],
      ),
    );
  }
}