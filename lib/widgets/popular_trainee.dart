
import 'package:flutter/material.dart';
import '../pages/trainee_detail_page.dart';
import '../providers/trainee_provider.dart';
import 'package:provider/provider.dart';

class PopularTrainee extends StatelessWidget {
  final String name;

  const PopularTrainee({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // mengambil data trainee dari provider.
    final provider = context.watch<TraineeProvider>();

    // mencari data trainee berdasarkan nama.
    final trainee = provider.trainees.firstWhere(
          (item) => item['name'].toString() == name,
      orElse: () => <String, dynamic>{},
    );

    // mengambil lokasi foto trainee.
    final image = trainee['image']?.toString() ?? '';

    // membuat item trainee populer.
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151B3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // membuka halaman detail trainee.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TraineeDetailPage(
                traineeName: name,
              ),
            ),
          );
        },
        child: Row(
          children: [
            // menampilkan foto trainee berbentuk lingkaran.
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF252B50),
              backgroundImage: image.isNotEmpty
                  ? AssetImage(image)
                  : null,
              child: image.isEmpty
                  ? const Icon(
                Icons.person,
                color: Color(0xFFAEB6D9),
              )
                  : null,
            ),

            const SizedBox(width: 12),

            // menampilkan nama trainee.
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFFAEB6D9),
            ),
          ],
        ),
      ),
    );
  }
}
