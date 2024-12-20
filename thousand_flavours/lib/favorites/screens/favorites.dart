import 'package:flutter/material.dart';
import 'package:thousand_flavours/favorites/provider/favorites_provider.dart';
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoritesProvider.of(context);
    final favoriteRestaurants = provider.favorites; // List of favorite restaurants

    return Scaffold(
      backgroundColor: const Color(0xFF1C1711),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image with Back Button
          Stack(
            children: [
              Image.asset(
                'assets/restaurant_pic.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // "Favorites" Text
          Center(
            child: Column(
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontFamily: 'Italiana',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDFCE2),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 343,
                  height: 2,
                  color: const Color(0xFF2F2821),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Favorites Grid View
          Expanded(
            child: favoriteRestaurants.isEmpty
                ? const Center(
                    child: Text(
                      'No restaurants in your favorites.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjusted for equal padding
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 cards per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5, // Reduced vertical spacing
                        childAspectRatio: 0.63, // Card size
                      ),
                      itemCount: favoriteRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = favoriteRestaurants[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Restaurant Card Widget
                            SizedBox(
                              height: 245, // Shortened height (original 250 - 5 pixels)
                              child: RestaurantCard(
                                pk: restaurant.pk,
                                title: restaurant.fields.name,
                                subtitle: restaurant.fields.island,
                                category: restaurant.fields.cuisine,
                                imageUrl: restaurant.fields.image.isEmpty
                                    ? 'assets/default_food_image.png'
                                    : restaurant.fields.image,
                                rating: 4.5,
                                isBookmarked: false,
                                onBookmark: (isBookmarked) {},
                              ),
                            ),
                            const SizedBox(height: 4), // Reduced spacing (original 6)
                            // Trash Icon
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteRestaurants.removeAt(index);
                                });

                                // Show Snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('The restaurant has been removed from favorites!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                              tooltip: 'Remove from favorites',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
