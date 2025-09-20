import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureProductGrid extends StatelessWidget {
  const FeatureProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productImages = [
      'assets/fp1.png',
      'assets/fp2.png',
      'assets/fp3.png',
    ];

    final productNames = [
      'Turtleneck Sweater',
      'Long Sleeve Dress',
      'Sportwear Set',
    ];

    final productPrices = ['\$49.99', '\$79.99', '\$39.99'];

    return SizedBox(
      height: 230, // increased height to fit image + text
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: productImages.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(productImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                productNames[index],
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                productPrices[index],
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,

                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
