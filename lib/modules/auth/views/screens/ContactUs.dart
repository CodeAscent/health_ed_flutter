import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
// Preferred color

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactScreen> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after screen load
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _animate = true;
      });
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open link")),
      );
    }
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required String actionLabel,
    required VoidCallback onTap,
    required int index,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + index * 200),
      curve: Curves.easeOutBack,
      transform: _animate
          ? Matrix4.translationValues(0, 0, 0)
          : Matrix4.translationValues(0, 100, 0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          color: ColorPallete.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(actionLabel,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button + Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Tiles
              _buildTile(
                icon: Icons.email,
                label: "Email",
                actionLabel: "archanasthedhwani@gmail.com",
                onTap: () => _launchUrl("archanasthedhwani@gmail.com"),
                index: 0,
              ),
              const SizedBox(height: 16),
              _buildTile(
                icon: Icons.phone,
                label: "Phone",
                actionLabel: "+91 7978062836",
                onTap: () => _launchUrl("tel:+917978062836"),
                index: 1,
              ),
              const SizedBox(height: 16),
              _buildTile(
                icon: Icons.language,
                label: "Website",
                actionLabel: "www.thedhwani.com",
                onTap: () => _launchUrl("https://www.thedhwani.com"),
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
