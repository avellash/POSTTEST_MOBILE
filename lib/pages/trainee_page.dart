
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';
import 'trainee_detail_page.dart';

class TraineePage extends StatelessWidget {
  const TraineePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengamati perubahan data trainee dari Provider.
    final provider = context.watch<TraineeProvider>();
    final trainees = provider.trainees;

    return SafeArea(
      child: Center(
        // Membatasi lebar konten agar nyaman dilihat di desktop.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width >= 900 ? 32 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan judul halaman.
                Text(
                  'daftar trainee',
                  style: TextStyle(
                    fontSize:
                    MediaQuery.of(context).size.width >= 900 ? 32 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // Menampilkan jumlah trainee.
                Text(
                  '${trainees.length} trainee tersedia',
                  style: const TextStyle(
                    color: Color(0xFFAEB6D9),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                // Menampilkan daftar trainee yang responsif.
                Expanded(
                  child: trainees.isEmpty
                      ? const Center(
                    child: Text('belum ada data trainee.'),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      // Menentukan jumlah kolom sesuai lebar konten.
                      final width = constraints.maxWidth;
                      final columns = width >= 1000
                          ? 4
                          : width >= 650
                          ? 3
                          : width >= 380
                          ? 2
                          : 1;

                      return GridView.builder(
                        itemCount: trainees.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: columns == 1 ? 3.0 : 0.78,
                        ),
                        itemBuilder: (context, index) {
                          // Mengambil data setiap trainee.
                          final trainee = trainees[index];
                          final name = trainee['name'].toString();
                          final image = trainee['image'].toString();
                          final votes = trainee['votes'] ?? 0;

                          // Membuat kartu trainee.
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // Membuka halaman detail trainee.
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF151B3D),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF252B50),
                                ),
                              ),
                              child: columns == 1
                              // Tampilan horizontal untuk layar sempit.
                                  ? Row(
                                children: [
                                  // Menampilkan foto trainee.
                                  ClipRRect(
                                    borderRadius:
                                    const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft:
                                      Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      image,
                                      width: 100,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                          ) {
                                        return Container(
                                          width: 100,
                                          color: const Color(
                                            0xFF252B50,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Menampilkan nama dan jumlah vote.
                                  Expanded(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            name,
                                            maxLines: 2,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'suara: $votes',
                                            style: const TextStyle(
                                              color: Color(
                                                0xFFAEB6D9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFAEB6D9),
                                    ),
                                  ),
                                ],
                              )
                              // Tampilan vertikal untuk layar lebar.
                                  : Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  // Foto mengisi bagian atas kartu.
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.only(
                                        topLeft:
                                        Radius.circular(16),
                                        topRight:
                                        Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                            ) {
                                          return Container(
                                            color: const Color(
                                              0xFF252B50,
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Color(
                                                0xFFAEB6D9,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  // Informasi trainee.
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.favorite,
                                              size: 16,
                                              color: Color(
                                                0xFFFF80AB,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'suara: $votes',
                                                style:
                                                const TextStyle(
                                                  color: Color(
                                                    0xFFAEB6D9,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Color(
                                                0xFFAEB6D9,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
