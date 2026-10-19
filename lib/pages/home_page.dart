
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';
import '../widgets/trainee_card.dart';
import '../widgets/popular_trainee.dart';
import '../widgets/voting_card.dart';
import 'vote_page.dart';
import 'trainee_page.dart';
import 'profile_page.dart';
import 'trainee_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dan status navigasi dari Provider.
    final provider = context.watch<TraineeProvider>();

    // Memeriksa apakah aplikasi berjalan pada layar desktop.
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    // Menyiapkan halaman yang akan ditampilkan.
    final pages = [
      buildHomeContent(context, provider),
      const VotePage(),
      const TraineePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Menampilkan navigasi samping pada desktop.
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              backgroundColor: const Color(0xFF151B3D),
              selectedIndex: provider.selectedIndex,
              onDestinationSelected: provider.changePage,
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(
                color: Color(0xFF8B7FFF),
              ),
              unselectedIconTheme: const IconThemeData(
                color: Color(0xFFAEB6D9),
              ),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF8B7FFF),
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: Color(0xFFAEB6D9),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.how_to_vote_outlined),
                  selectedIcon: Icon(Icons.how_to_vote),
                  label: Text('vote'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('trainee'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('profil'),
                ),
              ],
            ),

          // Menggunakan seluruh ruang layar yang tersisa.
          Expanded(
            child: IndexedStack(
              index: provider.selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),

      // Menggunakan navigasi bawah pada layar mobile dan tablet kecil.
      bottomNavigationBar: isDesktop
          ? null
          : buildBottomNavigation(context, provider),
    );
  }

  // Membuat konten home yang dapat menyesuaikan lebar layar.
  Widget buildHomeContent(
      BuildContext context,
      TraineeProvider provider,
      ) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: provider.refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            // Membatasi lebar konten agar tetap nyaman dibaca di desktop.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(context),

                    const SizedBox(height: 28),

                    // Menyesuaikan ukuran judul dengan lebar layar.
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 600;

                        return Text(
                          'Vote Your\nFavorite Trainee!',
                          style: TextStyle(
                            fontSize: isWide ? 38 : 30,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'dukung trainee favoritmu untuk melangkah lebih jauh.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAEB6D9),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Menampilkan kolom pencarian trainee.
                    buildSearch(provider),

                    const SizedBox(height: 28),

                    const VotingCard(),

                    const SizedBox(height: 30),

                    // Menampilkan judul dan tombol menuju daftar trainee.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Trainee',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.changePage(2);
                          },
                          child: const Text('lihat semua'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Menampilkan kartu trainee dengan kolom responsif.
                    if (provider.filteredTrainees.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text('Trainee tidak ditemukan.'),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Menentukan jumlah kolom berdasarkan lebar.
                          final width = constraints.maxWidth;
                          final columns = width >= 1000
                              ? 4
                              : width >= 650
                              ? 3
                              : width >= 380
                              ? 2
                              : 1;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemCount:
                            provider.filteredTrainees.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                              width < 380 ? 1.0 : 0.78,
                            ),
                            itemBuilder: (context, index) {
                              final trainee =
                              provider.filteredTrainees[index];

                              return TraineeCard(
                                name: trainee['name'].toString(),
                                image: trainee['image'].toString(),
                                icon: trainee['icon'] as IconData,
                              );
                            },
                          );
                        },
                      ),

                    const SizedBox(height: 30),

                    const Text(
                      'Trainee Populer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Menampilkan maksimal tiga trainee populer.
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.trainees.length < 3
                          ? provider.trainees.length
                          : 3,
                      itemBuilder: (context, index) {
                        return PopularTrainee(
                          name: provider.trainees[index]['name']
                              .toString(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Membuat header dan tombol notifikasi.
  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'I-LAND 2',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            // Membuka detail trainee.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TraineeDetailPage(
                  traineeName: 'jiyoon',
                ),
              ),
            );
          },
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // Membuat pencarian dan mengirim teks ke Provider.
  Widget buildSearch(TraineeProvider provider) {
    return TextField(
      onChanged: provider.updateSearch,
      decoration: InputDecoration(
        hintText: 'cari trainee...',
        hintStyle: const TextStyle(
          color: Color(0xFFAEB6D9),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFFAEB6D9),
        ),
        filled: true,
        fillColor: const Color(0xFF151B3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Membuat navigasi bawah untuk mobile.
  Widget buildBottomNavigation(
      BuildContext context,
      TraineeProvider provider,
      ) {
    return BottomNavigationBar(
      currentIndex: provider.selectedIndex,
      onTap: provider.changePage,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF151B3D),
      selectedItemColor: const Color(0xFF8B7FFF),
      unselectedItemColor: const Color(0xFFAEB6D9),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.how_to_vote_outlined),
          activeIcon: Icon(Icons.how_to_vote),
          label: 'vote',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'trainee',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'profil',
        ),
      ],
    );
  }
}
