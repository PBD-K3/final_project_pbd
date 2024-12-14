import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:thousand_flavours/main/screens/login.dart';
import 'package:thousand_flavours/main/screens/cover.dart';
// import 'package:thousand_flavours/main/screens/testing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'A Thousand Flavours',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: CoverPage()
      ),
    );
  }
}