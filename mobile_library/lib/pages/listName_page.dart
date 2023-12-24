import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListNamePage extends StatefulWidget {
  const ListNamePage({Key? key}) : super(key: key);

  @override
  State<ListNamePage> createState() => _ListNamePageState();
}

class _ListNamePageState extends State<ListNamePage> {
  // List to store fetched data from Firebase
  List<Map<String, dynamic>> namesData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    // Fetch data from the "KTP" collection
    final snapshot = await FirebaseFirestore.instance.collection('KTP').get();
    setState(() {
      namesData = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'List Nama Peminjam',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 16),
                // Use ListView.builder to create a dynamic list based on fetched data
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: namesData.length,
                  itemBuilder: (context, index) {
                    final nameData = namesData[index];
                    return ExpansionTile(
                      title: Text(nameData['nama']),
                      backgroundColor: Colors.grey[200],
                      children: [
                        // Display details from fetched data
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('NIK: ${nameData['nik']}'),
                                      Text('Nama: ${nameData['nama']}'),
                                      Text('TTL: ${nameData['ttl']}'),
                                      Text('Alamat: ${nameData['alamat']}'),
                                      Text('Buku: ${nameData['buku']}'),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle "Kembalikan" button action
                                          deleteData(nameData['nama'], context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff5162AE),
                                            onPrimary: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            )),
                                        child: Text(
                                          'Kembalikan',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to delete data from Firebase and notify user and refresh the page
deleteData(String name, BuildContext context) async {
  await FirebaseFirestore.instance.collection('KTP').doc(name).delete();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Data berhasil dihapus'),
    ),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ListNamePage()),
  );
}
