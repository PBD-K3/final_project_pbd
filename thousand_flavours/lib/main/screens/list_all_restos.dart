import 'package:flutter/material.dart';
import 'package:thousand_flavours/api_service/restaurant_api.dart';
import 'package:thousand_flavours/main/models/restaurants.dart';
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final RestaurantsApi _restaurantsApi = RestaurantsApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 18, 13),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/foodpic.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Our Tastiest Restaurants',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Italiana',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Restaurant List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<Restaurants>>(
                future: _restaurantsApi.fetchRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No restaurants available.',
                        style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final restaurant = snapshot.data![index];
                        return RestaurantCard(
                          pk: restaurant.pk,
                          title: restaurant.fields.name,
                          subtitle: restaurant.fields.island,
                          category: restaurant.fields.cuisine,
                          imageUrl: restaurant.fields.image.isEmpty
                              ? 'assets/default_food_image.png'
                              : restaurant.fields.image,
                          rating: 4.5,
                          isBookmarked: false,
                          onBookmark: (isBookmarked) {},
                          isFavorited: false,
                          onFavorite: (isFavorited) {},
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}
