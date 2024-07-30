import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class EditMahasiswaPage extends StatefulWidget {
  final String id;

  EditMahasiswaPage({required this.id});

  @override
  _EditMahasiswaPageState createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  Future<void> _editMahasiswa() async {
    final url = Uri.parse('https://irzanet.000webhostapp.com/api/api-edit-mhs.php');
    final postBody = {
      'id': widget.id,
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
      print('Failed to edit Mahasiswa. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mahasiswa'),
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
              decoration: InputDecoration(labelText: 'Jurusan Mahasiswa'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editMahasiswa,
              child: Text('Ubah Data Mahasiswa'),
            ),
          ],
        ),
      ),
    );
  }
}
