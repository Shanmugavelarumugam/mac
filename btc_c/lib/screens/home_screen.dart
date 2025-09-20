import 'package:flutter/material.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_tile.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['Fashion', 'Beauty', 'Home', 'Electronics'];
  final List<Map<String, String>> products = List.generate(
    10,
    (index) => {
      'name': 'Product $index',
      'price': '₹${199 + index * 50}',
      'image': 'https://via.placeholder.com/150',
    },
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          BannerCarousel(),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) => CategoryTile(name: categories[i]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Trending Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          ),
        ],
      )               ,
    );
  }
}
