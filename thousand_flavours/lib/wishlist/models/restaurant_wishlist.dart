import 'dart:convert';

class RestaurantWishlist {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final String isBookmarked;


  RestaurantWishlist({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.isBookmarked
  });

  factory RestaurantWishlist.fromJson(Map<String, dynamic> json) => RestaurantWishlist(
    id: json['id'].toString(),
    name: json['name'],
    category: json['category'],
    imageUrl: json['image_url'],
    rating: json['rating'].toDouble(),
    isBookmarked: json['is_bookmark'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'image_url': imageUrl,
    'rating': rating,
    'is_bookmark': isBookmarked,
  };
}

// Helper methods for list operations
List<RestaurantWishlist> wishlistFromJson(String str) =>
    List<RestaurantWishlist>.from(json.decode(str).map((x) => RestaurantWishlist.fromJson(x)));

String wishlistToJson(List<RestaurantWishlist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
