import 'package:flutter/material.dart';

class RestaurantOfTheMonth extends StatelessWidget {
  const RestaurantOfTheMonth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 155, 72, 20),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Corrected background image with BoxDecoration
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/default_food_image.png'), // Your image here
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Jukung Seafood',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Italiana',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
