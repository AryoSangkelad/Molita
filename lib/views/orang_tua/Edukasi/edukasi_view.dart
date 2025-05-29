import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
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
                  _buildFilterSection(primaryColor, viewModel),
                  const SizedBox(height: 20),
                  _buildCategoryFilter(primaryColor, viewModel),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _buildContentGrid(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(Color primaryColor, EdukasiViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromARGB(255, 228, 228, 228),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _FilterChip(
              label: 'Semua',
              icon: Icons.widgets_rounded,
              isSelected: viewModel.selectedType == 'Semua',
              onTap: () => viewModel.setSelectedType('Semua'),
            ),
            _FilterChip(
              label: 'Video',
              icon: Icons.play_circle_fill_rounded,
              isSelected: viewModel.selectedType == 'video',
              onTap: () => viewModel.setSelectedType('video'),
              color: Colors.red,
            ),
            _FilterChip(
              label: 'Artikel',
              icon: Icons.article_rounded,
              isSelected: viewModel.selectedType == 'artikel',
              onTap: () => viewModel.setSelectedType('artikel'),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(Color primaryColor, EdukasiViewModel viewModel) {
    return Row(
      children: [
        Icon(Icons.category_rounded, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          'Kategori:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: viewModel.selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryColor,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) viewModel.setSelectedCategory(newValue);
                },
                items: [
                  DropdownMenuItem(
                    value: 'Semua',
                    child: Text(
                      'Semua Kategori',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
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
        ),
      ],
    );
  }

  Widget _buildContentGrid(EdukasiViewModel viewModel) {
    final items = viewModel.getFilteredItems();

    return items.isEmpty
        ? SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada konten ditemukan',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          ),
        )
        : SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => EdukasiCard(
              item: items[index],
              onTap: () => _navigateToDetail(context, items[index]),
            ),
            childCount: items.length,
          ),
        );
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    if (item is ArtikelEdukasi) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtikelDetailScreen(artikel: item),
        ),
      );
    } else if (item is VideoEdukasi) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoDetailScreen(video: item)),
      );
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.primaryColor;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color:
              isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? primaryColor : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
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
    final theme = Theme.of(context);
    bool isVideo = item is VideoEdukasi;
    String thumbnailUrl =
        '${AppConstant.baseUrlFoto}${isVideo ? (item as VideoEdukasi).thumbnail : (item as ArtikelEdukasi).thumbnail}';
    String title =
        isVideo ? (item as VideoEdukasi).judul : (item as ArtikelEdukasi).judul;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildThumbnail(thumbnailUrl),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildContentOverlay(isVideo, title, theme),
              ),
              Positioned(top: 12, right: 12, child: _buildTypeBadge(isVideo)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value:
                  progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image_rounded, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildContentOverlay(bool isVideo, String title, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isVideo
                    ? Icons.play_circle_filled_rounded
                    : Icons.article_rounded,
                color: Colors.white70,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                isVideo ? 'Video Edukasi' : 'Artikel',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(bool isVideo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isVideo ? Colors.red[400] : Colors.green[400],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isVideo ? Icons.play_arrow_rounded : Icons.article_rounded,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isVideo ? 'VIDEO' : 'ARTICLE',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
