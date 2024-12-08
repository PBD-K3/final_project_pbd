import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousand_flavours/authentication/screens/login.dart';
import 'package:thousand_flavours/main/screens/home.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  // Store the currently visible page
  int _currentPage = 0;

  // Define a controller for the PageView
  final PageController _pageController = PageController(initialPage: 0);

  // Define the content for the onboarding pages
  final List<Map<String, dynamic>> pages = [
    {
      'description': "In the middle of a forgotten corner of Nusantara...",
      'textColor': const Color.fromARGB(255, 236, 225, 180),
    },
    {
      'description': "... lies a hotspot of cultural cuisine, a place of ...",
      'textColor': const Color.fromARGB(255, 236, 225, 180),
    },
    {
      'image': 'assets/ATF_logo.png', // Image for the third page
    },
  ];

  void navigateBasedOnAuth(CookieRequest request) {
    // Check if the user is authenticated and navigate accordingly
    if (request.loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Shared Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/cover.png', // Path to your background image
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          // Main Onboarding Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  // PageView to render each page
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      // Update current page when the page view changes
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return Center(
                        child: page.containsKey('image')
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Image.asset(
                                  page[
                                      'image'], // Display the image for the third page
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Page Description
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Text(
                                      page['description'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: page['textColor'],
                                        fontFamily: 'Italiana',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
                // Current page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pages.asMap().entries.map((entry) {
                    int index = entry.key;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _currentPage == index ? 16 : 8,
                      height: 8,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    );
                  }).toList(),
                ),
                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      TextButton(
                        onPressed: () => navigateBasedOnAuth(request),
                        child: const Text(
                          "Skip",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // Next/Finish Button
                      TextButton(
                        onPressed: () {
                          if (_currentPage == pages.length - 1) {
                            // Navigate based on auth status on Finish
                            navigateBasedOnAuth(request);
                          } else {
                            // Navigate to next page
                            _pageController.animateToPage(
                              _currentPage + 1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          _currentPage == pages.length - 1 ? "Finish" : "Next",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
