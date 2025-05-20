// import 'package:flutter/material.dart';
// import 'package:molita_flutter/viewmodels/orang_tua/menu_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';

// class MenuView extends StatefulWidget {
//   const MenuView({super.key});

//   @override
//   State<MenuView> createState() => _MenuViewState();
// }

// class _MenuViewState extends State<MenuView> {
//   @override
//   Widget build(BuildContext context) {
//     MenuViewModel viewModel = Provider.of<MenuViewModel>(context);

//     return Scaffold(
//       body: viewModel.pages[viewModel.currentIndex],
//       bottomNavigationBar: StyleProvider(
//         style: CustomStyle(),
//         child: ConvexAppBar(
//           height: 75,
//           style: TabStyle.fixedCircle,
//           backgroundColor: const Color(0xFF1D1D1D),
//           activeColor: Color(0xFF539DF3),
//           color: Colors.white54,
//           items: const [
//             TabItem(icon: Icons.calendar_month_rounded, title: "Jadwal"),
//             TabItem(icon: Icons.menu_book_rounded, title: "Edukasi"),
//             TabItem(icon: Icons.home, title: "Beranda"),
//             TabItem(icon: Icons.show_chart_rounded, title: "Grafik"),
//             TabItem(icon: Icons.person_rounded, title: "Profil"),
//           ],
//           initialActiveIndex: 2,
//           onTap: (index) {
//             setState(() {
//               viewModel.setCurrentIndex(index);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

// class CustomStyle extends StyleHook {
//   @override
//   double get activeIconSize => 40;

//   @override
//   double get activeIconMargin => 10;

//   @override
//   double get iconSize => 24;

//   @override
//   TextStyle textStyle(Color color, String? label) {
//     return TextStyle(fontSize: 12, color: color);
//   }
// }

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
    final screenWidth = MediaQuery.of(context).size.width;

    double scale(double value) =>
        value * screenWidth / 375; // 375 = width iPhone 11 sebagai referensi
    MenuViewModel viewModel = Provider.of<MenuViewModel>(context);

    if (viewModel.isLoading || viewModel.pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: viewModel.pages[viewModel.currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          child: SalomonBottomBar(
            currentIndex: viewModel.currentIndex,
            onTap:
                (index) => setState(() {
                  viewModel.setCurrentIndex(index);
                }),
            margin: EdgeInsets.symmetric(
              vertical: scale(12),
              horizontal: scale(16),
            ),
            itemPadding: EdgeInsets.symmetric(
              vertical: scale(10),
              horizontal: scale(16),
            ),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey[600],
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home_rounded, size: scale(24)),
                title: Text(
                  "Beranda",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: scale(13),
                  ),
                ),
                selectedColor: Colors.green,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.calendar_month_rounded, size: scale(24)),
                title: Text(
                  "Jadwal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: scale(13),
                  ),
                ),
                selectedColor: Colors.purple,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.menu_book_rounded, size: scale(24)),
                title: Text(
                  "Edukasi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: scale(13),
                  ),
                ),
                selectedColor: Colors.blue,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.show_chart_rounded, size: scale(24)),
                title: Text(
                  "Grafik",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: scale(13),
                  ),
                ),
                selectedColor: Colors.orange,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.person_rounded, size: scale(24)),
                title: Text(
                  "Profil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: scale(13),
                  ),
                ),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
