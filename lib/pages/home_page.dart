
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
    final provider = context.watch<TraineeProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final pages = [
      buildHomeContent(context, provider),
      const VotePage(),
      const TraineePage(),
      const ProfilePage(),
    ];

    return Scaffold(
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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  label: Text('home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.how_to_vote_outlined),
                  label: Text('vote'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  label: Text('trainee'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  label: Text('profil'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: provider.selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        onTap: provider.changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF151B3D),
        selectedItemColor: const Color(0xFF8B7FFF),
        unselectedItemColor: const Color(0xFFAEB6D9),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_outlined),
            label: 'vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'trainee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'profil',
          ),
        ],
      ),
    );
  }

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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
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

                    TextField(
                      onChanged: provider.updateSearch,
                      style: const TextStyle(color: Colors.white),
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
                    ),

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
                          onPressed: () => provider.changePage(2),
                          child: const Text('lihat semua'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (provider.filteredTrainees.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('trainee tidak ditemukan.'),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 900
                              ? 4
                              : width >= 600
                              ? 3
                              : 2;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemCount: provider.filteredTrainees.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
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

                    ...provider.trainees.take(3).map(
                          (trainee) => PopularTrainee(
                        name: trainee['name'].toString(),
                      ),
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
          tooltip: 'buka detail trainee',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TraineeDetailPage(
                  traineeName: 'Jiyoon',
                ),
              ),
            );
          },
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}
