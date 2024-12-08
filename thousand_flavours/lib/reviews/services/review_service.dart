import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/review.dart';

class ReviewService {
  final CookieRequest request;

  ReviewService(this.request);

  // Fetch reviews for a restaurant
  Future<List<Review>> fetchReviews(String restaurantId) async {
    final response = await request.get(
      'http://localhost:8000/reviews/api/get-reviews/$restaurantId/', // Ensure UUID is passed
    );

    print("Fetch Reviews Response: $response");

    if (response is List) {
      return response.map<Review>((json) => Review.fromJson(json)).toList();
    } else {
      print("Error fetching reviews: $response");
      return [];
    }
  }

  // Submit a review for a restaurant
  Future<bool> submitReview(String restaurantId, Review review) async {
    final response = await request.postJson(
      'http://localhost:8000/reviews/api/submit-review/$restaurantId/', // Ensure UUID is passed
      json.encode(review.toJson()),
    );

    print("Submit Review Response: $response");

    return response['id'] != null; // Check if review was successfully created
  }
}
