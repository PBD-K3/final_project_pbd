import 'package:thousand_flavours/main/models/restaurants.dart';

class Reserve {
  final String user; // Foreign key reference to User model
  final Restaurants restaurant; // Foreign key reference to Restaurant model
  final DateTime addedAt; // Date and time when the reservation was added

  Reserve({
    required this.user,
    required this.restaurant,
    required this.addedAt,
  });

  // Method to remove a reservation
  void remove(List<Reserve> wishlist) {
    wishlist.remove(this);
  }
}


