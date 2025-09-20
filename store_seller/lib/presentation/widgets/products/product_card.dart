import 'package:btc_store/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_card_actions.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        product.price - (product.price * product.discount / 100);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildContentSection(discountedPrice, context),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: _buildProductImage(),
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (product.discount > 0) _buildDiscountBadge(),
                _buildStatusBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${product.discount.toInt()}% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isActive = product.isAvailable;
    final color = isActive ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildContentSection(double discountedPrice, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth > 400 ? 14 : 13,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),

          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.category,
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: screenWidth > 400 ? 10 : 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Stock & rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: screenWidth > 400 ? 12 : 11,
                    color: product.stock > 10
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.stock} in stock',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 11 : 10,
                      fontWeight: FontWeight.w600,
                      color: product.stock > 10
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFBBF24),
                    size: screenWidth > 400 ? 12 : 11,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    product.averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: screenWidth > 400 ? 11 : 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pricing
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '₹${discountedPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth > 400 ? 16 : 15,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  if (product.discount > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: screenWidth > 400 ? 12 : 11,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              if (product.discount > 0)
                Text(
                  'Save ₹${(product.price - discountedPrice).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: const Color(0xFF10B981),
                    fontSize: screenWidth > 400 ? 10 : 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Actions (Edit/Delete)
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Edit',
                  const Color(0xFF3B82F6),
                  onEdit, // <-- call the callback
                  screenWidth < 400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Delete',
                  const Color(0xFFEF4444),
                  onDelete, // <-- call the callback
                  screenWidth < 400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback onPressed,
    bool isSmall,
  ) {
    return SizedBox(
      height: isSmall ? 28 : 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 10 : 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.image.isEmpty || product.image == "jssks.png") {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          ),
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 28, color: Color(0xFF94A3B8)),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 24,
          ),
        ),
      ),
    );
  }
}
