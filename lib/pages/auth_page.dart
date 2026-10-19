import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

// Memeriksa status login pengguna secara otomatis.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B1026),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8B7FFF)),
            ),
          );
        }

        // Jika pengguna sudah login, tampilkan homepage.
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Jika belum login, tampilkan halaman login.
        return const AuthPage();
      },
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegister = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Proses login atau registrasi melalui Firebase Authentication.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isRegister) {
        if (_passwordController.text != _confirmPasswordController.text) {
          throw Exception('Konfirmasi password tidak cocok.');
        }

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-not-found':
        case 'invalid-credential':
          message = 'Email atau password salah.';
          break;
        case 'wrong-password':
          message = 'Password yang dimasukkan salah.';
          break;
        case 'email-already-in-use':
          message = 'Email sudah terdaftar.';
          break;
        case 'weak-password':
          message = 'Password minimal 6 karakter.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti.';
          break;
        default:
          message = e.message ?? 'Terjadi kesalahan autentikasi.';
      }

      _showMessage(message);
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Menampilkan pesan hasil atau kesalahan.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF101A3C), Color(0xFF0B1026), Color(0xFF17102E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.nightlight_round,
                      size: 72,
                      color: Color(0xFF8B7FFF),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'i-LAND 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isRegister
                          ? 'Buat akun untuk mulai mendukung trainee favoritmu.'
                          : 'Masuk dan dukung trainee favoritmu.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Input email pengguna.
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        'Email',
                        Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email wajib diisi.';
                        }

                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value.trim())) {
                          return 'Masukkan email yang valid.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Input password dengan fitur tampil/sembunyi.
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          _inputDecoration(
                            'Password',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi.';
                        }

                        if (_isRegister && value.length < 6) {
                          return 'Password minimal 6 karakter.';
                        }

                        return null;
                      },
                    ),

                    // Konfirmasi password hanya muncul saat registrasi.
                    if (_isRegister) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Konfirmasi Password',
                          Icons.lock_reset,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi.';
                          }

                          if (value != _passwordController.text) {
                            return 'Password tidak cocok.';
                          }

                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Tombol login atau pembuatan akun.
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7FFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isRegister ? 'Daftar' : 'Login',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Berpindah antara mode login dan registrasi.
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isRegister = !_isRegister;
                                _formKey.currentState?.reset();
                                _confirmPasswordController.clear();
                              });
                            },
                      child: Text(
                        _isRegister
                            ? 'Sudah punya akun? Login'
                            : 'Belum punya akun? Daftar',
                        style: const TextStyle(color: Color(0xFFB9B0FF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Menyamakan tampilan semua kolom input.
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: const Color(0xFFB9B0FF)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF8B7FFF), width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.orangeAccent),
    );
  }
}