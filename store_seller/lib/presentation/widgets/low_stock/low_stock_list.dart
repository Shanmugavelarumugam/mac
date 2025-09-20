import 'package:btc_store/data/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:btc_store/data/models/product_model.dart';
import 'package:iconsax/iconsax.dart';

class LowStockScreen extends StatelessWidget {
  final List<LowStockProduct> products; // ✅ Change type here

  const LowStockScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Low Stock Products",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: product.image.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey.shade200,
                ),
                child: product.image.isEmpty
                    ? const Icon(Iconsax.box, color: Colors.grey)
                    : null,
              ),
              title: Text(
                product.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Row(
                children: [
                  const Icon(Iconsax.box, size: 14, color: Color(0xFFFF4757)),
                  const SizedBox(width: 4),
                  Text(
                    "${product.stock} left",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFFFF4757),
                    ),
                  ),
                ],
              ),
              trailing: TextButton(
                onPressed: () {
                  // TODO: Add restock logic
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text("Restock"),
              ),
            ),
          );
        },
      ),
    );
  }
}
