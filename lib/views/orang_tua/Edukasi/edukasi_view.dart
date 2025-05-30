import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/category_filter.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/content_grid.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/filter_section.dart';
import 'package:provider/provider.dart';

class EdukasiView extends StatefulWidget {
  const EdukasiView({Key? key}) : super(key: key);

  @override
  State<EdukasiView> createState() => _EdukasiViewState();
}

class _EdukasiViewState extends State<EdukasiView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final viewModel = Provider.of<EdukasiViewModel>(context, listen: false);
        viewModel.loadData();
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EdukasiViewModel>(context);
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Edukasi Molita',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(80),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        //     child: Material(
        //       elevation: 2,
        //       borderRadius: BorderRadius.circular(16),
        //       child: TextField(
        //         decoration: InputDecoration(
        //           filled: true,
        //           fillColor: Colors.white,
        //           hintText: 'Cari materi edukasi...',
        //           prefixIcon: Icon(
        //             Icons.search_rounded,
        //             color: Colors.grey[600],
        //           ),
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(16),
        //             borderSide: BorderSide.none,
        //           ),
        //           contentPadding: const EdgeInsets.symmetric(vertical: 14),
        //           hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  buildFilterSection(primaryColor, viewModel),
                  const SizedBox(height: 20),
                  buildCategoryFilter(primaryColor, viewModel),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            buildContentGrid(viewModel),
          ],
        ),
      ),
    );
  }

  
}


