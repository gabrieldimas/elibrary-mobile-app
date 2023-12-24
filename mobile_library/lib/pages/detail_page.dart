import 'package:flutter/material.dart';
import 'package:mobile_library/routes/routes.dart';
import 'package:mobile_library/pages/scan_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String? nik, nama, ttl, alamat;

  // Declare controllers at the beginning of your _DetailsPageState class
  TextEditingController nikController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController ttlController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController bukuController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments passed from ScanPage
    final Map<String, dynamic>? ktp =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (ktp != null) {
      setState(() {
        nik = ktp['nik'];
        nama = ktp['nama'];
        ttl = ktp['ttl'];
        alamat = ktp['alamat'];

        // Set the controller values
        nikController.text = nik ?? '';
        namaController.text = nama ?? '';
        ttlController.text = ttl ?? '';
        alamatController.text = alamat ?? '';
      });
    }
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("KTP").doc(namaController.text);

    // create Map
    Map<String, dynamic> ktp = {
      "nik": nikController.text,
      "nama": namaController.text,
      "ttl": ttlController.text,
      "alamat": alamatController.text,
      "buku": bukuController.text,
    };

    documentReference.set(ktp).whenComplete(() {
      Navigator.pushNamed(context, AppRoutes.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "1234567890123456",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  controller: nikController,
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "John Doe",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  controller: namaController,
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "DD/MM/YYYY",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  controller: ttlController,
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Jl. Kenangan No. 1",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  controller: alamatController,
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
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Atomic Habits',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  controller: bukuController,
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
                                        40, 16, 40, 16),
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
                                  createData();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff5162AE),
                                    onPrimary: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 16, 40, 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                child: Text(
                                  'Submit',
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
