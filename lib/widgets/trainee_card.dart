
import 'package:flutter/material.dart';
import '../pages/trainee_detail_page.dart';

class TraineeCard extends StatelessWidget {
  final String name;
  final String image;
  final IconData icon;

  const TraineeCard({
    super.key,
    required this.name,
    required this.image,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat kartu trainee dengan animasi.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, scale, child) {
        // Memberikan efek animasi pada kartu.
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan foto trainee dari assets.
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF252B50),
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  // Menampilkan ikon jika foto gagal dimuat.
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        icon,
                        size: 60,
                        color: const Color(0xFFAEB6D9),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Menampilkan nama trainee.
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Membuka halaman detail trainee.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TraineeDetailPage(
                        traineeName: name,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7FFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
