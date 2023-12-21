import 'package:flutter/material.dart';

class ListNamePage extends StatefulWidget {
  const ListNamePage({Key? key}) : super(key: key);

  @override
  State<ListNamePage> createState() => _ListNamePageState();
}

class _ListNamePageState extends State<ListNamePage> {
  //Inisialisasi List Peminjan
  List<String> names = ['John Doe', 'Jane Doe', 'Bob Smith', 'Alice Johnson'];
  String selectedName = '';

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
                // ListView.builder untuk membuat daftar dinamis
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(names[index]),
                      backgroundColor: Colors.grey[200],
                      children: [
                        // Widget untuk menampilkan detail nama yang diklik
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
                                      Text('NIK:'),
                                      Text('Nama: '),
                                      Text('TTL:'),
                                      Text('Alamat: '),
                                      Text('Buku: '),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             DetailsPage()));
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
