
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainee_provider.dart';
import '../widgets/trainee_card.dart';
import '../widgets/popular_trainee.dart';
import 'vote_page.dart';
import 'trainee_page.dart';
import 'profile_page.dart';
import 'trainee_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color backgroundColor = Color(0xFF0B102B);
  static const Color cardColor = Color(0xFF151B3D);
  static const Color accentColor = Color(0xFF8B7FFF);
  static const Color secondaryColor = Color(0xFFAEB6D9);

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
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              backgroundColor: cardColor,
              selectedIndex: provider.selectedIndex,
              onDestinationSelected: provider.changePage,
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(
                color: accentColor,
              ),
              unselectedIconTheme: const IconThemeData(
                color: secondaryColor,
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
        backgroundColor: cardColor,
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryColor,
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
                        color: secondaryColor,
                      ),
                    ),

                    const SizedBox(height: 22),

                    TextField(
                      onChanged: provider.updateSearch,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'cari trainee...',
                        hintStyle: const TextStyle(
                          color: secondaryColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: secondaryColor,
                        ),
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Menggantikan countdown dengan peringkat trainee.
                    buildRankingSection(context, provider),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                            itemCount:
                            provider.filteredTrainees.length,
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

  // Menampilkan tiga trainee dengan vote terbanyak.
  Widget buildRankingSection(
      BuildContext context,
      TraineeProvider provider,
      ) {
    final rankings = provider.rankedTrainees.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: accentColor,
                size: 26,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Peringkat Trainee',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.circle,
                size: 8,
                color: Colors.greenAccent,
              ),
              SizedBox(width: 5),
              Text(
                'Live',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'peringkat berubah mengikuti total vote.',
            style: TextStyle(
              fontSize: 12,
              color: secondaryColor,
            ),
          ),

          const SizedBox(height: 18),

          if (rankings.isEmpty)
            const Text(
              'belum ada data peringkat.',
              style: TextStyle(color: secondaryColor),
            )
          else
            ...rankings.asMap().entries.map((entry) {
              final index = entry.key;
              final trainee = entry.value;

              return buildRankingRow(
                context,
                trainee,
                index + 1,
              );
            }),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: cardColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => const AllRankingsSheet(),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: const BorderSide(color: accentColor),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text('Lihat Semua Peringkat'),
            ),
          ),
        ],
      ),
    );
  }

  // Baris peringkat yang dapat dibuka untuk melihat detail trainee.
  Widget buildRankingRow(
      BuildContext context,
      Map<String, dynamic> trainee,
      int rank,
      ) {
    final name = trainee['name'].toString();
    final image = trainee['image'].toString();
    final votes = (trainee['votes'] as num?)?.toInt() ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TraineeDetailPage(
              traineeName: name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: rank == 1
                      ? const Color(0xFFFFD76A)
                      : rank == 2
                      ? const Color(0xFFD4D8E5)
                      : rank == 3
                      ? const Color(0xFFDAA078)
                      : secondaryColor,
                ),
              ),
            ),

            const SizedBox(width: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFF252D55),
                  child: const Icon(
                    Icons.person,
                    color: secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$votes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'vote',
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ],
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

// Bottom sheet untuk melihat peringkat seluruh trainee.

class AllRankingsSheet extends StatelessWidget {
  const AllRankingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget ini dibangun ulang ketika TraineeProvider berubah.
    return Consumer<TraineeProvider>(
      builder: (context, provider, child) {
        // Ambil data peringkat terbaru setiap kali ada perubahan.
        final rankings = provider.rankedTrainees;

        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAEB6D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Color(0xFF8B7FFF),
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Peringkat Semua Trainee',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'diurutkan berdasarkan total vote terbanyak.',
                      style: TextStyle(
                        color: Color(0xFFAEB6D9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      final trainee = rankings[index];
                      final votes =
                          (trainee['votes'] as num?)?.toInt() ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TraineeDetailPage(
                                  traineeName:
                                  trainee['name'].toString(),
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF252D55),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            trainee['name'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '$votes vote',
                            style: const TextStyle(
                              color: Color(0xFFAEB6D9),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF8B7FFF),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

