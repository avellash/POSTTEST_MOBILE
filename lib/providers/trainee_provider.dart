
import 'package:flutter/material.dart';

class TraineeProvider extends ChangeNotifier {
  // Menyimpan indeks halaman yang sedang aktif.
  int selectedIndex = 0;

  // Menyimpan kata pencarian trainee.
  String searchText = '';

  // Menyimpan indeks trainee yang dipilih untuk voting.
  int selectedVoteIndex = -1;

  // Daftar trainee untuk halaman Home.
  final List<Map<String, dynamic>> trainees = [
    {'name': 'jiyoon', 'icon': Icons.person},
    {'name': 'jeemin', 'icon': Icons.person},
    {'name': 'koko', 'icon': Icons.person},
    {'name': 'sarang', 'icon': Icons.person},
    {'name': 'gyuri', 'icon': Icons.person},
    {'name': 'fuko', 'icon': Icons.person},
  ];

  // Daftar trainee yang tersedia untuk voting.
  final List<String> voteTrainees = [
    'jiyoon',
    'jeemin',
    'koko',
    'sarang',
  ];

  // Mengubah halaman aktif dan memperbarui widget.
  void changePage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Memperbarui kata pencarian.
  void updateSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  // Menampilkan trainee yang sesuai dengan pencarian.
  List<Map<String, dynamic>> get filteredTrainees {
    return trainees.where((trainee) {
      return trainee['name']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  // Menyimpan pilihan voting dan memperbarui widget.
  void selectVote(int index) {
    selectedVoteIndex = index;
    notifyListeners();
  }

  // Mengatur ulang pilihan voting.
  void resetVote() {
    selectedVoteIndex = -1;
    notifyListeners();
  }

  // Memperbarui tampilan setelah proses refresh.
  Future<void> refreshHome() async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
