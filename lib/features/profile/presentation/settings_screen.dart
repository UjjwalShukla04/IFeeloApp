import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Account Settings'),
          ListTile(
            title: const Text('EQ Assessment'),
            subtitle: const Text('Take/retake the EQ questionnaire'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/assessment'),
          ),
          ListTile(
            title: const Text('Phone Number'),
            subtitle: const Text('+1 234 567 890'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Email Address'),
            subtitle: const Text('user@example.com'),
            onTap: () {},
          ),
          
          _buildSectionHeader(context, 'Discovery Settings'),
          ListTile(
            title: const Text('Location'),
            subtitle: const Text('New York, USA'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          SwitchListTile(
            value: true,
            activeThumbColor: const Color(0xFFE94057),
            title: const Text('Show Me on Dating App'),
            onChanged: (val) {},
          ),
          
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            value: true,
            activeThumbColor: const Color(0xFFE94057),
            title: const Text('New Matches'),
            onChanged: (val) {},
          ),
          SwitchListTile(
            value: true,
            activeThumbColor: const Color(0xFFE94057),
            title: const Text('Messages'),
            onChanged: (val) {},
          ),

          _buildSectionHeader(context, 'Legal'),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {},
          ),
          
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(16),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Delete Account', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
