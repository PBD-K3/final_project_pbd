import 'package:flutter/material.dart';
import 'package:thousand_flavours/favorites/models/favorites.dart';
import 'package:provider/provider.dart';

class FavoritesProvider extends ChangeNotifier {
  // List to store the full Restaurants model
  final List<Restaurants> _favorites = [];
  
  // Getter for the favorites list
  List<Restaurants> get favorites => _favorites;

  // Toggle a restaurant in/out of favorites
  void toggleFavorites(Restaurants restaurant) {
    final existingIndex =
        _favorites.indexWhere((element) => element.pk == restaurant.pk);

    if (existingIndex >= 0) {
      // Remove restaurant if it already exists
      _favorites.removeAt(existingIndex);
    } else {
      // Add the full restaurant model
      _favorites.add(restaurant);
    }
    notifyListeners();
  }

  // Check if a restaurant exists in favorites based on its pk
  bool isExist(Restaurants restaurant) {
    return _favorites.any((element) => element.pk == restaurant.pk);
  }

  // Static helper to access the provider in the widget tree
  static FavoritesProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoritesProvider>(
      context,
      listen: listen,
    );
  }
}
