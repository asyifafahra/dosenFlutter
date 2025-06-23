import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateDosenPage extends StatefulWidget {
  final String no;

  const UpdateDosenPage({super.key, required this.no});

  @override
  State<UpdateDosenPage> createState() => _UpdateDosenPageState();
}

class _UpdateDosenPageState extends State<UpdateDosenPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool _isLoading = false;
  final String baseUrl = 'http://192.168.43.93:8000/api/dosen';

  @override
  void initState() {
    super.initState();
    fetchDosen();
  }

  @override
  void dispose() {
    namaController.dispose();
    teleponController.dispose();
    emailController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> fetchDosen() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/${widget.no}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          namaController.text = data['nama_lengkap'] ?? '';
          teleponController.text = data['no_telepon'] ?? '';
          emailController.text = data['email'] ?? '';
          alamatController.text = data['alamat'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data dosen')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> updateDosen() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${widget.no}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama_lengkap': namaController.text,
          'no_telepon': teleponController.text,
          'email': emailController.text,
          'alamat': alamatController.text,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // kembali ke list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal memperbarui data dosen')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Dosen'),
        backgroundColor: Colors.blue, // ✅ warna biru
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No Telepon'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      updateDosen();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // ✅ warna biru
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
