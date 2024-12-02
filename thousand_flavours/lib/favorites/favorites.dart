import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15120D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/restaurant_pic.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Favorite Restaurants',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDFCE2),
                        fontFamily: 'Italiana',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFFDFCE2),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Add more content here as needed
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }
}