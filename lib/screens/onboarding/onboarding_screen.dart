import 'package:flutter/material.dart';
import 'package:youthspot/services/onboarding_service.dart';
import 'package:youthspot/auth/auth_layout.dart';
import 'package:youthspot/config/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: "Welcome to YouthSpot",
      description: "Your go-to platform for youth development, resources, and community connection.",
      imagePath: "assets/image_assets/onboarding1.png",
    ),
    OnboardingSlide(
      title: "Discover Resources",
      description: "Access a wealth of educational content, career guidance, and personal development tools.",
      imagePath: "assets/image_assets/onboarding2.png",
    ),
    OnboardingSlide(
      title: "Connect & Grow",
      description: "Join a community of young achievers and unlock your potential through collaboration.",
      imagePath: "assets/image_assets/onboarding3.png",
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await OnboardingService.setOnboardingSeen();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),
            
            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDots(),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button (invisible for first page)
                  SizedBox(
                    width: 80,
                    child: _currentPage > 0
                        ? TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                color: kSSIorange,
                              ),
                            ),
                          )
                        : null,
                  ),
                  
                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSSIorange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[100],
            ),
            child: slide.imagePath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      slide.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    ),
                  )
                : _buildPlaceholderImage(),
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kSSIorange.withOpacity(0.3),
            kSSIorange.withOpacity(0.1),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: kSSIorange,
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    return List.generate(
      _slides.length,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentPage == index ? 24 : 8,
        decoration: BoxDecoration(
          color: _currentPage == index ? kSSIorange : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}