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
        id: json['id'],
        user: json['user'],
        restaurant: json['restaurant'],
        rating: json['rating'],
        description: json['description'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'description': description,
      };
}
