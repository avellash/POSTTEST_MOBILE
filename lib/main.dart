import 'package:flutter/material.dart';

void main() {
  // Menjalankan aplikasi flutter
  runApp(const MyApp());
}

// WIDGET UTAMA APLIKASI
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp merupakan widget utama untuk aplikasi yang menggunakan desain material dari flutter
    return MaterialApp(

      // Menghilangkan tulisan debug di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // Judul aplikasi
      title: 'I-LAND 2 Voting',

      // ThemeData digunakan untuk mengatur tema aplikasi
      theme: ThemeData(

        // Warna dasar background halaman menggunakan warna biru gelap
        scaffoldBackgroundColor: const Color(0xFF0B1026),

        // Menggunakan mode dark
        brightness: Brightness.dark,

        // Jenis font yang digunakan
        fontFamily: 'Arial',
      ),

      // Menentukan halaman pertama yang ditampilkan
      home: const HomePage(),
    );
  }
}


// HALAMAN HOME

// StatefulWidget digunakan karena halaman memiliki data yang dapat berubah, yaitu menu BottomNavigationBar yang sedang dipilih
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// State dari HomePage
class _HomePageState extends State<HomePage> {

  // Menyimpan index menu yang sedang dipilih.
  // 0 = Home
  // 1 = Vote
  // 2 = Trainee
  // 3 = Profil
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Scaffold menyediakan bagian seperti body dan bottomNavigationBar
    return Scaffold(

      // BODY HALAMAN
      // SafeArea digunakan agar isi aplikasi tidak bertabrakan dengan status bar pada bagian atas layar
      body: SafeArea(

        // SingleChildScrollView membuat isi halaman dapat digulir jika kontennya lebih panjang daripada ukuran layar
        child: SingleChildScrollView(

          // Padding memberikan jarak antara isi halaman dengan bagian tepi layar
          child: Padding(
            padding: const EdgeInsets.all(20),

            // Column digunakan untuk menyusun widget secara vertikal dari atas ke bawah
            child: Column(

              // Isi Column dimulai dari sisi kiri
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // HEADER
                // Row digunakan untuk menyusun widget secara horizontal
                Row(

                  // SpaceBetween memberikan jarak maksimum antara widget pertama dan widget terakhir
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    // Text digunakan untuk menampilkan tulisan nama aplikasi
                    const Text(
                      'I-LAND 2',

                      // TextStyle digunakan untuk mengatur tampilan tulisan
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Container digunakan sebagai wadah untuk icon notifikasi
                    Container(

                      // Padding memberikan jarak antara icon dengan sisi Container
                      padding: const EdgeInsets.all(10),

                      // BoxDecoration digunakan untuk mengatur warna dan bentuk Container
                      decoration: BoxDecoration(

                        // Warna background Container
                        color: const Color(0xFF151B3D),

                        // Membuat sudut Container menjadi bulat
                        borderRadius: BorderRadius.circular(12),
                      ),

                      // Icon digunakan untuk menampilkan simbol notifikasi
                      child: const Icon(
                        Icons.notifications_none,

                        // Warna icon
                        color: Colors.white,

                        // Ukuran icon
                        size: 24,
                      ),
                    ),
                  ],
                ),

                // SizedBox digunakan untuk memberikan jarak vertikal antara Header dan Hero
                const SizedBox(height: 28),

                // HERO / JUDUL UTAMA
                // Text digunakan untuk menampilkan ajakan kepada pengguna
                const Text(
                  'Vote Your\nFavorite Trainee!',

                  style: TextStyle(
                    // Ukuran tulisan
                    fontSize: 30,

                    // Membuat tulisan menjadi tebal
                    fontWeight: FontWeight.bold,

                    // Mengatur jarak antar baris
                    height: 1.2,

                    // Warna tulisan
                    color: Colors.white,
                  ),
                ),

                // Jarak antara judul dan deskripsi
                const SizedBox(height: 10),

                // Text untuk memberikan penjelasan singkat mengenai aplikasi
                const Text(
                  'Dukung trainee favoritmu untuk melangkah lebih jauh.',

                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFAEB6D9),
                  ),
                ),

                // Jarak sebelum Search Bar
                const SizedBox(height: 22),

                // SEARCH BAR
                // TextField digunakan sebagai tempat pengguna memasukkan teks pencarian
                TextField(

                  // InputDecoration digunakan untuk mengatur tampilan TextField
                  decoration: InputDecoration(

                    // Teks petunjuk sebelum pengguna mengetik
                    hintText: 'Cari trainee...',

                    // Mengatur warna teks petunjuk
                    hintStyle: const TextStyle(
                      color: Color(0xFFAEB6D9),
                    ),

                    // Icon search diletakkan di sebelah kiri
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFAEB6D9),
                    ),

                    // Membuat background TextField terisi warna
                    filled: true,

                    // Warna background Search Bar
                    fillColor: const Color(0xFF151B3D),

                    // Mengatur bentuk border TextField
                    border: OutlineInputBorder(

                      // Membuat sudut Search Bar membulat
                      borderRadius: BorderRadius.circular(15),

                      // Menghilangkan garis border
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                // Jarak sebelum bagian Voting
                const SizedBox(height: 28),


                // WAKTU VOTING
                // Text sebagai judul bagian voting
                const Text(
                  'VOTING BERLANGSUNG',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,

                    // Memberikan jarak antar huruf
                    letterSpacing: 1,

                    color: Color(0xFFE88BFF),
                  ),
                ),

                // Jarak antara judul dan kartu waktu
                const SizedBox(height: 12),

                // Container digunakan sebagai kartu
                // informasi waktu voting.
                Container(

                  // Membuat kartu memenuhi lebar yang tersedia
                  width: double.infinity,

                  // Memberikan ruang di dalam kartu
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 20,
                  ),

                  // Mengatur tampilan kartu
                  decoration: BoxDecoration(

                    // Warna kartu
                    color: const Color(0xFF151B3D),

                    // Membuat sudut kartu membulat
                    borderRadius: BorderRadius.circular(20),

                    // Memberikan garis di sekeliling kartu
                    border: Border.all(
                      color: const Color(0xFF8B7FFF),
                      width: 1,
                    ),
                  ),

                  // Column digunakan karena isi kartu disusun dari atas ke bawah
                  child: Column(
                    children: [

                      // Icon jam sebagai penanda waktu voting
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFFE88BFF),
                        size: 30,
                      ),

                      // Jarak setelah icon
                      const SizedBox(height: 10),

                      // Label waktu voting
                      const Text(
                        'WAKTU VOTING',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAEB6D9),
                        ),
                      ),

                      // Jarak sebelum countdown
                      const SizedBox(height: 5),

                      // Tampilan waktu voting
                      const Text(
                        '02 : 15 : 30',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // Jarak sebelum keterangan waktu berakhir
                      const SizedBox(height: 5),

                      // Informasi kapan voting berakhir
                      const Text(
                        'Voting berakhir hari ini, 23:59',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFAEB6D9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Jarak sebelum bagian trainee
                const SizedBox(height: 30),

                // BAGIAN PILIH TRAINEE
                // Row digunakan untuk menempatkan judul dan tulisan Lihat Semua dalam satu baris
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    // Judul bagian trainee
                    const Text(
                      'Pilih Trainee',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Text untuk menunjukkan pilihan melihat semua trainee
                    const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B7FFF),
                      ),
                    ),
                  ],
                ),

                // Jarak sebelum kartu trainee
                const SizedBox(height: 15),

                // BARIS TRAINEE PERTAMA
                // Row digunakan untuk membuat dua kartu trainee dalam satu baris
                Row(
                  children: [
                    // Expanded membagi ruang yang tersedia untuk kartu trainee pertama
                    Expanded(
                      child: traineeCard(
                        'Jiyoon',
                        Icons.person,
                      ),
                    ),

                    // Jarak antara kartu pertama dan kedua
                    const SizedBox(width: 12),

                    // Expanded untuk kartu trainee kedua
                    Expanded(
                      child: traineeCard(
                        'Jeemin',
                        Icons.person,
                      ),
                    ),
                  ],
                ),

                // Jarak antar baris kartu
                const SizedBox(height: 12),

                // BARIS TRAINEE KEDUA
                Row(
                  children: [

                    // Kartu trainee ketiga
                    Expanded(
                      child: traineeCard(
                        'Koko',
                        Icons.person,
                      ),
                    ),

                    // Jarak antara kartu
                    const SizedBox(width: 12),

                    // Kartu trainee keempat
                    Expanded(
                      child: traineeCard(
                        'Sarang',
                        Icons.person,
                      ),
                    ),
                  ],
                ),

                // Jarak sebelum bagian trainee populer
                const SizedBox(height: 30),

                // TRAINEE POPULER
                // Text digunakan sebagai judul bagian
                const Text(
                  'Trainee Populer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Jarak setelah judul
                const SizedBox(height: 15),

                // Menampilkan trainee populer pertama
                popularTrainee('Jiyoon'),

                // Menampilkan trainee populer kedua
                popularTrainee('Jeemin'),

                // Menampilkan trainee populer ketiga
                popularTrainee('Koko'),

                // Jarak bagian paling bawah halaman
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      // BottomNavigationBar digunakan sebagai navigasi utama aplikasi di bagian bawah layar
      bottomNavigationBar: BottomNavigationBar(

        // Menentukan menu yang sedang aktif
        currentIndex: selectedIndex,

        // Fungsi yang dijalankan ketika menu ditekan
        onTap: (index) {

          // setState digunakan untuk memperbarui tampilan ketika index menu berubah
          setState(() {

            // Menyimpan index menu yang dipilih
            selectedIndex = index;
          });
        },

        // Membuat semua item navigation tetap terlihat
        type: BottomNavigationBarType.fixed,

        // Warna background BottomNavigationBar
        backgroundColor: const Color(0xFF151B3D),

        // Warna icon dan teks yang sedang aktif
        selectedItemColor: const Color(0xFF8B7FFF),

        // Warna icon dan teks yang tidak aktif
        unselectedItemColor: const Color(0xFFAEB6D9),

        // Daftar menu pada BottomNavigationBar
        items: const [

          // Menu Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          // Menu Vote
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_outlined),
            activeIcon: Icon(Icons.how_to_vote),
            label: 'Vote',
          ),

          // Menu Trainee
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Trainee',
          ),

          // Menu Profil
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // WIDGET KARTU TRAINEE

  // Fungsi ini digunakan untuk membuat kartu trainee.
  // Parameter:
  // name = nama trainee
  // icon = icon yang digunakan sebagai gambar sementara
  Widget traineeCard(String name, IconData icon) {

    // Container menjadi wadah utama kartu trainee
    return Container(

      // Jarak isi kartu dengan sisi Container
      padding: const EdgeInsets.all(12),

      // Mengatur tampilan kartu
      decoration: BoxDecoration(

        // Warna background kartu
        color: const Color(0xFF151B3D),

        // Membuat sudut kartu membulat
        borderRadius: BorderRadius.circular(18),
      ),

      // Column digunakan untuk menyusun gambar, nama, dan tombol secara vertikal
      child: Column(

        // Isi Column dimulai dari kiri
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // GAMBAR TRAINEE
          // Container digunakan sebagai tempat gambar trainee sementara
          Container(

            // Tinggi area gambar
            height: 130,

            // Lebar mengikuti ruang yang tersedia
            width: double.infinity,

            // Mengatur bentuk area gambar
            decoration: BoxDecoration(
              color: const Color(0xFF252B50),

              // Membuat sudut area gambar membulat
              borderRadius: BorderRadius.circular(14),
            ),

            // Icon digunakan sebagai gambar sementara
            child: Icon(
              icon,
              size: 60,
              color: const Color(0xFFAEB6D9),
            ),
          ),

          // Jarak antara gambar dan nama
          const SizedBox(height: 10),

          // NAMA TRAINEE
          // Text menampilkan nama trainee
          Text(
            name,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Jarak sebelum tombol
          const SizedBox(height: 10),

          // SizedBox digunakan agar tombol memiliki lebar penuh sesuai kartu
          SizedBox(
            width: double.infinity,

            // ElevatedButton digunakan sebagai tombol untuk melakukan voting
            child: ElevatedButton(
              onPressed: () {},

              // Mengatur tampilan tombol
              style: ElevatedButton.styleFrom(

                // Warna tombol
                backgroundColor: const Color(0xFF8B7FFF),

                // Warna teks tombol
                foregroundColor: Colors.white,

                // Membuat sudut tombol membulat
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Tulisan pada tombol
              child: const Text('VOTE'),
            ),
          ),
        ],
      ),
    );
  }


  // WIDGET TRAINEE POPULER
  // Fungsi ini digunakan untuk membuat satu item pada daftar trainee populer
  Widget popularTrainee(String name) {

    // Container menjadi background untuk item trainee populer
    return Container(

      // Margin memberikan jarak antara item satu dengan item berikutnya
      margin: const EdgeInsets.only(bottom: 10),

      // Padding memberikan ruang di dalam item
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),

      // Mengatur tampilan item
      decoration: BoxDecoration(
        color: const Color(0xFF151B3D),
        borderRadius: BorderRadius.circular(14),
      ),

      // Row digunakan untuk membuat
      // icon, nama, dan chevron berada dalam satu baris.
      child: Row(
        children: [

          // CircleAvatar digunakan untuk membuat icon trainee berbentuk lingkaran
          const CircleAvatar(
            radius: 20,

            // Background lingkaran
            backgroundColor: Color(0xFF252B50),

            // Icon trainee
            child: Icon(
              Icons.person,
              color: Color(0xFFAEB6D9),
            ),
          ),

          // Jarak antara icon dan nama
          const SizedBox(width: 12),

          // Expanded membuat nama mengambil ruang yang tersedia di tengah
          Expanded(

            // Text menampilkan nama trainee
            child: Text(
              name,

              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // Icon chevron menunjukkan bahwa bagian tersebut dapat diarahkan ke halaman lain nantinya
          const Icon(
            Icons.chevron_right,
            color: Color(0xFFAEB6D9),
          ),
        ],
      ),
    );
  }
}