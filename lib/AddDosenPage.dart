import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDosenPage extends StatefulWidget {
  const AddDosenPage({super.key});

  @override
  State<AddDosenPage> createState() => _AddDosenPageState();
}

class _AddDosenPageState extends State<AddDosenPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final response = await http.post(
        Uri.parse('http://192.168.43.93:8000/api/dosen'),
        body: {
          'nama_lengkap': namaController.text,
          'nip': nipController.text,
          'no_telepon': teleponController.text,
          'email': emailController.text,
          'alamat': alamatController.text,
        },
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal menambahkan dosen')),
        );
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    nipController.dispose();
    teleponController.dispose();
    emailController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Dosen"),
        backgroundColor: Colors.blueAccent,
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
                validator: (value) =>
                value!.isEmpty ? 'Masukkan nama lengkap' : null,
              ),
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan NIP' : null,
              ),
              TextFormField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
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
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
