import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTabBar extends StatelessWidget {
  const CategoryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-17, 8), 

      child: TabBar(
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.montserrat(),
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab('Women'),
          _buildTab('Men'),
          _buildTab('Accessories'),
          _buildTab('Beauty'),
          _buildTab('Kids'), 
          
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Text(title),
      ),
    );
  }
}
