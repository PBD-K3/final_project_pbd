// review.dart
class Review {
  final int id;
  final String user;
  final String restaurant;
  final int rating;
  final String description;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.restaurant,
    required this.rating,
    required this.description,
    required this.createdAt,
  });

factory Review.fromJson(Map<String, dynamic> json) => Review(
  id: json['id'] ?? 0,
  user: json['user'] ?? '',
  restaurant: json['restaurant'] ?? '',
  rating: json['rating'] ?? 0,
  description: json['description'] ?? '',
  createdAt: (json['created_at'] != null)
      ? DateTime.parse(json['created_at'])
      : DateTime.now(),
);

  Map<String, dynamic> toJson() => {
        'rating': rating.toString(), // Convert int to String
        'description': description,
      };
}
