// import 'package:flutter/material.dart';
// import 'package:web_app/presentation/screens/search_home_page.dart';

// class CategoryProductsScreen extends StatelessWidget {
//   final Category category;

//   const CategoryProductsScreen({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category.title),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Products in ${category.title}",
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.white : Colors.grey[800],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.9,
//                 ),
//                 itemCount: category.products.length,
//                 itemBuilder: (context, index) {
//                   return _buildProductCard(category.products[index], isDark);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductCard(Product product, bool isDark) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: isDark ? Colors.grey[800] : Colors.white,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(product.icon, size: 40, color: product.color),
//             const SizedBox(height: 12),
//             Text(
//               product.name,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: isDark ? Colors.white : Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
