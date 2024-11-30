import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 44, 39, 33),
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
            _buildNavItem(Icons.home,),
            _buildNavItem(Icons.favorite_outline),
            _buildNavItem(Icons.search, isSelected: true),
            _buildNavItem(Icons.bookmark_border),
            _buildNavItem(Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {bool isSelected = false}) {
    return Icon(
      icon,
      color: isSelected ? Colors.yellow[700] : Colors.white,
      size: 30,
    );
  }
}
