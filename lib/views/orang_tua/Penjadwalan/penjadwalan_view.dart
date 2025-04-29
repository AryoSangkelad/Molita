import 'package:flutter/material.dart';

class PenjadwalanView extends StatefulWidget {
  const PenjadwalanView({super.key});

  @override
  State<PenjadwalanView> createState() => _PenjadwalanViewState();
}

class _PenjadwalanViewState extends State<PenjadwalanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("PENJADWALAN")));
  }
}
