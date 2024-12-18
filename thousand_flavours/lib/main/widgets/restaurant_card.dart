import 'package:flutter/material.dart';
import 'package:thousand_flavours/favorites/models/favorites.dart';
import 'package:thousand_flavours/favorites/provider/favorites_provider.dart';
import 'package:thousand_flavours/main/screens/restaurant_details.dart';

class RestaurantCard extends StatefulWidget {
  final String pk;
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double rating;
  final bool isBookmarked; 
  final Function(bool) onBookmark;

  const RestaurantCard({
    super.key,
    required this.pk,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool isFavorite = false;
  bool isBookmarked = false;

  late Restaurants restaurant; // to be initialized later

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isBookmarked; // Initialize with the passed value

    // Initialized restaurant variable
    restaurant = Restaurants(
      model: "restaurant_model", 
      pk: widget.pk,
      fields: Fields(
        name: widget.title,
        island: widget.subtitle,
        cuisine: widget.category,
        contacts: '123-456-7890', 
        gmaps: "gmaps_placeholder",
        image: widget.imageUrl,
      ),
    );

  }

  @override 
  Widget build(BuildContext context) {

    final provider = FavoritesProvider.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailsPage(
              pk: widget.pk,
              title: widget.title,
              subtitle: widget.subtitle,
              category: widget.category,
              imageUrl: widget.imageUrl,
              rating: widget.rating,
              island: widget.subtitle,
              contact: '123-456-7890', // Replace with actual contact data
              isBookmarked: false,
              onBookmark: (isBookmarked) {}
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 12),
        width: MediaQuery.of(context).size.width * 0.4,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                widget.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/default_food_image.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Rating Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < widget.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Subtitle Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.category,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ),
            // Location Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: [
                  GestureDetector(
                    onTap: () {
                      // Toggle the favorite state of the restaurant
                      provider.toggleFavorites(restaurant);

                      // Update isFavorite based on whether the restaurant is in favorites
                      setState(() {
                        isFavorite = provider.isExist(restaurant);
                      });

                      // Show SnackBar with the appropriate message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? "Restaurant has been added to favorites!"
                                : "Restaurant has been removed from favorites!",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Icon(
                      provider.isExist(restaurant) ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white70,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between icons
                  GestureDetector(
                    onTap: () {
                      widget.onBookmark(!widget.isBookmarked);
                      
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });

                      widget.onBookmark(isBookmarked);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.title} has been ${isBookmarked ? 'added to' : 'removed from'} the wishlist!',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.blue : Colors.white70,
                      size: 20,
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
    );
  }
}
