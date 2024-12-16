import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy data - replace with actual user data retrieval logic (API or DB)
  String username = "JohnDoe"; // Replace with actual value
  String password = ""; // Empty if none
  String email = "john@example.com"; // Replace with actual value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display Username
            const Text(
              'Username:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              username.isNotEmpty ? username : 'No username available',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),

            // Display Password
            const Text(
              'Password:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              password.isNotEmpty ? password : 'No password available',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),

            // Display Email
            const Text(
              'Email:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              email.isNotEmpty ? email : 'No email available',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),

            // Optionally add a button for editing profile
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile page or show a form
                // For example, you could navigate to another page to update the profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB87E20),
              ),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
