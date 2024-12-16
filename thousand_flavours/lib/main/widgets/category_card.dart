import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap; // Clic management

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap, // optional Callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Clic detection
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color.fromARGB(255, 222, 218, 181)),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Italiana',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
