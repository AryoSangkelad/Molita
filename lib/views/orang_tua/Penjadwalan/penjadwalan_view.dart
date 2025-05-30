import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/widgets/imunisasi_content.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/widgets/posyandu_content.dart';
import 'package:provider/provider.dart';

class PenjadwalanView extends StatefulWidget {
  final String idOrangTua;
  final String idjenisPosyandu;
  const PenjadwalanView({
    Key? key,
    required this.idOrangTua,
    required this.idjenisPosyandu,
  }) : super(key: key);

  @override
  State<PenjadwalanView> createState() => _PenjadwalanViewState();
}

class _PenjadwalanViewState extends State<PenjadwalanView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final viewModel = Provider.of<PenjadwalanViewModal>(
          context,
          listen: false,
        );
        viewModel.init(widget.idOrangTua);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PenjadwalanViewModal>(context);
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Penjadwalan',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(60),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.grey[200],
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 12),
        //         child: Row(
        //           children: [
        //             Icon(Icons.search, color: Colors.grey[600]),
        //             SizedBox(width: 8),
        //             Expanded(
        //               child: TextField(
        //                 decoration: InputDecoration(
        //                   hintText: 'Cari Jadwal...',
        //                   border: InputBorder.none,
        //                   hintStyle: TextStyle(color: Colors.grey[600]),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Jenis Jadwal
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 228, 228, 228),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    viewModel.scheduleTypes.map((type) {
                      final bool isSelected =
                          type == viewModel.selectedScheduleType;
                      return Expanded(
                        child: GestureDetector(
                          onTap:
                              () => viewModel.setSelectedScheduleType(
                                type,
                                widget.idjenisPosyandu,
                              ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),

                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue[100]
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  type == 'imunisasi'
                                      ? Icons.child_care
                                      : Icons.local_hospital,
                                  size: 18,
                                  color:
                                      isSelected
                                          ? Colors.blue[800]
                                          : Colors.grey[600],
                                ),
                                SizedBox(width: 6),
                                Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isSelected
                                            ? Colors.blue[800]
                                            : Colors.grey[600],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Dropdown Pilih Anak (jika pilih imunisasi)
            if (viewModel.selectedScheduleType == 'imunisasi') ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue[800], size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Anak:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Anak>(
                          value: viewModel.selectedAnak,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue[800],
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          onChanged: (Anak? newValue) {
                            if (newValue != null) {
                              viewModel.setSelectedAnak(newValue);
                            }
                          },
                          items:
                              viewModel.daftarAnak.map<DropdownMenuItem<Anak>>((
                                Anak value,
                              ) {
                                return DropdownMenuItem<Anak>(
                                  value: value,
                                  child: Text(value.nama),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            // Konten Jadwal
            if (viewModel.isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child:
                    viewModel.selectedScheduleType == 'imunisasi'
                        ? buildImunisasiContent(viewModel)
                        : buildPosyanduContent(viewModel),
              ),
          ],
        ),
      ),
    );
  }
}