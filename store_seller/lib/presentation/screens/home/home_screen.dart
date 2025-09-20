// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class SellerDashboard extends StatefulWidget {
//   const SellerDashboard({super.key});

//   @override
//   State<SellerDashboard> createState() => _SellerDashboardState();
// }

// class _SellerDashboardState extends State<SellerDashboard> {
//   final List<Order> recentOrders = [
//     Order(
//       '#12345',
//       'John Doe',
//       DateTime.now().subtract(const Duration(hours: 2)),
//       149.99,
//       'Pending',
//     ),
//     Order(
//       '#12346',
//       'Jane Smith',
//       DateTime.now().subtract(const Duration(days: 1)),
//       89.99,
//       'Shipped',
//     ),
//     Order(
//       '#12347',
//       'Robert Johnson',
//       DateTime.now().subtract(const Duration(days: 1, hours: 5)),
//       229.99,
//       'Delivered',
//     ),
//     Order(
//       '#12348',
//       'Emily Davis',
//       DateTime.now().subtract(const Duration(days: 2)),
//       59.99,
//       'Pending',
//     ),
//     Order(
//       '#12349',
//       'Michael Wilson',
//       DateTime.now().subtract(const Duration(days: 3)),
//       199.99,
//       'Shipped',
//     ),
//   ];

//   final List<Product> lowStockProducts = [
//     Product('assets/product1.jpg', 'Wireless Headphones', 3),
//     Product('assets/product2.jpg', 'Smart Watch', 2),
//     Product('assets/product3.jpg', 'Phone Case', 4),
//   ];

//   final List<SalesData> salesData = [
//     SalesData(DateTime.now().subtract(const Duration(days: 6)), 1200),
//     SalesData(DateTime.now().subtract(const Duration(days: 5)), 800),
//     SalesData(DateTime.now().subtract(const Duration(days: 4)), 1500),
//     SalesData(DateTime.now().subtract(const Duration(days: 3)), 2000),
//     SalesData(DateTime.now().subtract(const Duration(days: 2)), 1700),
//     SalesData(DateTime.now().subtract(const Duration(days: 1)), 2300),
//     SalesData(DateTime.now(), 1900),
//   ];

//   bool showMonthlyRevenue = false;
//   final bestSellingProduct = 'Wireless Earbuds Pro';

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 375;
//     final scaleFactor = screenWidth / 390;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: Text(
//           "Seller Dashboard",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             fontSize: 18 * scaleFactor,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: const Color(0xFF1E293B),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Iconsax.notification, size: 22 * scaleFactor),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Refresh data logic
//           await Future.delayed(const Duration(seconds: 2));
//           setState(() {});
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16 * scaleFactor),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome header
//               _buildWelcomeHeader(scaleFactor),
//               SizedBox(height: 24 * scaleFactor),

//               // Stats Cards Grid
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12 * scaleFactor,
//                 mainAxisSpacing: 12 * scaleFactor,
//                 childAspectRatio: 0.85,
//                 children: [
//                   _buildStatCard(
//                     title: "Total Orders",
//                     value: "142",
//                     icon: Iconsax.shopping_bag,
//                     color: const Color(0xFF6A5AE0),
//                     scaleFactor: scaleFactor,
//                     onTap: () {},
//                   ),
//                   _buildStatCard(
//                     title: "Active Products",
//                     value: "38",
//                     icon: Iconsax.box,
//                     color: const Color(0xFF00B894),
//                     scaleFactor: scaleFactor,
//                     onTap: () {},
//                   ),
//                   _buildRevenueCard(scaleFactor),
//                   _buildStatCard(
//                     title: "Pending Orders",
//                     value: "7",
//                     icon: Iconsax.clock,
//                     color: const Color(0xFFFFA726),
//                     scaleFactor: scaleFactor,
//                     onTap: () {},
//                   ),
//                 ],
//               ),

//               SizedBox(height: 24 * scaleFactor),

//               // Quick Actions Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildQuickActionButton(
//                       icon: Iconsax.add,
//                       label: "Add Product",
//                       scaleFactor: scaleFactor,
//                       onTap: () {},
//                     ),
//                   ),
//                   SizedBox(width: 12 * scaleFactor),
//                   Expanded(
//                     child: _buildQuickActionButton(
//                       icon: Iconsax.shopping_bag,
//                       label: "View Orders",
//                       scaleFactor: scaleFactor,
//                       onTap: () {},
//                     ),
//                   ),
//                   SizedBox(width: 12 * scaleFactor),
//                   Expanded(
//                     child: _buildQuickActionButton(
//                       icon: Iconsax.chart_2,
//                       label: "Analytics",
//                       scaleFactor: scaleFactor,
//                       onTap: () {},
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 24 * scaleFactor),

//               // Sales Chart Section
//               _buildSalesChart(scaleFactor),
//               SizedBox(height: 24 * scaleFactor),

//               // Recent Orders Section
//               _buildSectionHeader(
//                 title: "Recent Orders",
//                 actionText: "View All",
//                 scaleFactor: scaleFactor,
//                 onAction: () {},
//               ),
//               SizedBox(height: 12 * scaleFactor),
//               _buildRecentOrders(scaleFactor),

//               SizedBox(height: 24 * scaleFactor),

//               // Low Stock Alerts Section
//               _buildSectionHeader(
//                 title: "Low Stock Alerts",
//                 actionText: "Manage",
//                 scaleFactor: scaleFactor,
//                 onAction: () {},
//               ),
//               SizedBox(height: 12 * scaleFactor),
//               _buildLowStockProducts(scaleFactor),

//               SizedBox(height: 24 * scaleFactor),

//               // Best Selling Product
//               _buildBestSellingProduct(scaleFactor),

//               SizedBox(height: 20 * scaleFactor),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(scaleFactor),
//     );
//   }

//   Widget _buildWelcomeHeader(double scaleFactor) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF6A5AE0), Color(0xFF8B78FF)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6A5AE0).withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Welcome back!",
//             style: GoogleFonts.poppins(
//               fontSize: 14 * scaleFactor,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//           SizedBox(height: 4 * scaleFactor),
//           Text(
//             "Your store is doing great",
//             style: GoogleFonts.poppins(
//               fontSize: 18 * scaleFactor,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 8 * scaleFactor),
//           Text(
//             "+12% revenue this week",
//             style: GoogleFonts.poppins(
//               fontSize: 12 * scaleFactor,
//               color: Colors.white.withOpacity(0.8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required double scaleFactor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(16 * scaleFactor),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               width: 40 * scaleFactor,
//               height: 40 * scaleFactor,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 20 * scaleFactor),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//                 SizedBox(height: 4 * scaleFactor),
//                 Text(
//                   value,
//                   style: GoogleFonts.poppins(
//                     fontSize: 20 * scaleFactor,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRevenueCard(double scaleFactor) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           showMonthlyRevenue = !showMonthlyRevenue;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(16 * scaleFactor),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 40 * scaleFactor,
//                   height: 40 * scaleFactor,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFF4757).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Iconsax.dollar_circle,
//                     color: const Color(0xFFFF4757),
//                     size: 20 * scaleFactor,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8 * scaleFactor,
//                     vertical: 4 * scaleFactor,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6A5AE0).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     showMonthlyRevenue ? "Monthly" : "Today",
//                     style: GoogleFonts.poppins(
//                       fontSize: 10 * scaleFactor,
//                       color: const Color(0xFF6A5AE0),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Revenue",
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//                 SizedBox(height: 4 * scaleFactor),
//                 Text(
//                   showMonthlyRevenue ? "\$12,458" : "\$1,245",
//                   style: GoogleFonts.poppins(
//                     fontSize: 20 * scaleFactor,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//                 SizedBox(height: 8 * scaleFactor),
//                Container(
//                   height: 30 * scaleFactor,
//                   child: SfCartesianChart(
//                     margin: EdgeInsets.zero,
//                     plotAreaBorderWidth: 0,
//                     primaryXAxis: CategoryAxis(isVisible: false),
//                     primaryYAxis: NumericAxis(isVisible: false),
//                     series: <CartesianSeries<SalesData, String>>[
//                       SplineAreaSeries<SalesData, String>(
//                         dataSource: salesData,
//                         xValueMapper: (SalesData sales, _) =>
//                             sales.date.day.toString(),
//                         yValueMapper: (SalesData sales, _) => sales.amount,
//                         color: const Color(0xFFFF4757).withOpacity(0.2),
//                         borderColor: const Color(0xFFFF4757),
//                         borderWidth: 2,
//                       ),
//                     ],
//                   ),
//                 ),

//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSalesChart(double scaleFactor) {
//     return Container(
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Sales Overview",
//             style: GoogleFonts.poppins(
//               fontSize: 16 * scaleFactor,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF1E293B),
//             ),
//           ),
//           SizedBox(height: 16 * scaleFactor),
//           Container(
//             height: 200 * scaleFactor,
//             child: SfCartesianChart(
//               primaryXAxis: CategoryAxis(
//                 labelStyle: GoogleFonts.poppins(fontSize: 10 * scaleFactor),
//               ),
//               primaryYAxis: NumericAxis(
//                 labelStyle: GoogleFonts.poppins(fontSize: 10 * scaleFactor),
//               ),
//               series: <CartesianSeries<SalesData, String>>[
//                 ColumnSeries<SalesData, String>(
//                   dataSource: salesData,
//                   xValueMapper: (SalesData sales, _) {
//                     final day = sales.date.day;
//                     final month = sales.date.month;
//                     return '$day/$month';
//                   },
//                   yValueMapper: (SalesData sales, _) => sales.amount,
//                   color: const Color(0xFF6A5AE0),
//                   borderRadius: BorderRadius.all(Radius.circular(4)),
//                 ),
//               ],
//             ),
//           ),

//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionButton({
//     required IconData icon,
//     required String label,
//     required double scaleFactor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 12 * scaleFactor,
//           horizontal: 8 * scaleFactor,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 40 * scaleFactor,
//               height: 40 * scaleFactor,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A5AE0).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 18 * scaleFactor,
//                 color: const Color(0xFF6A5AE0),
//               ),
//             ),
//             SizedBox(height: 8 * scaleFactor),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 11 * scaleFactor,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF6A5AE0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader({
//     required String title,
//     required String actionText,
//     required double scaleFactor,
//     required VoidCallback onAction,
//   }) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 16 * scaleFactor,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF1E293B),
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: onAction,
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 12 * scaleFactor,
//               vertical: 6 * scaleFactor,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               actionText,
//               style: GoogleFonts.poppins(
//                 fontSize: 12 * scaleFactor,
//                 color: const Color(0xFF6A5AE0),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRecentOrders(double scaleFactor) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           ...recentOrders.map((order) => _buildOrderItem(order, scaleFactor)),
//           GestureDetector(
//             onTap: () {},
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 16 * scaleFactor),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8FAFC),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "View All Orders",
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     color: const Color(0xFF6A5AE0),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(Order order, double scaleFactor) {
//     Color statusColor;
//     IconData statusIcon;
//     switch (order.status) {
//       case 'Pending':
//         statusColor = const Color(0xFFFFA726);
//         statusIcon = Iconsax.clock;
//         break;
//       case 'Shipped':
//         statusColor = const Color(0xFF6A5AE0);
//         statusIcon = Iconsax.truck;
//         break;
//       case 'Delivered':
//         statusColor = const Color(0xFF00B894);
//         statusIcon = Iconsax.tick_circle;
//         break;
//       default:
//         statusColor = const Color(0xFF64748B);
//         statusIcon = Iconsax.info_circle;
//     }

//     return Container(
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: const Color(0xFFE2E8F0).withOpacity(0.5),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40 * scaleFactor,
//             height: 40 * scaleFactor,
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(statusIcon, color: statusColor, size: 20 * scaleFactor),
//           ),
//           SizedBox(width: 12 * scaleFactor),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   order.id,
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//                 SizedBox(height: 4 * scaleFactor),
//                 Text(
//                   order.customerName,
//                   style: GoogleFonts.poppins(
//                     fontSize: 11 * scaleFactor,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "\$${order.amount.toStringAsFixed(2)}",
//                 style: GoogleFonts.poppins(
//                   fontSize: 12 * scaleFactor,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF1E293B),
//                 ),
//               ),
//               SizedBox(height: 4 * scaleFactor),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 8 * scaleFactor,
//                   vertical: 4 * scaleFactor,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   order.status,
//                   style: GoogleFonts.poppins(
//                     fontSize: 10 * scaleFactor,
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLowStockProducts(double scaleFactor) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           ...lowStockProducts.map(
//             (product) => _buildLowStockItem(product, scaleFactor),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLowStockItem(Product product, double scaleFactor) {
//     return Container(
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: const Color(0xFFE2E8F0).withOpacity(0.5),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40 * scaleFactor,
//             height: 40 * scaleFactor,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(8),
//               image: DecorationImage(
//                 image: AssetImage(product.image),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(width: 12 * scaleFactor),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF1E293B),
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4 * scaleFactor),
//                 Row(
//                   children: [
//                     Icon(
//                       Iconsax.box,
//                       size: 12 * scaleFactor,
//                       color: const Color(0xFFFF4757),
//                     ),
//                     SizedBox(width: 4 * scaleFactor),
//                     Text(
//                       "${product.stock} left",
//                       style: GoogleFonts.poppins(
//                         fontSize: 11 * scaleFactor,
//                         color: const Color(0xFFFF4757),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12 * scaleFactor),
//           GestureDetector(
//             onTap: () {},
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 12 * scaleFactor,
//                 vertical: 6 * scaleFactor,
//               ),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A5AE0),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 "Restock",
//                 style: GoogleFonts.poppins(
//                   fontSize: 10 * scaleFactor,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBestSellingProduct(double scaleFactor) {
//     return Container(
//       padding: EdgeInsets.all(16 * scaleFactor),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50 * scaleFactor,
//             height: 50 * scaleFactor,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFFFFA726), Color(0xFFFFCC80)],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Iconsax.crown1,
//               size: 24 * scaleFactor,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(width: 12 * scaleFactor),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Today's Best Seller",
//                   style: GoogleFonts.poppins(
//                     fontSize: 12 * scaleFactor,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//                 SizedBox(height: 4 * scaleFactor),
//                 Text(
//                   bestSellingProduct,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14 * scaleFactor,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             Iconsax.arrow_right_3,
//             size: 20 * scaleFactor,
//             color: const Color(0xFF64748B),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar(double scaleFactor) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(vertical: 8 * scaleFactor),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Iconsax.home, "Dashboard", true, scaleFactor),
//           _buildNavItem(Iconsax.box, "Products", false, scaleFactor),
//           _buildNavItem(Iconsax.shopping_bag, "Orders", false, scaleFactor),
//           _buildNavItem(Iconsax.dollar_circle, "Earnings", false, scaleFactor),
//           _buildNavItem(Iconsax.user, "Profile", false, scaleFactor),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     IconData icon,
//     String label,
//     bool isActive,
//     double scaleFactor,
//   ) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           size: 22 * scaleFactor,
//           color: isActive ? const Color(0xFF6A5AE0) : const Color(0xFF94A3B8),
//         ),
//         SizedBox(height: 4 * scaleFactor),
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 10 * scaleFactor,
//             color: isActive ? const Color(0xFF6A5AE0) : const Color(0xFF94A3B8),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Order {
//   final String id;
//   final String customerName;
//   final DateTime date;
//   final double amount;
//   final String status;

//   Order(this.id, this.customerName, this.date, this.amount, this.status);
// }

// class Product {
//   final String image;
//   final String name;
//   final int stock;

//   Product(this.image, this.name, this.stock);
// }

// class SalesData {
//   final DateTime date;
//   final double amount;

//   SalesData(this.date, this.amount);
// }
