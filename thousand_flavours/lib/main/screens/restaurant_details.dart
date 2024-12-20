import 'package:flutter/material.dart';
import 'package:thousand_flavours/favorites/models/favorites.dart';
import 'package:thousand_flavours/favorites/provider/favorites_provider.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:thousand_flavours/reviews/widgets/review_card.dart';
import 'package:thousand_flavours/reviews/widgets/review_form.dart';
import 'package:thousand_flavours/reviews/services/review_service.dart';
import 'package:thousand_flavours/reviews/models/review.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String pk;
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double rating;
  final String island;
  final String contact;
  final bool isBookmarked;
  final Function(bool) onBookmark;

  const RestaurantDetailsPage({
    super.key,
    required this.pk,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.island,
    required this.contact,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  bool isFavorite = false;
  bool isBookmarked = false;

  late Restaurants restaurant; // to be initialized later

  // List of reviews
  List<Review> _reviews = [];
  late final ReviewService _reviewService;


  @override
  void initState() {
    super.initState();

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

    isBookmarked = widget.isBookmarked;
    final request = context.read<CookieRequest>();
    _reviewService = ReviewService(request);
    _fetchReviews();
  }

  // Fetch reviews from the server
  Future<void> _fetchReviews() async {
    try {
      final reviews = await _reviewService.fetchReviews(widget.pk); // subtitle as restaurant ID
      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load reviews')),
      );
    }
  }

  // Add a new review
  void _addReview(int rating, String description) async {
    final newReview = Review(
      id: 0,
      user: 'Current User', // Replace with actual username from session
      restaurant: widget.pk,
      rating: rating,
      description: description,
      createdAt: DateTime.now(),
    );

    // try {
      final success = await _reviewService.submitReview(widget.pk, newReview);
      if (success) {
        _fetchReviews(); // Reload reviews after successful submission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    // } catch (e) {
    //   print(e);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Failed to submit review')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoritesProvider.of(context);
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
                          provider.isExist(restaurant)? Icons.favorite :
                          Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          
                          provider.toggleFavorites(restaurant);

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
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.blue : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.title} has been ${isBookmarked ? 'added to' : 'removed from'} the wishlist!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
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
            // Details Section in Grey Box
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
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
                    Text(
                      'Island: ${widget.island}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Italiana',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contact: ${widget.contact}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Italiana',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < widget.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Reviews Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return ReviewCard(
                  username: review.user,
                  rating: review.rating,
                  description: review.description,
                );
              },
            ),
            const SizedBox(height: 16),
            // Add a Review Section
            if (context.read<CookieRequest>().loggedIn)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Add a Review',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (context.read<CookieRequest>().loggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReviewForm(onSubmit: _addReview),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
  
}
