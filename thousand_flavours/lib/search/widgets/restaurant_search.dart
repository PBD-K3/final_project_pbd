import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        debugPrint('Error: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: const Color.fromARGB(255, 184, 126, 32),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16.0),
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

          // Search Results
          Expanded(
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
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final restaurant = _results[index];
                              return ListTile(
                                leading: Image.network(
                                  restaurant['image'] ??
                                      'assets/default_food_image.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image),
                                ),
                                title: Text(restaurant['name']),
                                subtitle: Text(
                                    '${restaurant['island']} - ${restaurant['cuisine']}'),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
