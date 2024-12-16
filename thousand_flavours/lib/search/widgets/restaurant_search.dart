import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';

class RestaurantSearchPage extends StatefulWidget {
  final String query;

  const RestaurantSearchPage({Key? key, required this.query}) : super(key: key);

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  late TextEditingController _searchController;
  List<dynamic> _results = [];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _searchRestaurants(widget.query);
  }

  Future<void> _searchRestaurants(String query) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/search_json/?query=$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _results = data['results'];
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 18, 13),
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: const Color.fromARGB(255, 184, 126, 32),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      color: Color.fromARGB(255, 184, 126, 32)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "What are you craving?",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _searchRestaurants(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchRestaurants(_searchController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                      ? const Center(
                          child: Text(
                            'Failed to load results. Please try again.',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : _results.isEmpty
                          ? const Center(
                              child: Text(
                                'No results found.',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                                childAspectRatio: 0.6,
                              ),
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final restaurant = _results[index];
                                return RestaurantCard(
                                  pk: restaurant['id'].toString(),
                                  title: restaurant['name'],
                                  subtitle: restaurant['island'],
                                  category: restaurant['cuisine'] ??
                                      "Unknown Cuisine",
                                  imageUrl: restaurant['image'] ??
                                      'assets/default_food_image.png',
                                  rating:
                                      restaurant['rating']?.toDouble() ?? 0.0,
                                  isBookmarked: false,
                                  onBookmark: (isBookmarked) {
                                    debugPrint(
                                        '${restaurant['name']} has been ${isBookmarked ? 'bookmarked' : 'unbookmarked'}');
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
