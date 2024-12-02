import 'package:flutter/material.dart';
import 'package:thousand_flavours/main/models/restaurants.dart';

class RestaurantListItem extends StatelessWidget {
  final Fields restaurant;

  const RestaurantListItem({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Image.network(
          restaurant.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(restaurant.name),
        subtitle: Text('${restaurant.island} - ${restaurant.cuisine}'),
        onTap: () {
          // Action on tap (e.g., navigate to details screen)
        },
      ),
    );
  }
}
