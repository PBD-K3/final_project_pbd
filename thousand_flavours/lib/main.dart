import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:thousand_flavours/main/screens/login.dart';
import 'package:thousand_flavours/main/screens/cover.dart';
// import 'package:thousand_flavours/main/screens/testing.dart';
import 'package:thousand_flavours/wishlist/providers/wishlist_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => CookieRequest(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Thousand Flavours',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: CoverPage(),
    );
  }
}
