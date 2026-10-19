
import 'package:flutter/material.dart';

class TraineeProvider extends ChangeNotifier {
  // Mengatur halaman yang sedang dipilih pada navigasi bawah.
  int selectedIndex = 0;

  // Menyimpan indeks trainee yang dipilih untuk voting.
  int selectedVoteIndex = -1;

  // Menyimpan kata pencarian trainee.
  String searchQuery = '';

  // Menyimpan data trainee, foto, deskripsi, ikon, dan jumlah suara.
  final List<Map<String, dynamic>> trainees = [
    {
      'name': 'Fuko',
      'image': 'assets/images/fuko_2.jpg',
      'description':
      'Fuko adalah trainee asal Jepang yang dikenal memiliki kemampuan vokal yang kuat dan stabil.\n\n'
          'Selama mengikuti kompetisi I-LAND2: N/a, Fuko menunjukkan kerja keras dan kedisiplinan.\n\n'
          'Fuko terus mengembangkan kemampuannya selama kompetisi.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Gyuri',
      'image': 'assets/images/gyuri_2.jpg',
      'description': 'Gyuri memiliki pesona ceria dan potensi sebagai seorang performer.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jeemin',
      'image': 'assets/images/jeemin_1.jpg',
      'description': 'Jeemin memiliki penampilan yang percaya diri dan kemampuan menari yang memikat.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jiyoon',
      'image': 'assets/images/jiyoon_1.jpg',
      'description': 'Jiyoon memiliki karakter vokal yang menarik dan ekspresi panggung yang kuat.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jungeun',
      'image': 'assets/images/jungeun_2.jpg',
      'description': 'Jungeun memiliki kemampuan menyanyi dan menari yang menarik untuk dikembangkan.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Koko',
      'image': 'assets/images/koko_2.jpg',
      'description': 'Koko memiliki gaya menari yang energik dan penampilan panggung yang menonjol.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Mai',
      'image': 'assets/images/mai_2.jpg',
      'description': 'Mai memiliki pesona tersendiri dan penampilan yang menarik perhatian.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Saebi',
      'image': 'assets/images/saebi_2.jpg',
      'description': 'Saebi memiliki aura panggung yang cerah dan potensi untuk terus berkembang.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Sarang',
      'image': 'assets/images/sarang_2.jpg',
      'description': 'Sarang memiliki penampilan ekspresif dan karakter yang menarik.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Yuju',
      'image': 'assets/images/yuju_2.jpg',
      'description': 'Yuju memiliki karakter penampilan yang kuat dan pesona yang khas.',
      'icon': Icons.person,
      'votes': 0,
    },
  ];

  // Mengambil daftar nama trainee untuk halaman voting.
  List<String> get voteTrainees {
    return trainees.map((trainee) => trainee['name'] as String).toList();
  }

  // Menyaring trainee berdasarkan kata pencarian.
  List<Map<String, dynamic>> get filteredTrainees {
    if (searchQuery.trim().isEmpty) {
      return trainees;
    }

    return trainees.where((trainee) {
      final name = trainee['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase().trim());
    }).toList();
  }

  // Mengubah halaman aktif pada navigasi bawah.
  void changePage(int index) {
    if (index >= 0 && index < 4) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  // Memperbarui kata pencarian pada homepage.
  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  // Memperbarui tampilan homepage ketika ditarik ke bawah.
  Future<void> refreshHome() async {
    notifyListeners();
  }

  // Menyimpan pilihan trainee untuk voting.
  void selectVote(int index) {
    if (index >= 0 && index < voteTrainees.length) {
      selectedVoteIndex = index;
      notifyListeners();
    }
  }

  // Menambahkan satu suara kepada trainee berdasarkan nama.
  void voteForTrainee(String traineeName) {
    final index = trainees.indexWhere(
          (trainee) => trainee['name'] == traineeName,
    );

    if (index != -1) {
      trainees[index]['votes'] =
          (trainees[index]['votes'] as int) + 1;
      notifyListeners();
    }
  }

  // Mengirim pilihan voting dan menambahkan jumlah suara.
  bool submitVote() {
    if (selectedVoteIndex < 0 ||
        selectedVoteIndex >= voteTrainees.length) {
      return false;
    }

    final traineeName = voteTrainees[selectedVoteIndex];
    voteForTrainee(traineeName);

    // Menghapus pilihan setelah voting berhasil.
    selectedVoteIndex = -1;
    notifyListeners();

    return true;
  }
}
