import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:thousand_flavours/main/screens/restaurant_details.dart';
import 'package:thousand_flavours/wishlist/screens/wishlist.dart';
import 'package:thousand_flavours/wishlist/services/wishlist_service.dart';
import 'package:thousand_flavours/wishlist/providers/wishlist_provider.dart';

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

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isBookmarked || 
      context.read<WishlistProvider>().isInWishlist(widget.pk);
  }

  void _handleWishlistToggle() async {
    final request = context.read<CookieRequest>();
    final wishlistProvider = context.read<WishlistProvider>();
    
    if (isBookmarked) {
      final success = await wishlistProvider.removeFromWishlist(
        context,
        request,
        widget.pk,
      );
      if (success) {
        setState(() {
          isBookmarked = false;
        });
        widget.onBookmark(false);
      }
    } else {
      final success = await wishlistProvider.addToWishlist(
        context,
        request,
        widget.pk,
      );
      if (success) {
        setState(() {
          isBookmarked = true;
        });
        widget.onBookmark(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                isBookmarked: widget.isBookmarked,//true,
                onBookmark: (isBookmarked) {}),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                          setState(() {
                            isFavorite = !isFavorite;
                          });

                          // Show SnackBar with appropriate message
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
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between icons
                      GestureDetector(
                        onTap: _handleWishlistToggle,
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
