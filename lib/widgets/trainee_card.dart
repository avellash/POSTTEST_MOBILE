import 'package:flutter/material.dart';
import '../pages/trainee_detail_page.dart';

class TraineeCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const TraineeCard({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // membuat kartu trainee.
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.9,
        end: 1,
      ),
      duration: const Duration(
        milliseconds: 400,
      ),
      builder: (context, scale, child) {
        // membuat animasi kartu.
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF151B3D),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF252B50),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: const Color(0xFFAEB6D9),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // membuka halaman detail.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TraineeDetailPage(
                            traineeName: name,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF8B7FFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
                child: const Text('vote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}