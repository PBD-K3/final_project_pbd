import 'dart:convert';

class RestaurantFavorites {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final String isFavorited;
  final String isBookmarked;


  RestaurantFavorites({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.isFavorited,
    required this.isBookmarked
  });

  factory RestaurantFavorites.fromJson(Map<String, dynamic> json) => RestaurantFavorites(
    id: json['id'].toString(),
    name: json['name'],
    category: json['category'],
    imageUrl: json['image_url'],
    rating: json['rating'].toDouble(),
    isFavorited: json['is_favorite'] ?? false,
    isBookmarked: json['is_bookmark'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'image_url': imageUrl,
    'rating': rating,
    'is_favorite': isFavorited,
    'is_bookmark': isBookmarked,
  };
}

// Helper methods for list operations
List<RestaurantFavorites> wishlistFromJson(String str) =>
    List<RestaurantFavorites>.from(json.decode(str).map((x) => RestaurantFavorites.fromJson(x)));

String wishlistToJson(List<RestaurantFavorites> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
