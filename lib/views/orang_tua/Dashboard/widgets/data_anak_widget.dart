import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_chip_widget.dart';

Widget buildDataAnak(DashboardViewModel viewModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Data Anak",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                viewModel.children
                    .map(
                      (child) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 280,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      child.nama,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Icon(
                                      Icons.child_care,
                                      color: Color(0xFF1976D2),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text("Tanggal Lahir: ${child.tanggalLahir}"),
                                Text("Imunisasi: ${child.imunisasi}"),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildChip(
                                      "${child.beratBadan} kg",
                                      Colors.green,
                                    ),
                                    buildChip(
                                      "${child.tinggiBadan} cm",
                                      Colors.blue,
                                    ),
                                    buildChip(
                                      "${child.lingkarKepala} cm",
                                      Colors.pink,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    ],
  );
}
