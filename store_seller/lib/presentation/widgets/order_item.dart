import 'package:btc_store/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class OrderItemList extends StatelessWidget {
  final List<Order> orders;
  final double scaleFactor;

  const OrderItemList({
    super.key,
    required this.orders,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12 * scaleFactor),
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: orders.take(3).map((o) => _buildOrderItem(o)).toList(),
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    Color statusColor;
    IconData statusIcon;
    switch (order.status) {
      case 'Pending':
        statusColor = const Color(0xFFFFA726);
        statusIcon = Iconsax.clock;
        break;
      case 'Shipped':
        statusColor = const Color(0xFF6A5AE0);
        statusIcon = Iconsax.truck;
        break;
      case 'Delivered':
        statusColor = const Color(0xFF00B894);
        statusIcon = Iconsax.tick_circle;
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusIcon = Iconsax.info_circle;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0).withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40 * scaleFactor,
            height: 40 * scaleFactor,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20 * scaleFactor),
          ),
          SizedBox(width: 12 * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: GoogleFonts.poppins(
                    fontSize: 12 * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  order.customerName,
                  style: GoogleFonts.poppins(
                    fontSize: 11 * scaleFactor,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${order.amount.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 12 * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4 * scaleFactor),
                padding: EdgeInsets.symmetric(
                  horizontal: 8 * scaleFactor,
                  vertical: 4 * scaleFactor,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10 * scaleFactor,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
