import 'package:flutter/material.dart';

import 'vote_page.dart';
import 'trainee_page.dart';
import 'profile_page.dart';
import 'trainee_detail_page.dart';
import '../widgets/trainee_card.dart';
import '../widgets/popular_trainee.dart';
import '../widgets/voting_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchText = '';

  final List<Map<String, dynamic>> trainees = [
    {
      'name': 'jiyoon',
      'icon': Icons.person,
    },
    {
      'name': 'jeemin',
      'icon': Icons.person,
    },
    {
      'name': 'koko',
      'icon': Icons.person,
    },
    {
      'name': 'sarang',
      'icon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // membangun halaman utama.
    final pages = [
      buildHomeContent(),
      const VotePage(),
      const TraineePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildHomeContent() {
    // membuat isi halaman home.
    final filteredTrainees = trainees
        .where(
          (trainee) => trainee['name']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase()),
    )
        .toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),

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

              buildSearch(),

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
                      // membuka halaman trainee.
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: const Text('lihat semua'),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTrainees.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  // membuat kartu trainee.
                  final trainee = filteredTrainees[index];

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

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  // membuat daftar trainee populer.
                  return PopularTrainee(
                    name: trainees[index]['name'].toString(),
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

  Widget buildHeader() {
    // membuat header halaman.
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
            // membuka halaman detail trainee.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TraineeDetailPage(
                  traineeName: 'jiyoon',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none,
          ),
        ),
      ],
    );
  }

  Widget buildSearch() {
    // membuat search bar.
    return TextField(
      onChanged: (value) {
        // memperbarui kata pencarian.
        setState(() {
          searchText = value;
        });
      },
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

  Widget buildBottomNavigation() {
    // membuat navigasi bawah.
    return BottomNavigationBar(
      currentIndex: selectedIndex,

      onTap: (index) {
        // mengganti halaman aktif.
        setState(() {
          selectedIndex = index;
        });
      },

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

  Future<void> refreshHome() async {
    // memperbarui data halaman.
    await Future.delayed(
      const Duration(seconds: 1),
    );

    setState(() {});
  }
}