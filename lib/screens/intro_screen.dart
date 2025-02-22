import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qdrobe_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showHome', true);
    Get.off(() => const Home());
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive dimensions
    final imageHeight = screenHeight * 0.25;
    final imageWidth = screenWidth * 0.45;
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First Row of Images
              SizedBox(
                height: imageHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Transform.translate(
                      offset: Offset(-screenWidth * 0.15, 0),
                      child: Row(
                        children: [
                          _buildRotatedImage(
                              imageUrl: 'url1',
                              width: imageWidth,
                              height: imageHeight),
                          SizedBox(width: screenWidth * 0.025),
                          _buildRotatedImage(
                              imageUrl: 'url2',
                              width: imageWidth,
                              height: imageHeight),
                          SizedBox(width: screenWidth * 0.025),
                          _buildRotatedImage(
                              imageUrl: 'url3',
                              width: imageWidth,
                              height: imageHeight),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing),

              // Second Row of Images
              SizedBox(
                height: imageHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Transform.translate(
                      offset: Offset(-screenWidth * 0.15, 0),
                      child: Row(
                        children: [
                          _buildRotatedImage(
                              imageUrl: 'url4',
                              width: imageWidth,
                              height: imageHeight),
                          SizedBox(width: screenWidth * 0.025),
                          _buildRotatedImage(
                              imageUrl: 'url5',
                              width: imageWidth,
                              height: imageHeight),
                          SizedBox(width: screenWidth * 0.025),
                          _buildRotatedImage(
                              imageUrl: 'url6',
                              width: imageWidth,
                              height: imageHeight),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Text Content
              Text(
                'QuickStyl',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: verticalSpacing),

              Text(
                'Fashion in minutes',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: verticalSpacing),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  'Indulge in a wardrobe that effortlessly blends sophistication with comfort, ensuring every outfit resonates with your unique flair delivered to your doorstep in minutes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ElevatedButton(
                  onPressed: _onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRotatedImage({
    required String imageUrl,
    required double width,
    required double height,
  }) {
    return Transform.rotate(
      angle: 0.1,
      child: ImageContainer(
        imageUrl: imageUrl,
        width: width,
        height: height,
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageContainer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
