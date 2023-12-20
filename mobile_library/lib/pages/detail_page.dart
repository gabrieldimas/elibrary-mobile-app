import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inisialisasi data berdasarkan widget turunan
    final status = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (status != null) {
      data = status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Text('Error loading data');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data OCR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('NIK: ${data!['nik']}', style: const TextStyle(fontSize: 20)),
            Text('Nama: ${data!['nama']}', style: const TextStyle(fontSize: 20)),
            Text('Tempat Lahir: ${data!['tempat_lahir']}', style: const TextStyle(fontSize: 20)),
            Text('Tanggal Lahir: ${data!['tgl_lahir']}', style: const TextStyle(fontSize: 20)),
            Text('Waktu Diproses: ${data!['time_elapsed']} detik', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
