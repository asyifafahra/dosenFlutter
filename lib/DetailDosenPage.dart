import 'package:flutter/material.dart';
import 'package:list_dosen/model/modelDosen.dart';

class DetailDosenPage extends StatelessWidget {
  final ModelDosen dosen;

  const DetailDosenPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Dosen'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Nama
                Text(
                  dosen.namaLengkap,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const Divider(height: 30, thickness: 1.2),

                // Detail List
                _buildDetailTile(Icons.badge, 'NIP', dosen.nip),
                _buildDetailTile(Icons.phone, 'No. Telepon', dosen.noTelepon),
                _buildDetailTile(Icons.email, 'Email', dosen.email),
                _buildDetailTile(Icons.home, 'Alamat', dosen.alamat),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        value.isEmpty ? '-' : value,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
