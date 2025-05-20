import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:provider/provider.dart';
import 'artikel_detail_screen.dart';
import 'video_detail_screen.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edukasi Molita',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari materi edukasi...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Button
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleButton(
                    isSelected: viewModel.selectedType == 'Semua',
                    onPressed: () => viewModel.setSelectedType('Semua'),
                    icon: Icons.dashboard,
                    label: 'Semua',
                  ),
                  ToggleButton(
                    isSelected: viewModel.selectedType == 'video',
                    onPressed: () => viewModel.setSelectedType('video'),
                    icon: Icons.video_library,
                    label: 'Video',
                  ),
                  ToggleButton(
                    isSelected: viewModel.selectedType == 'artikel',
                    onPressed: () => viewModel.setSelectedType('artikel'),
                    icon: Icons.article,
                    label: 'Artikel',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Category Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.category, color: Colors.blue[800], size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Kategori:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: viewModel.selectedCategory,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue[800],
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            viewModel.setSelectedCategory(newValue);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'Semua',
                            child: Text('Semua'),
                          ),
                          ...viewModel.categories.map(
                            (category) => DropdownMenuItem(
                              value: category.judul,
                              child: Text(category.judul),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Content Grid
            if (viewModel.getFilteredItems().isEmpty)
              Center(child: Text('Tidak ada konten ditemukan'))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: viewModel.getFilteredItems().length,
                itemBuilder: (context, index) {
                  final item = viewModel.getFilteredItems()[index];
                  return EdukasiCard(
                    item: item,
                    onTap: () {
                      if (item is ArtikelEdukasi) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ArtikelDetailScreen(artikel: item),
                          ),
                        );
                      } else if (item is VideoEdukasi) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VideoDetailScreen(video: item),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const ToggleButton({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[100] : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.blue[800] : Colors.grey[600],
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.blue[800] : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EdukasiCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const EdukasiCard({Key? key, required this.item, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String thumbnailUrl = '';
    String title = '';
    String typeLabel = '';
    Color typeColor = Colors.transparent;

    if (item is ArtikelEdukasi) {
      thumbnailUrl = '${ApiConstant.baseUrl}storage/${item.thumbnail}';
      title = item.judul;
      typeLabel = 'Artikel';
      typeColor = Colors.green[100]!;
    } else if (item is VideoEdukasi) {
      thumbnailUrl = '${ApiConstant.baseUrl}storage/${item.thumbnail}';
      title = item.judul;
      typeLabel = 'Video';
      typeColor = Colors.red[100]!;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                thumbnailUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            typeLabel == 'Video'
                                ? Colors.red[800]
                                : Colors.green[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
