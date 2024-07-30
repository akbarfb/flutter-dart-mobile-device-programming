import 'package:flutter/material.dart';
import 'package:tugas_akhir/create.dart'; // Import the create.dart file
import 'package:tugas_akhir/edit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class Mahasiswa {
  final String id;
  final String nama;
  final String alamat;
  final String jurusan;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.jurusan,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      jurusan: json['jurusan'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahasiswa App',
      home: MahasiswaListPage(),
      routes: {
        '/create': (context) => CreateMahasiswaPage(),
      },
    );
  }
}

class MahasiswaListPage extends StatefulWidget {
  @override
  _MahasiswaListPageState createState() => _MahasiswaListPageState();
}

class _MahasiswaListPageState extends State<MahasiswaListPage> {
  List<Mahasiswa>? _mahasiswaList;
  bool _loading = false;

  get builder => null;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });

    final url =
        Uri.parse('https://irzanet.000webhostapp.com/api/api-tampil-mhs.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _mahasiswaList =
              jsonData.map((item) => Mahasiswa.fromJson(item)).toList();
          _loading = false;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        setState(() {
          _mahasiswaList = null;
          _loading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _mahasiswaList = null;
        _loading = false;
      });
    }
  }

  void _goToCreatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateMahasiswaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mahasiswa List'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _mahasiswaList != null
              ? ListView.builder(
                  itemCount: _mahasiswaList!.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = _mahasiswaList![index];
                    return ListTile(
                      title: Text(mahasiswa.nama),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jurusan: ${mahasiswa.jurusan}'),
                          Text('Alamat: ${mahasiswa.alamat}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [ 
                          ElevatedButton( 
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                            onPressed: () async {
                              var result = await Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditMahasiswaPage(id: mahasiswa.id),
                                ),
                              );
                              if (result == true){
                                setState(() {
                                  _loading = true;
                                  fetchData();
                                });
                              }
                            },
                            child: Text('Edit')
                          ),
                          SizedBox(width: 8),
                          ElevatedButton( 
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                            onPressed: () {
                              _deleteMahasiswa(mahasiswa.id);
                            },
                            child: Text('Hapus')
                          ),
                        ],
                      ),
                    );
                  },
                )
              : FutureBuilder<void>(
                  future: fetchData(), // Call the fetchData() method here
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.error != null) {
                      return Center(child: Text('Failed to fetch data.'));
                    } else {
                      return ListView(); // An empty ListView when _mahasiswaList is null
                    }
                  },
                ),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.black,
        onPressed: () async {
          var result = await Navigator.of(context)
              .push(MaterialPageRoute(builder : (_) => CreateMahasiswaPage()));
          if (result == true){
            setState(() {
              _loading = true;
              fetchData();
            });
          }
          },
        child: Icon(Icons.add , color: Colors.white,)
      ),
    );
  }

  Future<void> _deleteMahasiswa(String id) async {
    final url =
        Uri.parse('https://irzanet.000webhostapp.com/api/api-hapus-mhs.php?id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('Response from server: $responseData');
        fetchData();
      } else {
        print('Failed to delete Mahasiswa. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }
}
