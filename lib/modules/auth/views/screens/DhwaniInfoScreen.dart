import 'package:flutter/material.dart';

class DhwaniInfoScreen extends StatelessWidget {
  const DhwaniInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome Parents',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Welcome to a New Beginning"),
            const Text(
              "Yes, you’ve arrived at the right place.\n\n"
              "If you’re concerned about your child’s speech or language development — know that you are not alone. "
              "We're here to walk this journey with you, step by step. "
              "Think of us as your partner, your guide, and your biggest supporter — as your little one blossoms into a confident communicator.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("What This App Does"),
            _buildNumberedPoint(1,
                "Children with Speech and Language Delay\nWe work with children between 2 to 7 years old who are experiencing delays due to conditions like Autism, ADHD, ADD, or any other developmental challenges. Using AI-powered personalization, the app creates a custom learning path based on your child’s unique needs — focusing on improving speech, language, and communication skills."),
            _buildNumberedPoint(2,
                "Children with Normal Development\nEven if your child doesn't have a delay, this app can help them enhance their speaking abilities, build stronger vocabulary, and express themselves more confidently."),
            const SizedBox(height: 24),
            _buildSectionTitle("Our Goals"),
            _buildBulletPoint(
                "Expand your child’s vocabulary to over 20,000 words"),
            _buildBulletPoint("Strengthen sentence structure and grammar"),
            _buildBulletPoint(
                "Deepen their understanding and clarity in communication"),
            _buildBulletPoint(
                "Improve social interaction and boost confidence"),
            _buildBulletPoint(
                "Teach storytelling with structure: beginning, characters, challenges, and resolution"),
            _buildBulletPoint(
                "Nurture critical thinking and problem-solving skills"),
            const SizedBox(height: 24),
            _buildSectionTitle("Your Role as a Parent"),
            const Text(
              "This app is a tool — but you are the most important part of this journey. "
              "With just 15–20 minutes a day, you can make a world of difference.\nHere’s how you can help:",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
                "Be consistent — do the daily activities with your child"),
            _buildBulletPoint(
                "Integrate the learning into everyday life — during meals, playtime, or walks"),
            _buildBulletPoint(
                "Be patient — progress may be slow at times, but it will come"),
            _buildBulletPoint(
                "Show love and support — your encouragement matters more than anything"),
            const SizedBox(height: 24),
            _buildSectionTitle("Benefits for Parents"),
            _buildBulletPoint("A continuous, guided journey — no guesswork"),
            _buildBulletPoint("Learn anywhere, anytime — full flexibility"),
            _buildBulletPoint(
                "Cost-effective — a meaningful alternative to aimless screen time"),
            _buildBulletPoint(
                "Can be used during routine activities like mealtime"),
            const SizedBox(height: 24),
            _buildSectionTitle("A Gentle Reminder"),
            const Text(
              "This app is not just about speaking — it’s about connecting.\n"
              "Speak clearly, give your child time to respond, be patient — and never rush or pressure them. "
              "Let this be a safe, encouraging space where your child feels heard and loved.\n"
              "And most importantly, always use this app under parental guidance.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "Together, let’s unlock your child’s voice — and let it shine.\nWe're with you, every step of the way.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number️ ", style: const TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
