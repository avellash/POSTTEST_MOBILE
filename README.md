# i-LAND 2 Voting App

## Deskripsi Aplikasi

i-LAND 2 Voting App merupakan aplikasi berbasis Flutter yang dibuat untuk mendukung kegiatan voting trainee perempuan dalam acara survival show i-LAND 2. Aplikasi ini memungkinkan pengguna untuk masuk ke akun, memberikan suara kepada trainee favorit, melihat peringkat trainee, serta mengelola profil pengguna.

## Fitur Aplikasi

- **Login dan autentikasi:** pengguna dapat masuk menggunakan akun yang terdaftar.
- **Homepage:** menampilkan informasi voting, navigasi aplikasi, dan informasi trainee.
- **Vote Trainee:** pengguna dapat memberikan suara kepada trainee favorit dengan batas maksimal lima suara.
- **Peringkat Trainee:** menampilkan peringkat trainee berdasarkan jumlah suara yang tersimpan di database.
- **Profil Trainee:** menyediakan informasi mengenai peserta trainee.
- **Profil Pengguna:** menampilkan dan mengelola informasi profil serta foto profil pengguna.

## Teknologi yang Digunakan

- Flutter sebagai framework pengembangan aplikasi.
- Dart sebagai bahasa pemrograman.
- Firebase Authentication untuk autentikasi pengguna.
- Cloud Firestore sebagai database untuk menyimpan data pengguna, voting, dan favorit.
- Provider untuk pengelolaan state aplikasi.

## Cara Kerja Aplikasi

1. Pengguna membuka aplikasi dan melakukan login.
2. Setelah berhasil login, pengguna diarahkan ke homepage.
3. Pengguna dapat membuka halaman Vote Trainee untuk memberikan suara kepada trainee yang dipilih.
4. Data voting disimpan ke Cloud Firestore dengan identitas pengguna dan trainee yang dipilih.
5. Provider mengambil dan memantau perubahan data voting dari Firestore untuk memperbarui jumlah suara dan peringkat trainee.
6. Pengguna dapat membuka halaman profil untuk melihat dan memperbarui informasi akun serta foto profil.

## Cara Menghubungkan Aplikasi dengan Database

Aplikasi menggunakan Firebase sebagai layanan backend dan Cloud Firestore sebagai database.

1. Buat proyek di [Firebase Console](https://console.firebase.google.com/).
2. Daftarkan aplikasi Android menggunakan package name yang sesuai dengan proyek Flutter.
3. Hubungkan proyek Flutter ke Firebase menggunakan FlutterFire CLI.
4. Pastikan file konfigurasi Firebase, seperti `firebase_options.dart`, tersedia dan sesuai dengan proyek Firebase yang digunakan.
5. Aktifkan Firebase Authentication dan metode login yang digunakan oleh aplikasi.
6. Buat Cloud Firestore Database melalui Firebase Console.
7. Atur Firestore Security Rules agar hanya pengguna yang terautentikasi dan memiliki izin yang sesuai dapat membaca atau mengubah data.
8. Tambahkan dependensi `firebase_core`, `firebase_auth`, `cloud_firestore`, dan `provider` pada `pubspec.yaml`.
9. Inisialisasikan Firebase sebelum menjalankan aplikasi.
10. Gunakan `FirebaseAuth` untuk mengelola autentikasi dan `FirebaseFirestore.instance` untuk mengakses database.

## Struktur Data Firestore

- **users:** menyimpan informasi akun pengguna dan jumlah suara yang telah digunakan.
- **votes:** menyimpan data voting, termasuk ID pengguna, ID trainee, nama trainee, dan waktu voting.
- **users/{uid}/favorites:** menyimpan daftar trainee favorit milik masing-masing pengguna.

## Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terpasang.
2. Buka folder proyek menggunakan Android Studio atau Visual Studio Code.
3. Jalankan perintah berikut pada terminal:

   flutter pub get
   flutter run

5. Untuk membuat APK release, jalankan:

   flutter build apk --release

6. File APK dapat ditemukan pada lokasi:

   build/app/outputs/flutter-apk/app-release.apk

## Catatan

Aplikasi membutuhkan koneksi internet untuk menggunakan layanan Firebase. Akses database mengikuti konfigurasi Firebase Authentication dan Firestore Security Rules pada proyek yang digunakan.
