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
import 'package:flutter_html/flutter_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/kategori_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pengaduan_viewmodel.dart';
import 'package:provider/provider.dart';

class PengaduanView extends StatefulWidget {
  final String idOrangTua;
  const PengaduanView({super.key, required this.idOrangTua});
  @override
  _PengaduanViewState createState() => _PengaduanViewState();
}

class _PengaduanViewState extends State<PengaduanView> {
  final _formKey = GlobalKey<FormState>();
  String judul = '';
  String deskripsi = '';
  int? kategoriId;
  File? lampiran;
  final picker = ImagePicker();

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        lampiran = File(picked.path);
      });
    }
  }

  void _showFormModal(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context, listen: false);
    final pengaduanVM = Provider.of<PengaduanViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder:
          (_) => Padding(
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
                    _buildInputField(
                      label: 'Judul Pengaduan',
                      hint: 'Masukkan judul pengaduan',
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Judul harus diisi' : null,
                      onSaved: (value) => judul = value!,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      label: 'Deskripsi',
                      hint: 'Jelaskan pengaduan Anda secara detail',
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
                    _buildCategoryDropdown(kategoriVM),
                    SizedBox(height: 24),
                    _buildAttachmentSection(),
                    SizedBox(height: 32),
                    _buildSubmitButton(pengaduanVM),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
          onSaved: onSaved,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(KategoriViewModel kategoriVM) {
    return Container(
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
                    child: Text(kategori.nama, style: TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
        onChanged: (val) {
          setState(() {
            kategoriId = val;
          });
        },
        validator: (value) => value == null ? 'Pilih kategori' : null,
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        hint: Text('Pilih Kategori', style: TextStyle(color: Colors.grey[500])),
        borderRadius: BorderRadius.circular(10),
        isExpanded: true,
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
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
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.attach_file, color: Colors.blue[800], size: 28),
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
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
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
    );
  }

  Widget _buildSubmitButton(PengaduanViewModel pengaduanVM) {
    return SizedBox(
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
                    final success = await pengaduanVM.submitPengaduan(
                      pengaduan,
                      lampiran: lampiran,
                    );
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pengaduan berhasil dikirim!'),
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
    );
  }

  void _showDetailBottomSheet(Pengaduan item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicator
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
                  const SizedBox(height: 20),

                  // Judul + Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.judul,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      _buildStatusChip(item.status ?? 'Menunggu'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Detail Item
                  _buildDetailItem(
                    title: 'Kategori',
                    content: item.namaKategori ?? '-',
                  ),
                  _buildDetailItem(
                    title: 'Tanggal',
                    content: formatTanggal(item.createdAt),
                  ),
                  _buildDetailItem(title: 'Deskripsi', content: item.deskripsi),

                  // Lampiran
                  if (item.lampiranUrl != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Lampiran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.lampiranUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Tanggapan pakai Html
                  _buildDetailItemHtml(
                    title: 'Tanggapan',
                    content: item.tanggapan ?? "-",
                    isLast: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItemHtml({
    required String title,
    required String content,
    bool isLast = false,
  }) {
    print(content);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Html(
            data: content,
            style: {
              "body": Style(
                fontSize: FontSize(16),
                color: Colors.grey[800],
                margin: Margins.all(0),
                padding: HtmlPaddings.all(0),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'selesai':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'diproses':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
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
      body: _buildContent(pengaduanVM),
    );
  }

  Widget _buildContent(PengaduanViewModel pengaduanVM) {
    if (pengaduanVM.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (pengaduanVM.pengaduanList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Belum ada pengaduan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Tekan tombol di bawah untuk membuat pengaduan baru',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      physics: BouncingScrollPhysics(),
      itemCount: pengaduanVM.pengaduanList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = pengaduanVM.pengaduanList[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetailBottomSheet(item),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.judul,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    _buildStatusChip(item.status ?? 'Menunggu'),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  item.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], height: 1.4),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      item.namaKategori ?? '-',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      formatTanggal(item.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatTanggal(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat(
        'd MMMM yyyy',
        'id_ID',
      ).format(date); // Contoh: 25 Mei 2025
    } catch (_) {
      return '-';
    }
  }
}
