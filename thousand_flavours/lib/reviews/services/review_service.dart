  // review_Service.dart
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/review.dart';

class ReviewService {
  final CookieRequest request;

  ReviewService(this.request);

  // Fetch reviews for a restaurant
  Future<List<Review>> fetchReviews(String restaurantId) async {
    try {
      final response = await request.get(
        'http://localhost:8000/reviews/api/get-reviews/$restaurantId/',
      );

      print("Fetch Reviews Response: ${response}");

      if (response is List) {
        return response.map<Review>((json) => Review.fromJson(json)).toList();
      } else {
        print("Error fetching reviews: ${response}");
        return [];
      }
    } catch (e) {
      print("Error parsing response: $e");
      return [];
    }
  }

  // Submit a review for a restaurant
Future<bool> submitReview(String restaurantId, Review review) async {
  try {
    // Fetch CSRF token
    final csrfResponse = await request.get(
      'http://localhost:8000/reviews/api/csrf/',
    );
    print("CSRF Response: ${csrfResponse}");

    // Extract CSRF token
    final csrfToken = csrfResponse['csrfToken'];
    print("CSRF Token: $csrfToken");

    // Submit the review with CSRF token included
    final response = await request.post(
      'http://localhost:8000/reviews/api/submit-review/$restaurantId/',
      {
        'rating': review.rating.toString(),
        'description': review.description,
        'csrfmiddlewaretoken': csrfToken,
      },
    );

    print("Submit Review Response: ${response}");

    return response['id'] != null; // Check if review was successfully created
  } catch (e) {
    print("Error submitting review: $e");
    return false;
  }
}
}
