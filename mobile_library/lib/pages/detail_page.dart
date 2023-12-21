import 'package:flutter/material.dart';
import 'package:mobile_library/routes/routes.dart';
import 'package:mobile_library/pages/scan_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? data;
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController TTLController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inisialisasi data berdasarkan widget turunan
    final status =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (status != null) {
      data = status;
      nikController.text = data!['nik'] ?? '';
      namaController.text = data!['nama'] ?? '';
      TTLController.text = data!['tempat_lahir'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Text('Error loading data');
    }

    return Scaffold(
      appBar: AppBar(),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('NIK: ${data!['nik']}', style: const TextStyle(fontSize: 20)),
      //       Text('Nama: ${data!['nama']}',
      //           style: const TextStyle(fontSize: 20)),
      //       Text('Tempat Lahir: ${data!['tempat_lahir']}',
      //           style: const TextStyle(fontSize: 20)),
      //       Text('Tanggal Lahir: ${data!['tgl_lahir']}',
      //           style: const TextStyle(fontSize: 20)),
      //       Text('Waktu Diproses: ${data!['time_elapsed']} detik',
      //           style: const TextStyle(fontSize: 20)),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Container(
                  child: Text(
                    'Hasil Scan',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NIK', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  controller: nikController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: nikController.text,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text('Nama', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  controller: namaController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: namaController.text,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text('TTL', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  controller: TTLController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: TTLController.text,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text('Alamat', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  controller: alamatController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: alamatController.text,
                                    // contentPadding:
                                    //     EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text('Pilih Buku', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Atomic Habits',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 65),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.scan);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Color(0xff5162AE),
                                    side: BorderSide(color: Color(0xff5162AE)),
                                    padding: const EdgeInsets.fromLTRB(
                                        48, 16, 48, 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                child: Text('Kembali',
                                    style: TextStyle(
                                      color: Color(0xff5162AE),
                                    )),
                              ),
                              SizedBox(width: 20), // Jarak antara tombol
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff5162AE),
                                    onPrimary: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                        48, 16, 48, 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                child: Text(
                                  'Submit',
                                  // style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
