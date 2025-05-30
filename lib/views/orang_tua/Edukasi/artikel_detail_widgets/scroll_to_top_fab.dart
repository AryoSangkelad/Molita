import 'package:flutter/material.dart';

Widget buildScrollToTopFab(bool isScrolled, ScrollController scrollController) {
    return AnimatedOpacity(
      opacity: isScrolled ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed:
            () => scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
        child: Icon(Icons.arrow_upward_rounded, color: Colors.grey[800]),
      ),
    );
  }

  