import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:share_plus/share_plus.dart';

class ArtikelDetailScreen extends StatelessWidget {
  final ArtikelEdukasi artikel;
  final ScrollController _scrollController = ScrollController();

  ArtikelDetailScreen({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isScrolled =
        _scrollController.hasClients &&
        _scrollController.offset > (mediaQuery.size.height * 0.25);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: mediaQuery.size.height * 0.3,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildHeroImage(),
              title: isScrolled ? Text(artikel.judul) : null,
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () => _shareArticle(context, artikel.slug),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArticleMeta(theme),
                  const SizedBox(height: 24),
                  _buildArticleContent(theme),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildScrollToTopFab(isScrolled),
    );
  }

  Widget _buildHeroImage() {
    return Hero(
      tag: artikel.idArtikel,
      child: Image.network(
        '${AppConstant.baseUrlFoto}${artikel.thumbnail}',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.article_rounded,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildArticleMeta(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          artikel.judul,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildMetaChip(
              icon: Icons.category_rounded,
              label: artikel.jenisEdukasi.judul,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleContent(ThemeData theme) {
    return Html(
      data: artikel.konten,
      style: {
        "body": Style(
          fontSize: FontSize(16.5),
          lineHeight: LineHeight(1.7),
          color: Colors.grey[700],
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ),
        "h1": Style(
          fontSize: FontSize.xxLarge,
          fontWeight: FontWeight.w800,
          color: Colors.grey[900],
          margin: Margins.only(bottom: 12, top: 24),
        ),
        "h2": Style(
          fontSize: FontSize.xLarge,
          fontWeight: FontWeight.w700,
          color: Colors.grey[900],
          margin: Margins.only(bottom: 12, top: 20),
        ),
        "p": Style(
          margin: Margins.only(bottom: 20),
          textAlign: TextAlign.justify,
        ),
        "img": Style(
          width: Width(100, Unit.percent),
          margin: Margins.symmetric(vertical: 20),
          alignment: Alignment.center,
        ),
        "ul": Style(margin: Margins.only(left: 20, bottom: 20)),
        "li": Style(
          margin: Margins.only(bottom: 8),
          padding: HtmlPaddings.zero,
        ),
        "a": Style(
          color: theme.colorScheme.secondary,
          textDecoration: TextDecoration.none,
        ),
        "blockquote": Style(
          padding: HtmlPaddings.symmetric(horizontal: 20, vertical: 16),
          margin: Margins.only(bottom: 20),
          backgroundColor: Colors.grey[50],
          border: Border(
            left: BorderSide(color: theme.colorScheme.secondary, width: 4),
          ),
        ),
      },
      onLinkTap: (url, _, __) => _launchUrl(url),
    );
  }

  Widget _buildMetaChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollToTopFab(bool isScrolled) {
    return AnimatedOpacity(
      opacity: isScrolled ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed:
            () => _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
        child: Icon(Icons.arrow_upward_rounded, color: Colors.grey[800]),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _shareArticle(BuildContext context, String articleUrl) {
    SharePlus.instance.share(
      ShareParams(text: 'Baca artikel ini: http://10.0.2.2:8000'),
    );
  }

  void _launchUrl(String? url) {
    // Implement url launching
  }
}
