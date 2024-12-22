import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:thousand_flavours/main/widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

Future<void> fetchProfileData() async {
  try {
    final request = context.read<CookieRequest>();

    final response = await request.get(
      "https://andhika-nayaka-athousandflavourmidterm.pbp.cs.ui.ac.id/auth/api/profile/",
    );

    if (response.containsKey('status') && response['status'] == 'success') {
      setState(() {
        usernameController.text = response['data']['username'];
        emailController.text = response['data']['email'];
      });
      print('Profile data loaded successfully');
    } else {
      final message = response['message'] ?? 'Unexpected error occurred';
      print('Failed to load profile data: $message');
    }
  } catch (e) {
    print('Error fetching profile data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1711),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/restaurant_pic.jpg', // Replace with your image asset
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    Text(
                      usernameController.text.isEmpty
                          ? 'USERNAME'
                          : usernameController.text,
                      style: const TextStyle(
                        fontFamily: 'Italiana',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('user.jpg'), // Replace with your image asset
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInputField(
                    "Username",
                    usernameController,
                    fillColor: const Color(0xFFFDFCE2),
                  ),
                  const SizedBox(height: 15),
                  buildInputField(
                    "Password",
                    passwordController,
                    isObscure: true,
                    fillColor: const Color(0xFFFDFCE2),
                  ),
                  const SizedBox(height: 15),
                  buildInputField(
                    "Email",
                    emailController,
                    fillColor: const Color(0xFFFDFCE2),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildActionButton("Change Password"),
                      buildActionButton("Change Email"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        //final request = context.read<CookieRequest>();
                        // request.logout(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'Italiana',
                          color: Colors.brown[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      {bool isObscure = false, Color? fillColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Italiana',
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? Colors.brown[700],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          style: const TextStyle(
            fontFamily: 'Italiana',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Italiana',
          color: Colors.brown[900],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
