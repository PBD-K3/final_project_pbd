import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/screens/home.dart';
import 'package:thousand_flavours/profile_page/screens/profile_page.dart';
import 'package:thousand_flavours/wishlist/screens/wishlist.dart';
import 'package:thousand_flavours/favorites/screens/favorites.dart';
import 'package:thousand_flavours/search/widgets/restaurant_search.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  void _showSearchOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController searchController = TextEditingController();

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "What are you craving?",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          String query = searchController.text;
                          if (query.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantSearchPage(query: query),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 44, 39, 33), // Background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Replace with your HomePage widget
                );
              },
            ),
            _buildNavItem(
              icon: Icons.favorite_outline,
              isSelected: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FavoritesPage()), // Replace with your FavoritesPage widget
                );
              },
            ),
            _buildNavItem(
              icon: Icons.search,
              isSelected: false,
              onTap: () {
                _showSearchOverlay(context); // Show search overlay
              },
            ),
            _buildNavItem(
              icon: Icons.bookmark_border,
              isSelected: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WishlistPage()), // Replace with your BookmarksPage widget
                );
              },
            ),
            _buildNavItem(
              icon: Icons.person,
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with your ProfilePage widget
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(8), // Adds padding for circular background
        decoration: isSelected
            ? BoxDecoration(
                color: const Color.fromARGB(
                    255, 184, 126, 32), // Highlight color for selected icon
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white // Icon color for selected icon
              : const Color.fromARGB(255, 184, 126, 32), // Default icon color
          size: 30,
        ),
      ),
    );
  }
}
