import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/detail_anak_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Anak/detail_anak_view.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_chip_widget.dart';
import 'package:provider/provider.dart';

Widget buildDataAnak(BuildContext context, DashboardViewModel viewModel) {
  final anakList = viewModel.getAllAnakByOrangTua();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          "Data Anak",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.grey.shade800,
            letterSpacing: 0.8,
          ),
        ),
      ),
      SizedBox(
        height: 180,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemCount: anakList.length,
          itemBuilder: (context, index) {
            final child = anakList[index];
            final isMale = child.jenisKelamin == "Laki-Laki";
            final genderColor =
                isMale
                    ? Colors.blueAccent.shade400
                    : Colors.pinkAccent.shade400;
            final theme = Theme.of(context);

            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 280,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              child.nama,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade800,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Icon(
                            isMale ? Icons.face_3 : Icons.face_4,
                            color: genderColor,
                            size: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(child.tanggalLahir),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: genderColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: genderColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isMale ? Icons.male : Icons.female,
                                  color: genderColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isMale ? "Laki-laki" : "Perempuan",
                                  style: TextStyle(
                                    color: genderColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    final viewModel = DetailAnakViewModel();
                                    viewModel.fetchDetailAnak(
                                      child.id,
                                    ); // Ganti dengan ID yang benar
                                    return ChangeNotifierProvider.value(
                                      value: viewModel,
                                      child: const DetailAnakView(),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
