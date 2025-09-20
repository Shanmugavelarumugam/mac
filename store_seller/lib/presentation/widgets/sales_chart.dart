import 'package:btc_store/data/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:btc_store/data/models/seller_dashboard_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class SalesChart extends StatelessWidget {
  final SellerDashboardModel dashboard;
  final double scaleFactor;

  const SalesChart({
    super.key,
    required this.dashboard,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final gridColor = isDarkMode ? Colors.white12 : Colors.black12;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;

    // Total orders for percentage calculation
    final totalOrders = dashboard.orderStatusCount.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

    final SelectionBehavior _selectionBehavior = SelectionBehavior(
      enable: true,
      toggleSelection: true,
    );

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24 * scaleFactor),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------------- Monthly Sales Line Chart ----------------
            Text(
              'Monthly Sales Trend',
              style: GoogleFonts.poppins(
                fontSize: 16 * scaleFactor,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            SizedBox(
              height: 200 * scaleFactor,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: const Color(0xFF6A5AE0),
                  builder:
                      (
                        dynamic data,
                        dynamic point,
                        dynamic series,
                        int pointIndex,
                        int seriesIndex,
                      ) {
                        final MonthlyStat stat = data;
                        final dt = DateTime.tryParse(stat.date);
                        final dateStr = dt != null
                            ? DateFormat('MMM dd, yyyy').format(dt)
                            : stat.date;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A5AE0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$dateStr : ${stat.totalSold}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * scaleFactor,
                            ),
                          ),
                        );
                      },
                ),
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    fontSize: 10 * scaleFactor,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  majorGridLines: MajorGridLines(color: gridColor),
                  axisLine: AxisLine(color: textColor.withOpacity(0.7)),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(
                    fontSize: 10 * scaleFactor,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  majorGridLines: MajorGridLines(color: gridColor),
                  axisLine: AxisLine(color: textColor.withOpacity(0.7)),
                ),
                series: <LineSeries<MonthlyStat, String>>[
                  LineSeries<MonthlyStat, String>(
                    dataSource: List.from(dashboard.monthlyStats)
                      ..sort((a, b) {
                        final dateA =
                            DateTime.tryParse(a.date) ?? DateTime.now();
                        final dateB =
                            DateTime.tryParse(b.date) ?? DateTime.now();
                        return dateA.compareTo(dateB);
                      }),
                    xValueMapper: (s, _) {
                      final dt = DateTime.tryParse(s.date);
                      return dt != null
                          ? DateFormat('dd/MM').format(dt)
                          : s.date;
                    },
                    yValueMapper: (s, _) => s.totalSold,
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      width: 8,
                      height: 8,
                      shape: DataMarkerType.circle,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      color: Color(0xFF6A5AE0),
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: textColor,
                        fontSize: 9 * scaleFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32 * scaleFactor),

            // ---------------- Order Status Pie Chart ----------------
            Text(
              'Order Status Distribution',
              style: GoogleFonts.poppins(
                fontSize: 16 * scaleFactor,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            SizedBox(
              height: 220 * scaleFactor,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(
                    fontSize: 11 * scaleFactor,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                series: <CircularSeries>[
                  DoughnutSeries<OrderStatusCount, String>(
                    dataSource: dashboard.orderStatusCount,
                    xValueMapper: (s, _) => s.status,
                    yValueMapper: (s, _) => s.count,
                    pointColorMapper: (s, _) => _statusColor(s.status),
                    innerRadius: '60%',
                    explode: true,
                    explodeOffset: '8%',
                    animationDuration: 1500,
                    dataLabelMapper: (s, _) =>
                        "${((s.count / totalOrders) * 100).toStringAsFixed(1)}%",
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        fontSize: 10 * scaleFactor,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: const Color(0xFF6A5AE0),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12 * scaleFactor,
                  ),
                  format: 'point.x : point.y',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF00B894);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'shipping':
        return const Color(0xFF0984E3);
      case 'cancelled':
        return const Color(0xFFE17055);
      default:
        return const Color(0xFF6C5CE7);
    }
  }
}
