import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qdrobe_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _onGetStarted() async {
    // Save that intro has been shown
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showHome', true);

    // Navigate to Home
    Get.off(() => const Home());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First Row of Images
            Container(
              height: 220,
              margin: const EdgeInsets.only(top: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero, // Remove default padding
                children: [
                  Transform.translate(
                    offset: const Offset(-60, 0), // Move entire row left
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/6a36/1cb1/26652de236e42b4daed13a3984bfd61c?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=uEyTfPhMUvAu8HYBQ6Jwsdo0vM0uc1ZLziIzVsHCfelg1gDSnP3a7296U8~x7Axf9Dtbv1F9jgKQbNG79o8fGtrv69jNa1ZtiG6gUbXEbr9FFA238YEjmRKeoKwh6kpziZypJkucMuykUGUiGFyHJ8CXvyrNaDOZQGsiJmo4W1E2mW1S24Osx3on9vKqWKqSI1zje8lbV0jViJZlJX8CLs5wZNYXbBeFstvxwF2j2KgC1ZelY4pUCVj5uHu3lCKGFxbd6Xo1CNbFXN9cYXH6t03qQ0JnZEP6TAjFBjQK4AK93UKr0EeJnhs9oLHXU4pdmSwOOKjpJvPsZ5kn3r3J0w__',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/2fa7/5f0a/1716a00188f3dc60fc22a0b92ebd8ed4?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=AXKbFv8SqonnvSaEGdn6vm5Xg8amJry2z2kFQEzKR3x47bPROB541B~jZ2LWk3lzlAulESLIaKBLMfJI-0zOtUiDjXchVKp2kz4-F5cWH7OV0jjxeXmRPJ8X1V~to8WCRXAdW6pB9CITwilibACdhqe91WHavXnKMXRD5PY3zmGHYa-eAAlTvmW0IjT7y~TP-XEgGBxX5vlV0DiRkrGdY2KhP~yqWd9h8LSr7RThchbIf3G9tzynCIgurY6vwrEK~Sj1nwbR9VNDW2DIp7LnRrPAO8-1D2V8kXLAqdSWY5Ofkckq~uvymDdorleP-W6t0SHsix3jn20H9cPV41ZyMw__',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/b33e/430c/382b84466bc336fa32768bd940a94bef?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=U4DOVF1zwaAUnjU-ThrNscPgm9bsjWcogwSmNE7DOSB~yip32FxAZT~kK3OCtqLV4GilUwM9xbbArNAOS~5m8rqOsxn-cOcjHG~jKLHgqyERlw6VjNuiP31vgFSkVhxOFfmabGxYB1CBXNPqLfTa2QeivQoAgIy0r1KTdqlJEOORvL~xkAymn5qto3s853VVCAqCxul9rFnatpX~mfDGChBMzlwqFnoMNyVCZxycG7XyeGhfqJC5cMOxMQoDsHCcOy3rzJWJeUqY1xZWBbpH0zUomDSA24ZPbsRsOWBKNRXWQmHlH~b4g0PlmxDgXgYQIMI6LgdWDqtLSIlnr52pUQ__',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Second Row of Images
            Container(
              height: 220,
              margin: const EdgeInsets.only(top: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero, // Remove default padding
                children: [
                  Transform.translate(
                    offset: const Offset(-60, 0), // Move entire row left
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/2fa7/5f0a/1716a00188f3dc60fc22a0b92ebd8ed4?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=AXKbFv8SqonnvSaEGdn6vm5Xg8amJry2z2kFQEzKR3x47bPROB541B~jZ2LWk3lzlAulESLIaKBLMfJI-0zOtUiDjXchVKp2kz4-F5cWH7OV0jjxeXmRPJ8X1V~to8WCRXAdW6pB9CITwilibACdhqe91WHavXnKMXRD5PY3zmGHYa-eAAlTvmW0IjT7y~TP-XEgGBxX5vlV0DiRkrGdY2KhP~yqWd9h8LSr7RThchbIf3G9tzynCIgurY6vwrEK~Sj1nwbR9VNDW2DIp7LnRrPAO8-1D2V8kXLAqdSWY5Ofkckq~uvymDdorleP-W6t0SHsix3jn20H9cPV41ZyMw__',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/b33e/430c/382b84466bc336fa32768bd940a94bef?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=U4DOVF1zwaAUnjU-ThrNscPgm9bsjWcogwSmNE7DOSB~yip32FxAZT~kK3OCtqLV4GilUwM9xbbArNAOS~5m8rqOsxn-cOcjHG~jKLHgqyERlw6VjNuiP31vgFSkVhxOFfmabGxYB1CBXNPqLfTa2QeivQoAgIy0r1KTdqlJEOORvL~xkAymn5qto3s853VVCAqCxul9rFnatpX~mfDGChBMzlwqFnoMNyVCZxycG7XyeGhfqJC5cMOxMQoDsHCcOy3rzJWJeUqY1xZWBbpH0zUomDSA24ZPbsRsOWBKNRXWQmHlH~b4g0PlmxDgXgYQIMI6LgdWDqtLSIlnr52pUQ__',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: 0.1,
                          child: const ImageContainer(
                            imageUrl:
                                'https://s3-alpha-sig.figma.com/img/8ad7/a450/4e6a1ff5ecef9dbd2f3aeaa0c7369115?Expires=1740960000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=nPnrNqw5OjG1HK5rLd-j7UciMoFL89tsIenkGfUjiw8ek4UTkogRD-wIHVYRxBzVVaQmIwo9PdJQWEmEKbOmfcNO5~KatZkx~d0yUXOKN-dMMVKqQAQDJoePrzR41vAPxtp~WvcwN4dCeVeeWwcztrGBNXrxgAD~ARgMMDnZoZWLRoxIQGDVNx4Y-mXomvmU7urKTGGxrimisvFFrpWP31Tk4TqhNnTThCu8PCgmBkFRz32FNn~W6u1dVeQOyW0kI-9YGW8Ur0wCvaVJ0D19c56uqFZdy6jrGgXmkZkjY4eOwAFDqWthP4a-eprUGAcxxoGPqBtkcZM4zLtZGaQwuw__',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Rest of the content remains the same
            const SizedBox(height: 24),
            const Text(
              'QuickStyl',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fashion in minutes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Indulge in a wardrobe that effortlessly blends sophistication with comfort, ensuring every outfit resonates with your unique flair delivered to your doorstep in minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
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
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
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
    return Container(
      width: 180,
      height: 270,
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
