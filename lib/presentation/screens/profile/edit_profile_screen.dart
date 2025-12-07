import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/data/mock_data.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.mockUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save changes
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: Icon(Icons.person, size: 60, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: user.name,
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: user.email,
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: user.phone,
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Property Address',
                hintText: '1234 Main Street',
                prefixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'City',
                hintText: 'Springfield',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'State',
                      hintText: 'IL',
                      prefixIcon: const Icon(Icons.map),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'ZIP Code',
                      hintText: '62701',
                      prefixIcon: const Icon(Icons.pin_drop),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
