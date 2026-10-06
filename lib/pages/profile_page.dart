import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // membangun halaman profil.
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor:
                Color(0xFF252B50),
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'user profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton.icon(
                onPressed: () {
                  // menampilkan pesan profil.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'halaman profil aktif.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person,
                ),
                label: const Text(
                  'profil saya',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}