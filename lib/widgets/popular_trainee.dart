import 'package:flutter/material.dart';
import '../pages/trainee_detail_page.dart';

class PopularTrainee extends StatelessWidget {
  final String name;

  const PopularTrainee({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // membuat item trainee populer.
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
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
          // membuka detail trainee.
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
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor:
              Color(0xFF252B50),
              child: Icon(
                Icons.person,
                color: Color(0xFFAEB6D9),
              ),
            ),

            const SizedBox(width: 12),

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