// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PengaduanView extends StatelessWidget {
//   const PengaduanView({super.key});

//   void _launchUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (!await launchUrl(uri)) {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pengaduan"),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Hubungi Kami melalui:"),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () => _launchUrl('https://cs.molita.org'),
//               icon: const Icon(Icons.support_agent),
//               label: const Text("Customer Service"),
//             ),
//             ElevatedButton.icon(
//               onPressed: () => _launchUrl('https://molita.org'),
//               icon: const Icon(Icons.language),
//               label: const Text("Website"),
//             ),
//             ElevatedButton.icon(
//               onPressed: () => _launchUrl('https://instagram.com/molita.app'),
//               icon: const Icon(Icons.photo_camera),
//               label: const Text("Instagram"),
//             ),
//             ElevatedButton.icon(
//               onPressed: () => _launchUrl('https://wa.me/628123456789'),
//               icon: const Icon(Icons.chat),
//               label: const Text("WhatsApp"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/kategori_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pengaduan_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/content.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/input_field.dart';
import 'package:provider/provider.dart';

class PengaduanView extends StatefulWidget {
  final String idOrangTua;
  const PengaduanView({super.key, required this.idOrangTua});
  @override
  _PengaduanViewState createState() => _PengaduanViewState();
}

class _PengaduanViewState extends State<PengaduanView> {
  // Pindahkan variabel state ke sini agar tetap hidup
  // bahkan ketika modal ditutup
  String judul = '';
  String deskripsi = '';
  int? kategoriId;
  File? lampiran;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<KategoriViewModel>(context, listen: false).fetchKategori();
      Provider.of<PengaduanViewModel>(
        context,
        listen: false,
      ).fetchPengaduanList(idOrangTua: widget.idOrangTua);
    });
  }

  Future<void> _pickImage(StateSetter setStateModal) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setStateModal(() {
        lampiran = File(picked.path);
      });
    }
  }

  void _showFormModal(BuildContext context) {
    // Reset state form saat modal dibuka, jika ingin memulai dari awal
    // Namun, jika ingin mempertahankan nilai, jangan reset di sini.
    // Untuk kasus ini, kita ingin mempertahankan nilai.

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        final kategoriVM = Provider.of<KategoriViewModel>(
          context,
          listen: false,
        );
        final pengaduanVM = Provider.of<PengaduanViewModel>(
          context,
          listen: false,
        );
        final _formKey =
            GlobalKey<FormState>(); // FormKey juga di dalam builder

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 16,
                right: 16,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Buat Pengaduan Baru',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 24),
                      buildInputField(
                        label: 'Judul Pengaduan',
                        hint: 'Masukkan judul pengaduan',
                        initialValue: judul, 
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Judul harus diisi' : null,
                        onSaved: (value) => judul = value!,
                      ),
                      SizedBox(height: 16),
                      buildInputField(
                        label: 'Deskripsi',
                        hint: 'Jelaskan pengaduan Anda secara detail',
                        initialValue: deskripsi, // Tambahkan initialValue
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Deskripsi harus diisi' : null,
                        onSaved: (value) => deskripsi = value!,
                        maxLines: 4,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          value: kategoriId,
                          items:
                              kategoriVM.kategoriList
                                  .map(
                                    (kategori) => DropdownMenuItem<int>(
                                      value: kategori.id,
                                      child: Text(
                                        kategori.nama,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            setStateModal(() {
                              // Gunakan setStateModal
                              kategoriId = val;
                            });
                          },
                          validator:
                              (value) =>
                                  value == null ? 'Pilih kategori' : null,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[600],
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                          hint: Text(
                            'Pilih Kategori',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          isExpanded: true,
                        ),
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lampiran',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Hanya tampil jika lampiran belum ada
                          if (lampiran == null)
                            InkWell(
                              onTap:
                                  () => _pickImage(
                                    setStateModal,
                                  ), // Gunakan setStateModal
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: Colors.blue[800],
                                      size: 28,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tambahkan Foto',
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Jika lampiran ada, tampilkan preview dan tombol hapus
                          if (lampiran != null) ...[
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    lampiran!,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setStateModal(() {
                                          // Gunakan setStateModal
                                          lampiran = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              pengaduanVM.isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      final pengaduan = Pengaduan(
                                        idOrangTua: widget.idOrangTua,
                                        judul: judul,
                                        deskripsi: deskripsi,
                                        kategoriId: kategoriId!,
                                      );
                                      final success = await pengaduanVM
                                          .submitPengaduan(
                                            pengaduan,
                                            lampiran: lampiran,
                                          );
                                      if (success) {
                                        Navigator.pop(context);
                                        // Reset state setelah pengiriman sukses
                                        setState(() {
                                          judul = '';
                                          deskripsi = '';
                                          kategoriId = null;
                                          lampiran = null;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Pengaduan berhasil dikirim!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              pengaduanVM.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    'Kirim Pengaduan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pengaduanVM = Provider.of<PengaduanViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Pengaduan Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormModal(context),
        backgroundColor: Colors.blue[800],
        icon: Icon(Icons.add, size: 24, color: Colors.white),
        label: Text('Buat Pengaduan', style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      body: buildContent(context, pengaduanVM),
    );
  }
}
