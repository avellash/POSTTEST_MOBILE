
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraineeProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengatur halaman navigasi dan trainee yang dipilih.
  int selectedIndex = 0;
  int selectedVoteIndex = -1;

  // Mengatur pencarian trainee.
  String searchQuery = '';

  // Batas maksimal vote untuk setiap akun.
  static const int maxVotes = 5;

  // Status pemuatan dan pengiriman vote.
  bool isLoadingUserData = false;
  bool isSubmittingVote = false;

  // Informasi hasil voting.
  int voteCount = 0;
  String? lastVoteError;

  // Data riwayat dan favorit pengguna.
  List<Map<String, dynamic>> votingHistory = [];
  List<Map<String, dynamic>> _favoriteTrainees = [];

  // Daftar trainee tetap menggunakan aset project kamu.
  final List<Map<String, dynamic>> trainees = [
    {
      'name': 'Fuko',
      'image': 'assets/images/fuko_2.jpg',
      'description': 'Nama lengkap: Hayashi Fuko (林 楓子)\n\n'
          'Tanggal lahir: 22 Agustus 2004\n\n'
          'Zodiak: Leo ♌\n\n'
          'Deskripsi: Fuko adalah trainee asal Jepang yang dikenal memiliki kemampuan vokal yang kuat dan keterampilan menari yang baik. Ia pernah mengikuti Girls Planet 999 sebelum berpartisipasi dalam i-LAND 2. Fuko memiliki pengalaman sebagai trainee dan dikenal sebagai sosok yang multitalenta. Dengan kerja keras, semangat, dan kemampuannya, ia terus berusaha meraih impiannya untuk debut sebagai idol K-pop.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Gyuri',
      'image': 'assets/images/gyuri_2.jpg',
      'description': 'Nama lengkap: Kim Gyu-ri (김규리)\n\n'
      'Tanggal lahir: 15 September 2008\n\n'
        'Zodiak: Virgo ♍\n\n'
        'Deskripsi: Gyuri adalah trainee asal Korea Selatan yang juga dikenal sebagai aktris cilik dan model. Ia pernah membintangi beberapa drama Korea sebelum mengikuti i-LAND 2. Dengan kepribadian yang menarik serta pengalaman di dunia hiburan sejak usia muda, Gyuri menunjukkan potensi dan semangatnya untuk berkembang sebagai idol K-pop.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jeemin',
      'image': 'assets/images/jeemin_1.jpg',
      'description': 'Nama lengkap: Bang Jee-min (방지민)\n\n'
          'Tanggal lahir: 8 Mei 2005\n\n'
          'Zodiak: Taurus ♉\n\n'
          'Deskripsi: Jeemin adalah trainee asal Korea Selatan yang sebelumnya mengikuti program survival R U Next? sebelum berpartisipasi dalam i-LAND 2. Ia dikenal memiliki kemampuan menari dan vokal, serta pesona panggung yang kuat. Dengan pengalaman dan semangat pantang menyerah, Jeemin terus berusaha meraih impiannya hingga berhasil debut sebagai anggota girl group izna.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jiyoon',
      'image': 'assets/images/jiyoon_1.jpg',
      'description': 'Nama lengkap: Yoon Ji-yoon (윤지윤)\n\n'
          'Tanggal lahir: 14 Juli 2005\n\n'
          'Zodiak: Cancer ♋\n\n'
          'Deskripsi: Jiyoon adalah trainee asal Korea Selatan yang dikenal dengan suara vokalnya yang unik dan kuat. Sebelum mengikuti i-LAND 2, ia pernah menjalani masa trainee di THEBLACKLABEL. Dengan karakter vokal yang khas dan kemampuan menyampaikan emosi melalui lagu, Jiyoon mampu memberikan kesan tersendiri dalam setiap penampilannya. Ia kemudian berhasil debut bersama girl group izna pada tahun 2024.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Jungeun',
      'image': 'assets/images/jungeun_2.jpg',
      'description': 'Nama lengkap: Choi Jung-eun (최정은)\n\n'
          'Tanggal lahir: 4 Agustus 2007\n\n'
          'Zodiak: Leo ♌\n\n'
          'Deskripsi: Jungeun adalah trainee asal Korea Selatan yang dikenal memiliki kemampuan vokal dan menari yang seimbang. Ia pernah mengikuti program CAP-TEEN sebelum berpartisipasi dalam i-LAND 2. Berkat kemampuan, konsistensi, dan penampilannya yang kuat, Jungeun berhasil meraih peringkat pertama di babak final dan debut sebagai anggota girl group izna.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Koko',
      'image': 'assets/images/koko_2.jpg',
      'description': 'Nama lengkap: Narai Koko (楢井瑚々)\n\n'
          'Tanggal lahir: 14 November 2006\n\n'
          'Zodiak: Scorpio ♏\n\n'
          'Deskripsi: Koko adalah trainee asal Jepang yang dikenal karena kemampuan menarinya yang kuat dan energik. Ia telah belajar menari sejak usia tiga tahun dan juga memiliki kemampuan dalam rap serta menyanyi. Melalui partisipasinya dalam i-LAND 2, Koko menunjukkan kepercayaan diri dan pesona panggung yang menarik. Ia berhasil debut sebagai anggota girl group izna pada tahun 2024.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Mai',
      'image': 'assets/images/mai_2.jpg',
      'description': 'Nama lengkap: Tomioka Mai (富岡茉衣)\n\n'
          'Tanggal lahir: 28 Oktober 2004\n\n'
          'Zodiak: Scorpio ♏\n\n'
          'Deskripsi: Mai adalah trainee asal Jepang yang dikenal karena visualnya yang menawan, pembawaan yang tenang, dan pesona panggung yang khas. Ia pernah meraih prestasi dalam kompetisi tari tingkat sekolah menengah di Jepang sebelum mengikuti i-LAND 2. Mai juga memiliki kemampuan menari serta hobi merajut dan memasak. Berkat kerja keras dan penampilannya yang berkesan, ia berhasil debut sebagai anggota girl group izna pada tahun 2024.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Saebi',
      'image': 'assets/images/saebi_2.jpg',
      'description': 'Nama lengkap: Jeong Sae-bi (정세비)\n\n'
          'Tanggal lahir: 22 Januari 2008\n\n'
          'Zodiak: Aquarius ♒\n\n'
          'Deskripsi: Saebi adalah trainee asal Korea Selatan yang dikenal karena visualnya yang menawan, kaki jenjang, dan penampilan panggung yang percaya diri. Ia menjalani masa trainee yang cukup panjang di WAKEONE Entertainment sebelum mengikuti i-LAND 2. Dengan kemampuan menari, pesona yang cerah, dan semangat untuk terus berkembang, Saebi berhasil debut sebagai anggota girl group izna pada tahun 2024.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Sarang',
      'image': 'assets/images/sarang_2.jpg',
      'description': 'Nama lengkap: Ryu Sarang (유사랑)\n\n'
          'Tanggal lahir: 18 April 2007\n\n'
          'Zodiak: Aries ♈\n\n'
          'Deskripsi: Sarang adalah trainee asal Korea Selatan yang dikenal karena kemampuan menari, vokal, dan ekspresi panggungnya yang menarik. Ia memiliki pengalaman sebagai penari latar saat masih kecil dan menunjukkan perkembangan yang konsisten selama mengikuti i-LAND 2. Dengan bakat, kerja keras, dan pesonanya yang cerah, Sarang berhasil debut sebagai anggota girl group izna pada tahun 2024.',
      'icon': Icons.person,
      'votes': 0,
    },
    {
      'name': 'Yuju',
      'image': 'assets/images/yuju_2.jpg',
      'description': 'Nama lengkap: Nam Yu-ju (남유주)\n\n'
          'Tanggal lahir: 28 Juli 2007\n\n'
          'Zodiak: Leo ♌\n\n'
          'Deskripsi: Yuju adalah trainee keturunan Korea-Jepang yang dikenal memiliki kemampuan rap dan menari yang kuat. Sebelum mengikuti i-LAND 2, ia pernah berpartisipasi dalam program survival CAP-TEEN dan Stars Awakening. Pengalaman tersebut membantunya mengembangkan kemampuan serta kepercayaan diri di atas panggung. Yuju terus menunjukkan semangat dan kerja kerasnya dalam mengejar impian menjadi idol K-pop.',
      'icon': Icons.person,
      'votes': 0,
    },
  ];

  // Mengambil nama trainee untuk halaman voting.
  List<String> get voteTrainees {
    return trainees.map((trainee) => trainee['name'] as String).toList();
  }

  // Menghitung sisa kuota vote akun yang sedang login.
  int get remainingVotes {
    final remaining = maxVotes - voteCount;
    return remaining < 0 ? 0 : remaining;
  }

  // Memeriksa apakah kuota vote sudah habis.
  bool get hasReachedVoteLimit => voteCount >= maxVotes;

  // Mengambil daftar trainee favorit.
  List<Map<String, dynamic>> get favoriteTrainees {
    return List.unmodifiable(_favoriteTrainees);
  }

  // Memeriksa apakah trainee sudah menjadi favorit.
  bool isFavorite(String traineeName) {
    return _favoriteTrainees.any(
          (trainee) => trainee['name'] == traineeName,
    );
  }

  // Menghasilkan ID konsisten berdasarkan nama trainee.
  String _traineeId(String name) {
    return name.toLowerCase().replaceAll(' ', '_');
  }

  // Mengambil dokumen akun pengguna yang sedang login.
  DocumentReference<Map<String, dynamic>>? get _userDocument {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    return _firestore.collection('users').doc(user.uid);
  }

  // Membaca jumlah vote, riwayat, dan favorit dari Firestore.
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      voteCount = 0;
      votingHistory = [];
      _favoriteTrainees = [];
      notifyListeners();
      return;
    }

    isLoadingUserData = true;
    notifyListeners();

    try {
      final userRef = _firestore.collection('users').doc(user.uid);

      // Mengambil jumlah vote yang tersimpan.
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data();

      voteCount = (userData?['voteCount'] as num?)?.toInt() ?? 0;

      // Mengambil riwayat voting milik akun ini saja.
      final historySnapshot = await _firestore
          .collection('votes')
          .where('userId', isEqualTo: user.uid)
          .get();

      votingHistory = historySnapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();

      // Mengurutkan riwayat berdasarkan waktu terbaru.
      votingHistory.sort((a, b) {
        final timeA = a['votedAt'];
        final timeB = b['votedAt'];

        final dateA = timeA is Timestamp
            ? timeA.toDate()
            : DateTime.fromMillisecondsSinceEpoch(0);

        final dateB = timeB is Timestamp
            ? timeB.toDate()
            : DateTime.fromMillisecondsSinceEpoch(0);

        return dateB.compareTo(dateA);
      });

      // Mengambil favorit yang tersimpan pada akun pengguna.
      final favoriteSnapshot =
      await userRef.collection('favorites').get();

      _favoriteTrainees = favoriteSnapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['traineeName'] as String? ?? '';

        final trainee = trainees.firstWhere(
              (item) => item['name'] == name,
          orElse: () => {
            'name': name,
            'image': '',
            'description': '',
            'icon': Icons.person,
          },
        );

        return {
          ...trainee,
          'name': name,
          'traineeId': data['traineeId'] ?? doc.id,
        };
      }).toList();
    } catch (e) {
      debugPrint('Gagal memuat data pengguna: $e');
    } finally {
      isLoadingUserData = false;
      notifyListeners();
    }
  }

  // Mengirim vote ke Firestore dengan transaksi.
  // Transaksi membaca dan memperbarui kuota secara bersamaan.
  Future<bool> submitVote() async {
    lastVoteError = null;

    final user = FirebaseAuth.instance.currentUser;
    final userRef = _userDocument;

    if (user == null || userRef == null) {
      lastVoteError = 'silakan login terlebih dahulu.';
      notifyListeners();
      return false;
    }

    if (selectedVoteIndex < 0 ||
        selectedVoteIndex >= voteTrainees.length) {
      lastVoteError = 'pilih trainee terlebih dahulu.';
      notifyListeners();
      return false;
    }

    if (isSubmittingVote) return false;

    isSubmittingVote = true;
    notifyListeners();

    final traineeName = voteTrainees[selectedVoteIndex];
    final traineeId = _traineeId(traineeName);

    // ID vote dibuat sebelum transaksi dijalankan.
    final voteRef = _firestore.collection('votes').doc();

    try {
      final result = await _firestore.runTransaction<bool>(
            (transaction) async {
          final userSnapshot = await transaction.get(userRef);
          final userData = userSnapshot.data();

          final currentCount =
              (userData?['voteCount'] as num?)?.toInt() ?? 0;

          // Mencegah vote jika akun sudah menggunakan 5 vote.
          if (currentCount >= maxVotes) {
            return false;
          }

          // Memperbarui kuota dan menyimpan vote secara atomik.
          transaction.set(
            userRef,
            {
              'uid': user.uid,
              'email': user.email,
              'voteCount': currentCount + 1,
            },
            SetOptions(merge: true),
          );

          transaction.set(voteRef, {
            'userId': user.uid,
            'traineeId': traineeId,
            'traineeName': traineeName,
            'votedAt': FieldValue.serverTimestamp(),
          });

          return true;
        },
      );

      if (!result) {
        lastVoteError = 'kuota vote kamu sudah habis (5/5).';
        return false;
      }

      // Mengosongkan pilihan setelah vote berhasil disimpan.
      selectedVoteIndex = -1;

      // Memuat ulang data agar riwayat dan kuota sesuai Firestore.
      await loadUserData();

      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan vote: $e');
      lastVoteError = 'vote gagal disimpan. periksa koneksi dan coba lagi.';
      return false;
    } finally {
      isSubmittingVote = false;
      notifyListeners();
    }
  }

  // Menambah atau membatalkan favorit dan menyimpannya ke Firestore.
  Future<bool> toggleFavorite(String traineeName) async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef = _userDocument;

    if (user == null || userRef == null) return false;

    final trainee = trainees.firstWhere(
          (item) => item['name'] == traineeName,
      orElse: () => <String, dynamic>{},
    );

    if (trainee.isEmpty) return false;

    final traineeId = _traineeId(traineeName);
    final favoriteRef = userRef.collection('favorites').doc(traineeId);

    try {
      if (isFavorite(traineeName)) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'traineeId': traineeId,
          'traineeName': traineeName,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      await loadUserData();
      return true;
    } catch (e) {
      debugPrint('Gagal memperbarui favorit: $e');
      return false;
    }
  }

  // Mengatur trainee yang dipilih di halaman voting.
  void selectVote(int index) {
    if (index >= 0 &&
        index < voteTrainees.length &&
        !hasReachedVoteLimit) {
      selectedVoteIndex = index;
      notifyListeners();
    }
  }

  // Menyaring trainee berdasarkan pencarian.
  List<Map<String, dynamic>> get filteredTrainees {
    if (searchQuery.trim().isEmpty) return trainees;

    return trainees.where((trainee) {
      final name = trainee['name'].toString().toLowerCase();
      return name.contains(searchQuery.trim().toLowerCase());
    }).toList();
  }

  void changePage(int index) {
    if (index >= 0 && index < 4) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  Future<void> refreshHome() async {
    await loadUserData();
  }
}
