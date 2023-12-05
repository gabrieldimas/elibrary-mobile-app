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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  'Halo, selamat datang di Simbesi',
                  style: TextStyle(fontSize: 24),
                ),
              ),

              // Image
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Image.asset(
                  '../assets/college-project-amico.png', // Replace with your image asset
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
                child: Text('Lihat Ranking Sementara'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the action for the second button
                },
                child: Text('Tambah Data Siswa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
