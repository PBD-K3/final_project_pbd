import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:thousand_flavours/main/screens/home.dart';
import 'package:thousand_flavours/main/widgets/restaurant_card.dart';
import '../providers/wishlist_provider.dart';
import 'package:thousand_flavours/favorites/provider/favorites_provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late final CookieRequest _request;

  @override
  void initState() {
    super.initState();
    _request = context.read<CookieRequest>();
    _fetchFavorites();
    _fetchWishlist();
  }

  Future<void> _fetchFavorites() async {
    try {
      await context.read<FavoritesProvider>().fetchFavorites(_request);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorites: $e')),
        );
      }
    }
  }

  Future<void> _fetchWishlist() async {
    try {
      await context.read<WishlistProvider>().fetchWishlist(_request);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load wishlist: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1711),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/restaurant_pic.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()), // Replace with your BookmarksPage widget
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                const Text(
                  'Wishlist',
                  style: TextStyle(
                    fontFamily: 'Italiana',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDFCE2),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 343,
                  height: 2,
                  color: const Color(0xFF2F2821),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<WishlistProvider>(
              builder: (context, wishlistProvider, child) {
                if (wishlistProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final wishlist = wishlistProvider.wishlist;

                if (wishlist.isEmpty) {
                  return const Center(
                    child: Text(
                      'No restaurants in your wishlist.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final restaurant = wishlist[index];
                    
                    return RestaurantCard(
                      pk: restaurant.id,
                      title: restaurant.name,
                      subtitle: restaurant.category,
                      category: restaurant.category,
                      imageUrl: restaurant.imageUrl,
                      rating: restaurant.rating,
                      isFavorited: restaurant.isFavorited =="yes",
                      onFavorite: (isFavorited) async {
                        if (!isFavorited) {
                          await context.read<FavoritesProvider>().removeFromFavorites(
                            context,
                            _request,
                            restaurant.id,
                          );
                        }
                        context.read<WishlistProvider>().fetchWishlist(_request);
                      },
                      isBookmarked: restaurant.isBookmarked =="yes",
                      onBookmark: (isBookmarked) async {
                        if (!isBookmarked) {
                          await context.read<WishlistProvider>().removeFromWishlist(
                            context,
                            _request,
                            restaurant.id,
                          );
                        }
                        context.read<WishlistProvider>().fetchWishlist(_request);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
