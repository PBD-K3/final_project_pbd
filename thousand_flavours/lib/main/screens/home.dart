import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 18, 13),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'What are you craving?',
                  prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 222, 218, 181)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Gallery Section
              const Text(
                'GALLERY',
                style: TextStyle(
                  color: const Color.fromARGB(255, 222, 218, 181),
                  fontFamily: 'Italiana',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGalleryCard('Restaurant Name', 'Category - Rating'),
                    _buildGalleryCard('Restaurant Name', 'Category - Rating'),
                    _buildGalleryCard('Restaurant Name', 'Category - Rating'),
                    _buildGalleryCard('Restaurant Name', 'Category - Rating'),
                    _buildGalleryCard('Restaurant Name', 'Category - Rating'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Restaurant of the Month
              const Text(
                'RESTAURANT OF THE MONTH',
                style: TextStyle(
                  color: const Color.fromARGB(255, 222, 218, 181),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildRestaurantOfMonthCard(),

              const SizedBox(height: 20),

              // Categories Section
              const Text(
                'CATEGORIES',
                style: TextStyle(
                  color: const Color.fromARGB(255, 222, 218, 181),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCategoryCard('Seafood', Icons.restaurant),
                  _buildCategoryCard('Coffee & Snacks', Icons.local_cafe),
                  _buildCategoryCard('Indonesian', Icons.rice_bowl),
                  _buildCategoryCard('International', Icons.public),
                  _buildCategoryCard('Local Dishes', Icons.dining),
                ],
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: BottomNavWidget()
    );
  }

  Widget _buildGalleryCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantOfMonthCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Jukung Seafood',
              style: TextStyle(color: Colors.black, 
                  fontFamily: 'Italiana', 
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 222, 218, 181)),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, 
            fontFamily: 'Italiana',
            fontSize: 12),
          ),
        ],
      ),
    );
  }
}
