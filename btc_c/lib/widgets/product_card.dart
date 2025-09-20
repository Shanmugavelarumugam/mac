// import 'package:flutter/material.dart';
// import '../screens/product_detail_screen.dart';

// class ProductCard extends StatelessWidget {
//   final Map<String, String> product;

//   ProductCard({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductDetailScreen(product: product),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               product['image']!,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 product['name']!,
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 product['price']!,
//                 style: TextStyle(color: Colors.pink),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
