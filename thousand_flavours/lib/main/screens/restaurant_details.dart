import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double rating;
  final String island;
  final String contact;

  const RestaurantDetailsPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.island,
    required this.contact,
  });

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  bool isFavorite = false;
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 18, 13),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Section with Custom Back Button
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/default_food_image.png',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
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
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(child:            
            Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Italiana',
                    ),
                  ),    
            ),
            const SizedBox(height: 8),
            // Details Section in Grey Box with Shorter Height and Full Width
            Center(
              child: Container(
              width: MediaQuery.of(context).size.width - 40, // Adjust for padding on both sides
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 24, 23),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${widget.category}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Italiana',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Island Section
                  Text(
                    'Island: ${widget.island}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Italiana',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contact Section
                  Text(
                    'Contact: ${widget.contact}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Italiana',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating Section
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < widget.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        )],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}
