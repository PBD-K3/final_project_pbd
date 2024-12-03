import 'package:flutter/material.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form.dart';
import '../services/review_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';

class ReviewPage extends StatefulWidget {
  final String restaurantId;  // UUID as String

  const ReviewPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review> _reviews = [];
  late final ReviewService _reviewService;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _reviewService = ReviewService(request);
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final reviews = await _reviewService.fetchReviews(widget.restaurantId);
      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load reviews')),
      );
    }
  }

  void _addReview(int rating, String description) async {
    final newReview = Review(
      id: 0,
      user: '', // You can set this to the logged-in user
      restaurant: widget.restaurantId, // UUID passed here
      rating: rating,
      description: description,
      createdAt: DateTime.now(),
    );

    try {
      final success = await _reviewService.submitReview(widget.restaurantId, newReview);
      if (success) {
        _fetchReviews();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: const Color(0xFF2F2821),
      ),
      backgroundColor: const Color(0xFF2F2821),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
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
              const Text(
                'Add a Review',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ReviewForm(onSubmit: _addReview),
            ],
          ),
        ),
      ),
    );
  }
}
