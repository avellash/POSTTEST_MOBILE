import 'package:flutter/material.dart';

import 'trainee_detail_page.dart';

class TraineePage extends StatelessWidget {
  const TraineePage({super.key});

  @override
  Widget build(BuildContext context) {
    // membangun halaman daftar trainee.
    final trainees = [
      'jiyoon',
      'jeemin',
      'koko',
      'sarang',
      'gyuri',
      'fuko',
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
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

                separatorBuilder:
                    (context, index) {
                  // memberi jarak antar item.
                  return const SizedBox(
                    height: 10,
                  );
                },

                itemBuilder:
                    (context, index) {
                  // membuat item trainee.
                  return ListTile(
                    tileColor:
                    const Color(0xFF151B3D),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                    ),

                    leading:
                    const CircleAvatar(
                      backgroundColor:
                      Color(0xFF252B50),
                      child: Icon(
                        Icons.person,
                      ),
                    ),

                    title: Text(
                      trainees[index],
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),

                    onTap: () {
                      // membuka detail trainee.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TraineeDetailPage(
                                traineeName:
                                trainees[index],
                              ),
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