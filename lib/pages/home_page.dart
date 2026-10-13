
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
    // Mengambil state terbaru dari Provider.
    final provider = context.watch<TraineeProvider>();

    // Menyiapkan halaman untuk navigasi bawah.
    final pages = [
      buildHomeContent(context, provider),
      const VotePage(),
      const TraineePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Mempertahankan halaman agar state widget tidak mudah hilang.
      body: IndexedStack(
        index: provider.selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: buildBottomNavigation(context, provider),
    );
  }

  Widget buildHomeContent(
      BuildContext context,
      TraineeProvider provider,
      ) {
    return SafeArea(
      child: RefreshIndicator(
        // Memanggil fungsi refresh dari Provider.
        onRefresh: provider.refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),

              const SizedBox(height: 28),

              const Text(
                'Vote Your\nFavorite Trainee!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.white,
                ),
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

              buildSearch(provider),

              const SizedBox(height: 28),

              const VotingCard(),

              const SizedBox(height: 30),

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
                      // Membuka halaman daftar trainee.
                      provider.changePage(2);
                    },
                    child: const Text('lihat semua'),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Menampilkan hasil pencarian dari Provider.
              if (provider.filteredTrainees.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('Trainee tidak ditemukan.'),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.filteredTrainees.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final trainee = provider.filteredTrainees[index];

                    return TraineeCard(
                      name: trainee['name'].toString(),
                      icon: trainee['icon'] as IconData,
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

              // Menggunakan daftar trainee dari Provider.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.trainees.length < 3
                    ? provider.trainees.length
                    : 3,
                itemBuilder: (context, index) {
                  return PopularTrainee(
                    name: provider.trainees[index]['name'].toString(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget buildSearch(TraineeProvider provider) {
    return TextField(
      // Mengirim kata pencarian ke Provider.
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

  Widget buildBottomNavigation(
      BuildContext context,
      TraineeProvider provider,
      ) {
    return BottomNavigationBar(
      currentIndex: provider.selectedIndex,

      // Mengganti halaman melalui Provider.
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
