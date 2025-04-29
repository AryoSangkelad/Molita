import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/menu_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    MenuViewModel viewModel = Provider.of<MenuViewModel>(context);

    return Scaffold(
      body: viewModel.pages[viewModel.currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SalomonBottomBar(
          currentIndex: viewModel.currentIndex,
          onTap:
              (index) => setState(() {
                viewModel.setCurrentIndex(index);
              }),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[600],
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home_rounded, size: 28),
              title: Text(
                "Beranda",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              selectedColor: Colors.green,
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.calendar_month_rounded,
                size: 28,
              ), // ICON Penjadwalan
              title: Text(
                "Jadwal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.menu_book_rounded, size: 28), // ICON Edukasi
              title: Text(
                "Edukasi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.show_chart_rounded, size: 28), // ICON Grafik
              title: Text(
                "Grafik",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              selectedColor: Colors.orange,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.person_rounded, size: 28),
              title: Text(
                "Profil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
