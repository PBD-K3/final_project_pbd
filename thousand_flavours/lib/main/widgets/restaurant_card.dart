import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:thousand_flavours/favorites/models/favorites.dart';
import 'package:thousand_flavours/favorites/provider/favorites_provider.dart';
import 'package:thousand_flavours/main/screens/restaurant_details.dart';
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
  final bool isFavorited;
  final Function(bool) onFavorite;

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
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  late bool isFavorited;
  late bool isBookmarked;
  late Restaurants restaurant;

  @override
  void initState() {
    super.initState();

    isBookmarked = widget.isBookmarked ||
        context.read<WishlistProvider>().isInWishlist(widget.pk);

    isFavorited = widget.isFavorited ||
        context.read<FavoritesProvider>().isInFavorites(widget.pk);

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

  void _handleFavoritesToggle() async {
    final request = context.read<CookieRequest>();
    final favoriteProvider = context.read<FavoritesProvider>();

    if (isFavorited) {
      final success = await favoriteProvider.removeFromFavorites(
        context,
        request,
        widget.pk,
      );
      if (success) {
        setState(() {
          isFavorited = false;
        });
        widget.onFavorite(false);
      }
    } else {
      final success = await favoriteProvider.addToFavorites(
        context,
        request,
        widget.pk,
      );
      if (success) {
        setState(() {
          isFavorited = true;
        });
        widget.onFavorite(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.read<FavoritesProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    isFavorited = favoriteProvider.isInFavorites(widget.pk);
    isBookmarked = wishlistProvider.isInWishlist(widget.pk);

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
              contact: '123-456-7890',
              isBookmarked: isBookmarked,
              onBookmark: (updatedBookmarkState) {
                setState(() {
                  isBookmarked = updatedBookmarkState;
                });
              },
              isFavorited: isFavorited,
              onFavorite: (updatedFavoriteState) {
                setState(() {
                  isFavorited = updatedFavoriteState;
                });
              },
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
                        onTap: _handleFavoritesToggle,
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _handleWishlistToggle,
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? const Color(0xFFb87e21)
                              : Colors.white70,
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
