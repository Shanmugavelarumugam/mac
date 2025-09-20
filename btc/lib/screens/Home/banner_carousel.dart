import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  final int _bannerCount = 3;

  static const customColor = Color(0xFF009688); // Teal

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 4, left: 16, right: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Banner Carousel
          PageView.builder(
            controller: _pageController,
            itemCount: _bannerCount,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      customColor.withOpacity(0.2),
                      customColor.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '🎉 Banner ${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Set font to Poppins
                      letterSpacing: 0.1,
                      fontSize: 16,
                      color: customColor.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),

          // Dot Indicator
          Positioned(
            bottom: 10,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _bannerCount,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                dotColor: customColor.withOpacity(0.3),
                activeDotColor: customColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
