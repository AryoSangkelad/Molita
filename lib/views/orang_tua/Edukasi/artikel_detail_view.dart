import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_widgets/article_content.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_widgets/article_meta.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_widgets/hero_image.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_widgets/scroll_to_top_fab.dart';
import 'package:share_plus/share_plus.dart';

class ArtikelDetailView extends StatelessWidget {
  final ArtikelEdukasi artikel;
  final ScrollController _scrollController = ScrollController();

  ArtikelDetailView({Key? key, required this.artikel}) : super(key: key);

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
              background: buildHeroImage(artikel),
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
                  buildArticleMeta(theme, artikel),
                  const SizedBox(height: 24),
                  buildArticleContent(theme, artikel),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: buildScrollToTopFab(isScrolled, _scrollController),
    );
  }

  void _shareArticle(BuildContext context, String articleUrl) {
    SharePlus.instance.share(
      ShareParams(text: 'Baca artikel ini: http://10.0.2.2:8000'),
    );
  }
}
