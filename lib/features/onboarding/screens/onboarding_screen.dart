import 'package:flutter/material.dart';
import 'package:internship_frontend/features/onboarding/screens/page_right_screen.dart';
import 'package:internship_frontend/routes/app_routes.dart';
import 'package:monalystics/config/routes/routes.dart';
import '../../../core/layout/responsive_widget.dart';
import '../../config/constants.dart';
import '../../config/style/fonts.dart';
import '../../config/values/values.dart';
import '../../responsive.dart';
import '../login/components/page_right_side.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  AnimationController? rippleController;
  Animation<double>? rippleAnimation;
  int currentIndex = 0;


  // @override
  // void initState() {
  //   rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  //   rippleAnimation = Tween<double>(begin: 45.0, end: 50.0)
  //       .animate(rippleController!)
  //     ..addStatusListener((status) {
  //       if (status == AnimationStatus.completed) {
  //         rippleController!.reverse();
  //       } else if (status == AnimationStatus.dismissed) {
  //         rippleController!.forward();
  //       }
  //     });
  //
  //   rippleController!.forward();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context, AppRoutes.login);
              }, //to login screen. We will update later
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        constraints: const BoxConstraints(maxWidth: kMaxWidth),
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
                                        padding: const EdgeInsets.all(20.0),
                                        child: Card(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          child: Column(
                                            children: <Widget>[
                                              const SizedBox(height: kDefaultPadding / 2),
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
                                                          image: 'assets/images/plant-one.png',
                                                          title: Constants.titleOne,
                                                          description: Constants.descriptionOne,
                                                        ),
                                                        CreatePage(
                                                          image: 'assets/images/plant-two.png',
                                                          title: Constants.titleTwo,
                                                          description: Constants.descriptionTwo,
                                                        ),
                                                        CreatePage(
                                                          image: 'assets/images/plant-three.png',
                                                          title: Constants.titleThree,
                                                          description: Constants.descriptionThree,
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
                                                          color: Constants.primaryColor,
                                                        ),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                if (currentIndex < 2) {
                                                                  currentIndex++;
                                                                  if (currentIndex < 3) {
                                                                    _pageController.nextPage(
                                                                        duration: const Duration(milliseconds: 300),
                                                                        curve: Curves.easeIn);
                                                                  }
                                                                } else {
                                                                  Navigator.pushReplacement(context,
                                                                      MaterialPageRoute(builder: (_) => const SignIn()));
                                                                }
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons.arrow_forward_ios,
                                                              size: 24,
                                                              color: Colors.white,
                                                            )
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
                                  if (ResponsiveWidget.isDesktop(context))
                                    const PageRightSide(
                                      title: "Dear user,\n  explore these onboarding screens. 🤝",
                                      icon: "assets/images/svg/register.svg",
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

  Container _onBoardingScreen(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: kDefaultPadding / 2),
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    child: PageView(
                      controller: _pageController,
                      children: <Widget>[
                        onBoardingItem(
                          Icons.wifi,
                          "Social Media Analysis",
                          "Stay ahead with live analytics on engagement, reach, and sentiment. Track competitor analysis, customer trends, and industry shifts, all in one place. Get customized dashboards and reports to track what matters most to your business.",
                          context,
                        ),
                        onBoardingItem(
                          Icons.manage_search_rounded,
                          "Market research",
                          "Uncover market trends & competitor insights in seconds and make informed decisions.",
                          context,
                        ),
                        onBoardingItem(
                          Icons.person_search,
                          "Influencer Marketing",
                          "Effortlessly identify, connect, and manage influencer partnerships for your brand. No matter where your business sets its sights, connect with authentic voices that resonate with your target audience. Collaborate with Instagram influencers, bloggers, YouTubers, and more.",
                          context,
                        ),
                      ],
                      onPageChanged: (value) {
                        currentIndex = value;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => getIndicator(index))),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (currentIndex == 2) {
                  Navigator.pushReplacementNamed(context, AppRoutes.chooseAccount);
                } else {
                  _pageController.animateToPage(currentIndex + 1,
                      duration: const Duration(milliseconds: 100), curve: Curves.linear);
                }
              },
              child: AnimatedBuilder(
                animation: rippleAnimation!,
                builder: (_, child) => Container(
                  width: rippleAnimation!.value,
                  height: rippleAnimation!.value,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    shape: currentIndex == 2 ? BoxShape.rectangle : BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: currentIndex == 2
                      ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: kDefaultPadding / 2),
                            Text(
                              "Get Started".toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 30,
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                          ],
                        ),
                      )
                      : Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Create the indicator decorations widget
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//Create the indicator list
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
  // AnimatedContainer getIndicator(int pageNumerotation) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 300),
  //     height: kDefaultPadding / 2,
  //     width: (currentIndex == pageNumerotation) ? kDefaultPadding : kDefaultPadding / 2,
  //     margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(5.0),
  //       color: (currentIndex == pageNumerotation)
  //           ? Theme.of(context).primaryColor
  //           : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
  //     ),
  //   );
  // }
  //
  // ListView onBoardingItem(IconData iconData, String title, String description, BuildContext context) {
  //   return ListView(
  //     children: <Widget>[
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Container(
  //             height: 80,
  //             width: 80,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
  //             ),
  //             child: Icon(
  //               iconData,
  //               color: Theme.of(context).colorScheme.secondary,
  //               size: 50,
  //             ),
  //           ),
  //           Container(
  //             padding: const EdgeInsets.symmetric(vertical: 20),
  //             child: Text(
  //               title,
  //               style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40.0),
  //             child: Text(
  //               description,
  //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}

class CreatePage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const CreatePage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 350,
            child: Image.asset(image),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            // Use the predefined theme style for body text
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

