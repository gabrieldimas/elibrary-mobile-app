import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simbesi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Container(
                margin: EdgeInsets.only(top: 128),
                child: Text(
                  'Halo, Selamat Datang di Simbesi',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // Image
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Image.asset(
                  'assets/college-project-amico.png',
                  width: 287,
                  height: 287,
                ),
              ),

              // Buttons
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the action for the first button
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.all(24.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: Text(
                  'Lihat Ranking Sementara',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the action for the second button
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.all(24.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: Text(
                  'Tambah Data Siswa',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
