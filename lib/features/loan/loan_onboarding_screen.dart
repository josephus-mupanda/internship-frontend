import 'package:flutter/material.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/preferences.dart';

class LoanOnboardingScreen extends StatefulWidget {
  final VoidCallback onboardingComplete;

  const LoanOnboardingScreen({
    super.key,
    required this.onboardingComplete
  });

  @override
  State<LoanOnboardingScreen> createState() => _LoanOnboardingScreenState();
}

class _LoanOnboardingScreenState extends State<LoanOnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        constraints: const BoxConstraints(maxWidth: Constants.kMaxWidth),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            child: Container(
                              height: size.height,
                              width: size.width,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(Constants.kDefaultPadding),
                                        child: Card(
                                          color: Theme.of(context).cardColor,
                                          child: Column(
                                            children: <Widget>[
                                              const SizedBox(height: Constants.kDefaultPadding / 2),
                                              Flexible(
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    PageView(
                                                      onPageChanged: (int page) {
                                                        setState(() {
                                                          currentIndex = page;
                                                        });
                                                      },
                                                      controller: _pageController,
                                                      children: [
                                                        CreatePage(
                                                          icon: Icons.request_page,
                                                          title: Constants.loanTitleOne,
                                                          description: Constants.loanDescriptionOne,
                                                        ),
                                                        CreatePage(
                                                          icon: Icons.attach_money,
                                                          title: Constants.loanTitleTwo,
                                                          description: Constants.loanDescriptionTwo,
                                                        ),
                                                        CreatePage(
                                                          icon: Icons.history,
                                                          title: Constants.loanTitleThree,
                                                          description: Constants.loanDescriptionThree,
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      bottom: 80,
                                                      left: 30,
                                                      child: Row(
                                                        children: _buildIndicator(),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 60,
                                                      right: 30,
                                                      child: Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Theme.of(context).primaryColor, // Using theme color
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(()  async {
                                                              if (currentIndex < 2) {
                                                                currentIndex++;
                                                                _pageController.nextPage(
                                                                  duration: const Duration(milliseconds: 300),
                                                                  curve: Curves.easeIn,
                                                                );
                                                              } else {
                                                                widget.onboardingComplete();
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.arrow_forward_ios,
                                                            size: 24,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Create the indicator decorations widget
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // Use theme color
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // Create the indicator list
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}

class CreatePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const CreatePage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Icon(icon),
            ),
            const SizedBox(
              height: Constants.kDefaultPadding,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: Constants.kDefaultPadding,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: Constants.kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
