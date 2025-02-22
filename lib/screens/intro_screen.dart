import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qdrobe_app/const/const.dart';
import 'package:qdrobe_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  static const double _imageHeight = 220.0;
  static const double _imageWidth = 180.0;
  static const double _imageRotation = 0.1;
  static const double _horizontalOffset = -60.0;

  // Extracted text styles for reusability and consistency
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 16,
  );

  static const TextStyle _buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  Future<void> _onGetStarted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showHome', true);
      Get.off(() => const Home(), transition: Transition.rightToLeft);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save preferences',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildImageRow(List<String> images) {
    return Container(
      height: _imageHeight,
      margin: const EdgeInsets.only(top: 20),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.white.withOpacity(0.8)],
            stops: const [0.8, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Transform.translate(
              offset: const Offset(_horizontalOffset, 0),
              child: Row(
                children: images
                    .map((image) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Transform.rotate(
                            angle: _imageRotation,
                            child: ImageContainer(imageUrl: image),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text('QDrobe', style: _titleStyle),
          const SizedBox(height: 8),
          const Text('Fashion in minutes', style: _subtitleStyle),
          const SizedBox(height: 16),
          const Text(
            'Indulge in a wardrobe that effortlessly blends sophistication with comfort, ensuring every outfit resonates with your unique flair delivered to your doorstep in minutes',
            textAlign: TextAlign.center,
            style: _bodyStyle,
          ),
          const SizedBox(height: 40),
          _buildGetStartedButton(),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return ElevatedButton(
      onPressed: _onGetStarted,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Get Started', style: _buttonTextStyle),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageRow([img1, img2, img3]),
              const SizedBox(height: 24),
              _buildImageRow([img2, img3, img4]),
              const SizedBox(height: 24),
              _buildContentSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;

  const ImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: Container(
        width: IntroScreen._imageWidth,
        height: IntroScreen._imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
