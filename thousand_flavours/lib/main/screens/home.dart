import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:thousand_flavours/main/models/restaurants.dart';
import 'package:thousand_flavours/main/screens/list_all_restos.dart';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';
import 'package:thousand_flavours/main/widgets/category_card.dart';
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';
import 'package:thousand_flavours/main/widgets/restaurant_otm.dart';
import 'package:thousand_flavours/search/widgets/restaurant_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _navigateToSearchScreen(BuildContext context, String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantSearchPage(query: query),
        ),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<Restaurants>> fetchFirstThreeRestaurants(
      CookieRequest request) async {
    final response = await request.get('http://localhost:8000/json/');
    List<Restaurants> listRestaurants = [];
    for (var d in response.take(4)) {
      listRestaurants.add(Restaurants.fromJson(d));
    }
    return listRestaurants;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 18, 13),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("G A L L E R Y"),
                  const SizedBox(height: 20),
                  _buildHorizontalRestaurantList(request),
                  const SizedBox(height: 60),

                  // Restaurant of the Month
                  _buildSectionTitle(
                      "R E S T A U R A N T  O F  T H E  M O N T H"),
                  const SizedBox(height: 20),
                  const RestaurantOfTheMonth(),
                  const SizedBox(height: 40),

                  // Categories Section
                  _buildSectionTitle("C A T E G O R I E S"),
                  const SizedBox(height: 10),
                  _buildCategoriesGrid(context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }

  Widget _buildTopSection() {
    return SizedBox(
      height: 270, // Adjust as needed
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/foodpic.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Semi-transparent overlay for better contrast
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Content over the image
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/ATF_logo.png', // Replace with your logo path
                  height: 100, // Adjust as needed
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 184, 126, 32),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller:
                            _searchController, // Connecte le contrôleur ici
                        decoration: const InputDecoration(
                          hintText: "What are you craving?",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _navigateToSearchScreen(
                              context, value); // Navigue lors de la soumission
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        _navigateToSearchScreen(context,
                            _searchController.text); // Navigue lors du clic
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RestaurantPage()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 184, 126, 32), // Highlight color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Italiana',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalRestaurantList(CookieRequest request) {
    return FutureBuilder<List<Restaurants>>(
      future: fetchFirstThreeRestaurants(request),
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.map((restaurant) {
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
              }).toList(),
            ),
          );
        }
      },
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CategoryCard(
          title: 'Seafood',
          icon: Icons.restaurant,
          onTap: () {
            _navigateToSearchPage(context, 'Seafood');
          },
        ),
        CategoryCard(
          title: 'Coffee & Snacks',
          icon: Icons.local_cafe,
          onTap: () {
            _navigateToSearchPage(context, 'Coffee & Snacks');
          },
        ),
        CategoryCard(
          title: 'Indonesian',
          icon: Icons.rice_bowl,
          onTap: () {
            _navigateToSearchPage(context, 'Indonesian');
          },
        ),
        CategoryCard(
          title: 'International',
          icon: Icons.public,
          onTap: () {
            _navigateToSearchPage(context, 'International');
          },
        ),
        CategoryCard(
          title: 'Local Dishes',
          icon: Icons.dining,
          onTap: () {
            _navigateToSearchPage(context, 'Local Dishes');
          },
        ),
      ],
    );
  }

  void _navigateToSearchPage(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantSearchPage(query: query),
      ),
    );
  }
}
