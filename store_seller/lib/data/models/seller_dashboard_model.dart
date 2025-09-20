import 'package:btc_store/data/models/dashboard_model.dart';

class SellerDashboardModel {
  final int totalSales;
  final int totalRevenue;
  final int todayTotalOrder;
  final List<OrderStatusCount> orderStatusCount;
  final int totalProducts;
  final List<LowStockProduct> lowStockProducts;
  final int countOfCustomer;
  final List<MonthlyStat> monthlyStats;

  SellerDashboardModel({
    required this.totalSales,
    required this.totalRevenue,
    required this.todayTotalOrder,
    required this.orderStatusCount,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.countOfCustomer,
    required this.monthlyStats,
  });

  factory SellerDashboardModel.fromJson(Map<String, dynamic> json) {
    return SellerDashboardModel(
      totalSales: json['TotalSales'] ?? 0,
      totalRevenue: json['TotalRevenue'] ?? 0,
      todayTotalOrder: json['TodayTotalOrder'] ?? 0,
      orderStatusCount: (json['orderStatusCount'] as List? ?? [])
          .map((e) => OrderStatusCount.fromJson(e))
          .toList(),
      totalProducts: json['TotalProducts'] ?? 0,
      lowStockProducts: (json['LowStockProducts'] as List? ?? [])
          .map((e) => LowStockProduct.fromJson(e))
          .toList(),
      countOfCustomer: json['CountOfCustomer'] ?? 0,
      monthlyStats: (json['monthlyStats'] as List? ?? [])
          .map((e) => MonthlyStat.fromJson(e))
          .toList(),
    );
  }
}
