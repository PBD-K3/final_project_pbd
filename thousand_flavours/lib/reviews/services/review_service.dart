// review_service.dart
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/review.dart';

class ReviewService {
  final CookieRequest request;
  final bool isLocal; // Toggle between environments

  ReviewService(this.request, {this.isLocal = true});

  String get baseUrl {
    return isLocal
        ? 'http://localhost:8000'
        : 'https://andhika-nayaka-athousandflavourmidterm.pbp.cs.ui.ac.id';
  }

  Future<List<Review>> fetchReviews(String restaurantId) async {
    final url = '$baseUrl/reviews/api/get-reviews/$restaurantId/';
    print("Fetching reviews from: $url");
    try {
      final response = await request.get(url);
      print("Fetch Reviews Response: $response");

      if (response is List) {
        return response.map<Review>((json) => Review.fromJson(json)).toList();
      } else {
        print("Error: Unexpected response format for fetchReviews: $response");
        return [];
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      return [];
    }
  }

  Future<bool> submitReview(String restaurantId, Review review) async {
    print("Attempting to submit a review for restaurant ID: $restaurantId");
    try {
      // Fetch CSRF token
      final csrfUrl = '$baseUrl/reviews/api/csrf/';
      print("Fetching CSRF token from: $csrfUrl");
      final csrfResponse = await request.get(csrfUrl);
      print("CSRF Response: $csrfResponse");

      // Extract CSRF token
      final csrfToken = csrfResponse['csrfToken'];
      if (csrfToken == null) {
        print("Error: CSRF token is null");
        return false;
      }
      print("CSRF Token fetched: $csrfToken");

      // Prepare submission payload
      final payload = {
        'rating': review.rating.toString(),
        'description': review.description,
        'csrfmiddlewaretoken': csrfToken,
      };
      print("Submitting review with payload: $payload");

      // Submit the review
      final submitUrl = '$baseUrl/reviews/api/submit-review/$restaurantId/';
      print("Submitting review to: $submitUrl");
      final response = await request.post(submitUrl, payload);

      print("Submit Review Response: $response");
      if (response['id'] != null) {
        print("Review submission successful with ID: ${response['id']}");
        return true;
      } else {
        print("Review submission failed: $response");
        return false;
      }
    } catch (e) {
      print("Error submitting review: $e");
      return false;
    }
  }
}
