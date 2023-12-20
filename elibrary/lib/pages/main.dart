import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_list.dart';

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
                  'eLibrary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                ),
              ),

              // Image
              Container(
                margin: EdgeInsets.only(top: 86),
                child: Image.network(
                  "https://storyset.com/illustration/bibliophile/rafiki",
                  width: 287,
                  height: 287,
                ),
              ),
              // Buttons
              SizedBox(height: 86),
              ElevatedButton(
                onPressed: () {},
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookList()),
                  );
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
