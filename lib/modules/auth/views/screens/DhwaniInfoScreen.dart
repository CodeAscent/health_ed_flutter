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
            const Text(
              "You’ve come to the right place. We’re here to support and guide you every step of the way on your child’s speech and language development journey. Every child is unique, and our personalized approach ensures that their individual needs are met. This is just the beginning—a meaningful step toward building your child’s communication skills and helping them reach their next milestone.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("How to Get Best Results"),
            _buildBulletPoint(
              "Our platform is designed to help your child develop strong, age-appropriate speaking & language skills — starting as early as 1.5 years and continuing up to 7 years.",
            ),
            Text(
              'Objective of this journey is to:-',
              style: const TextStyle(fontSize: 20, height: 1.4),
            ),
            _buildBulletPoint(
              "Expand your child’s vocabulary to around 20,000 words",
            ),
            _buildBulletPoint(
              "Build stronger sentence structure and correct grammar.",
            ),
            _buildBulletPoint(
              "Deepen your child’s understanding and ability to express themselves clearly.",
            ),
            _buildBulletPoint(
              "Strengthen social communication skills and confidence.",
            ),
            _buildBulletPoint(
              "Help your child tell stories with clear beginnings, characters, challenges, and resolutions.",
            ),
            _buildBulletPoint(
              "Develop critical thinking and problem-solving abilities.",
            ),
            const SizedBox(height: 8),
            const Text(
              "The program begins with basic sounds and words and gradually progresses to age-appropriate speech and language levels—building a strong foundation and ensuring lasting development.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Role of Parents/Guardians"),
            _buildBulletPoint("Complete the recommended activities daily"),
            _buildBulletPoint("Spend focused, quality time with your child"),
            _buildBulletPoint(
                "Stay patient and positive—this process requires energy and dedication"),
            _buildBulletPoint(
                "Encourage your child to use learned skills in real-life situations and different environments"),
            const SizedBox(height: 24),
            _buildSectionTitle("Getting Started"),
            _buildNumberedPoint(1, "Register your child's details"),
            _buildNumberedPoint(2,
                "Take an assessment (free screening or detailed evaluation)"),
            _buildNumberedPoint(3, "Begin daily guided activities"),
            _buildNumberedPoint(4, "Track your child’s progress regularly"),
            const SizedBox(height: 12),
            const Text(
              "Optional: You may also subscribe to online speech therapy sessions if additional support is needed.",
              style: TextStyle(
                  fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "Thank you!",
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number. ", style: const TextStyle(fontSize: 16)),
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
}
