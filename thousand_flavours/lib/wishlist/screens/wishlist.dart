import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';
import 'package:thousand_flavours/main/screens/restaurant_details.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlist = [];

  // Function to add/remove a restaurant from the wishlist
  void _toggleBookmark(Map<String, dynamic> restaurant) {
    setState(() {
      bool isAlreadyBookmarked = wishlist.any((r) => r['title'] == restaurant['title']);
      
      if (isAlreadyBookmarked) {
        wishlist.removeWhere((r) => r['title'] == restaurant['title']);
        print('Removed from wishlist: ${restaurant['title']}');
      } else {
        wishlist.add(restaurant);
        print('Added to wishlist: ${restaurant['title']}');
      }

      // Print the entire wishlist
      print('Updated wishlist:');
      wishlist.forEach((r) => print('Title: ${r['title']}, Category: ${r['category']}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1711),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image at the top
          Stack(
            children: [
              Image.asset(
                'assets/foodpic.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 20, // Adjust the positioning of the icon as needed
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Space after the image
          // Center the "Wishlist" text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Wishlist',
                    style: TextStyle(
                      fontFamily: 'Italiana',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFDFCE2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Line below Wishlist text
                  Container(
                    width: 343,
                    height: 2,
                    color: const Color(0xFF2F2821),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List of restaurants in wishlist
          Expanded(
            child: wishlist.isEmpty
                ? Center(
                    child: Text(
                      'No restaurants in your wishlist.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      final restaurant = wishlist[index];
                      return RestaurantCard(
                        pk: restaurant['pk'],
                        title: restaurant['title'],
                        subtitle: restaurant['subtitle'],
                        category: restaurant['category'],
                        imageUrl: restaurant['imageUrl'],
                        rating: restaurant['rating'],
                        isBookmarked: true, // Always show as bookmarked in the wishlist
                        onBookmark: (isBookmarked) {
                          _toggleBookmark(restaurant); // Update wishlist with the restaurant
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
