// import 'package:flutter/material.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Map<String, String> product;

//   ProductDetailScreen({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(product['name']!)),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               product['image']!,
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 16),
//             Text(
//               product['name']!,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               product['price']!,
//               style: TextStyle(fontSize: 18, color: Colors.pink),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.shopping_cart),
//               label: Text("Add to Cart"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
