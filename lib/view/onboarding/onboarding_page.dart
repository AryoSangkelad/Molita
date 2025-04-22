import 'package:flutter/material.dart';
import 'package:molita_flutter/Viewmodels/onboarding_viewmodel.dart';

import 'package:provider/provider.dart';

import 'widgets/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  final PageController _controller = PageController();

  OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          final list = viewModel.onboardingList;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: list.length,
                      onPageChanged: viewModel.updatePage,
                      itemBuilder: (context, index) {
                        return OnboardingItem(model: list[index]);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      list.length,
                          (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: viewModel.currentIndex == index
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (viewModel.currentIndex == list.length - 1) {
                            Navigator.pushReplacementNamed(context, "/login"); // Ganti ke screen utama
                          } else {
                            viewModel.nextPage(_controller);
                          }
                        },
                        child: Text(
                          viewModel.currentIndex == list.length - 1 ? 'Mulai' : 'Selanjutnya',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
