
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/trainee_detail_page.dart';
import '../providers/trainee_provider.dart';

class PopularTrainee extends StatelessWidget {
  final String name;

  const PopularTrainee({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TraineeProvider>();

    final trainee = provider.trainees.firstWhere(
          (item) =>
      item['name'].toString().toLowerCase() ==
          name.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );

    final image = trainee['image']?.toString() ?? '';
    final displayName = trainee['name']?.toString() ?? name;

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TraineeDetailPage(
                traineeName: displayName,
              ),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF252B50),
              backgroundImage:
              image.isNotEmpty ? AssetImage(image) : null,
              child: image.isEmpty
                  ? const Icon(
                Icons.person,
                color: Color(0xFFAEB6D9),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
