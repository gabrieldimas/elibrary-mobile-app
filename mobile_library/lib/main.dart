import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_library/pages/detail_page.dart';
import 'package:mobile_library/pages/scan_page.dart';
import 'package:mobile_library/routes/routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eLibrary',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        AppRoutes.home: (context) => MyHomePage(),
        AppRoutes.scan: (context) => ScanPage(),
        AppRoutes.details: (context) => DetailsPage(),
      },
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
                  'eLibrary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                ),
              ),

              // Image
              Container(
                margin: EdgeInsets.only(top: 86),
                child: Image.asset(
                  "assets/college-project-amico.png",
                  width: 287,
                  height: 287,
                ),
              ),
              // Buttons
              SizedBox(height: 56),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.scan);
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff5162AE),
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: Text(
                  'Pinjam Buku',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff5162AE),
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: Text(
                  'Lihat List Buku',
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
