import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, 
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/banner.png', fit: BoxFit.cover),
          ),
          Positioned(
            right: 50,
            top: 30,
            child: Text(
              'Autumn\nCollection\n2022',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black45,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
class Banner1Widget extends StatelessWidget {
  const Banner1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Apply corner radius to children
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/banner1.png', fit: BoxFit.cover),
          ),
          
        ],
      ),
    );
  }
}

class Banner2Widget extends StatelessWidget {
  const Banner2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, 
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/banner2.png', fit: BoxFit.cover),
          ),

        ],
      ),
    );
  }
}

