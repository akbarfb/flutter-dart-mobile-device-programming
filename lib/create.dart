import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateMahasiswaPage extends StatefulWidget {
  @override
  _CreateMahasiswaPageState createState() => _CreateMahasiswaPageState();
}

class _CreateMahasiswaPageState extends State<CreateMahasiswaPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  Future<void> _addMahasiswa() async {
    final url = Uri.parse('https://irzanet.000webhostapp.com/api/api-tambah-mhs.php');
    final postBody = {
      'nama': _namaController.text,
      'alamat': _alamatController.text,
      'jurusan': _jurusanController.text,
    };

    final response = await http.post(
      url,
      body: postBody,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      // Process the response data as needed
      print('Response from server: $responseData');
      Navigator.of(context).pop(true);
    } else {
      print('Failed to add Mahasiswa. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data Mahasiswa'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Mahasiswa'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat Mahasiswa'),
            ),
            TextField(
              controller: _jurusanController,
              decoration: InputDecoration(labelText: 'Prodi Mahasiswa'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: _addMahasiswa,
              child: Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

