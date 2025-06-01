import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/model/request/FeedbackRequest.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactScreen> {
  bool _animate = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trigger animation after screen load
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open link")),
      );
    }
  }

  void _submitFeedback() {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some feedback")),
      );
      return;
    }
    context.read<HomeBloc>().add(SubmitFeedbackRequest(
        feedbackRequest:
            FeedbackRequest(message: _feedbackController.text.trim())));
    _feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );
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
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetSubmitFeedbackResponse) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thank you for your feedback!")),
          );
        }
      },
      builder: (context, state) {
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
                    onTap: () =>
                        _launchUrl("mailto:archanasthedhwani@gmail.com"),
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
                  const SizedBox(height: 24),

                  // Feedback Form
                  AnimatedOpacity(
                    opacity: _animate ? 1 : 0,
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Feedback",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _feedbackController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Let us know your thoughts...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPallete.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Submit Feedback",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
