import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, viewModel.username),
            _buildJadwalPosyandu(),
            _buildDataAnak(viewModel),
            _buildEdukasiTerbaru(viewModel),
            _buildInformasiKesehatan(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1976D2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hai, $name!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          Text("Yuk, pastikan kesehatan anak terjamin!", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Ada yang bisa dibantu ?',
              hintStyle: TextStyle(color: Colors.blueGrey),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJadwalPosyandu() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF2196F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: const [
            Row(children: [Icon(Icons.local_hospital, color: Colors.white), SizedBox(width: 8), Text("Melati 29", style: TextStyle(color: Colors.white))]),
            Row(children: [Icon(Icons.calendar_today, color: Colors.white), SizedBox(width: 8), Text("Senin, 2 Desember 2024", style: TextStyle(color: Colors.white))]),
            Row(children: [Icon(Icons.access_time, color: Colors.white), SizedBox(width: 8), Text("08:10 - 10:30", style: TextStyle(color: Colors.white))]),
          ],
        ),
      ),
    );
  }

  Widget _buildDataAnak(DashboardViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Anak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...vm.children.map((child) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Tanggal Lahir: ${child.birthDate}"),
                  Text("Imunisasi: ${child.immunization}"),
                  Row(
                    children: [
                      _buildChip("${child.weight} kg", Colors.amber),
                      _buildChip("${child.height} cm", Colors.blue),
                      _buildChip("${child.headCircumference} cm", Colors.pink),
                    ],
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: TextStyle(color: color)),
    );
  }

  Widget _buildEdukasiTerbaru(DashboardViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Edukasi Terbaru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vm.educationItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final item = vm.educationItems[index];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.description, maxLines: 3, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: Text("Selengkapnya")),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInformasiKesehatan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Informasi Kesehatan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          // Replace with Carousel or Image if needed
          Placeholder(fallbackHeight: 120),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Edukasi'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Grafik'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
