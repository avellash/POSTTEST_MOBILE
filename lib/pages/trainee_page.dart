
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';
import 'trainee_detail_page.dart';

class TraineePage extends StatelessWidget {
  const TraineePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil daftar trainee dari Provider.
    final provider = context.watch<TraineeProvider>();
    final trainees = provider.trainees;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'daftar trainee',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.separated(
                itemCount: trainees.length,

                // Memberikan jarak antar item.
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },

                itemBuilder: (context, index) {
                  final trainee = trainees[index];
                  final name = trainee['name'].toString();

                  return ListTile(
                    tileColor: const Color(0xFF151B3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF252B50),
                      child: Icon(Icons.person),
                    ),

                    title: Text(name),
                    trailing: const Icon(Icons.chevron_right),

                    onTap: () {
                      // Membuka detail trainee yang dipilih.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TraineeDetailPage(traineeName: name),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
