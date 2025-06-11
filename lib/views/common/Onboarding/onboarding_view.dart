import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molita_flutter/viewmodels/common/onboarding_viewmodel.dart';
import 'package:molita_flutter/views/common/Onboarding/onboarding_widgets/onboarding_item.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  final PageController _controller = PageController();

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          final list = viewModel.onboardingList;
          final screenHeight = MediaQuery.of(context).size.height;

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE1F5FE), Colors.white],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          child: Text(
                            'Lewati',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // PageView for onboarding content
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: list.length,
                        onPageChanged: viewModel.updatePage,
                        itemBuilder: (context, index) {
                          return buildOnboardingItem(list[index], screenHeight);
                        },
                      ),
                    ),

                    // Page indicator dots
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          list.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: viewModel.currentIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  viewModel.currentIndex == index
                                      ? Colors.blue[700]
                                      : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Next/Start button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (viewModel.currentIndex == list.length - 1) {
                              Navigator.pushReplacementNamed(context, "/login");
                            } else {
                              viewModel.nextPage(_controller);
                            }
                          },
                          child: Text(
                            viewModel.currentIndex == list.length - 1
                                ? 'Mulai Sekarang'
                                : 'Selanjutnya',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
