import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/assessment_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final List<String> carouselImages = [
    'https://loremflickr.com/400/200?random=1',
    'https://loremflickr.com/400/200?random=2',
    'https://loremflickr.com/400/200?random=3',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Carousel Slider with Indicators
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: carouselImages.map((image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(image, fit: BoxFit.cover),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: carouselImages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey.shade300,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ],
            ),
          ),

          // Assessment Card
      Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10), // Add padding inside the Card
      child: ListTile(
        title: Text(
          'Choose Your Assessment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'We will first check your child’s IQ and then direct you to the dashboard',
        ),
        trailing: Icon(Icons.arrow_forward),
         onTap: () {
          Get.to(() => AssessmentScreen()); // Navigate to AssessmentScreen on tap
        },
      ),
    ),
  ),
),


          SizedBox(height: 40),

          // Grid Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGridButton('Get pro', Icons.emoji_events,Color(0xFFF7CE45)),
                _buildGridButton('How it works', Icons.menu_book, Color(0xFF01D15F)),
                _buildGridButton('FAQ', Icons.help, Color(0xFF5370C8)),
              ],
            ),
          ),

          Spacer(), // Pushes content above, keeping Contact section at bottom

          // Contact Section
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Text(
                  'Contact us:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('dhiwani1234@gmail.com'),
                Text('+91 7878473497'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 30),
          ),
          onPressed: () {},
          child: Column(
            children: [
              Icon(icon, color: Colors.white,size: 30,),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
