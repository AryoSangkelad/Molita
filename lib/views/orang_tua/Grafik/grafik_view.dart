import 'package:flutter/material.dart';

class GrafikView extends StatefulWidget {
  const GrafikView({super.key});

  @override
  State<GrafikView> createState() => _GrafikViewState();
}

class _GrafikViewState extends State<GrafikView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("GRAFIK")));
  }
}
