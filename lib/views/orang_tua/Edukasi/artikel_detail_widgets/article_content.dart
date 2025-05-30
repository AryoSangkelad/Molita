import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';

Widget buildArticleContent(ThemeData theme, ArtikelEdukasi artikel) {
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
      "li": Style(margin: Margins.only(bottom: 8), padding: HtmlPaddings.zero),
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

void _launchUrl(String? url) {
  // Implement url launching
}
