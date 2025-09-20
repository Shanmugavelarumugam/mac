import 'package:btc/services/trip_service.dart';
import 'package:flutter/material.dart';

class SettlementScreen extends StatefulWidget {
  final int tripId;

  const SettlementScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  _SettlementScreenState createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  final TripService service = TripService();
  Map<String, dynamic>? settlementData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      final settlement = await service.getSettlement(widget.tripId);
      setState(() {
        settlementData = settlement;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settlement',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            settlementData == null
                ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 32),
                    const Text(
                      'Settlement Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: settlementData!['settlement'].length,
                        itemBuilder: (context, index) {
                          final s = settlementData!['settlement'][index];
                          return _buildSettlementTile(
                            name: s['name'],
                            paid: (s['paid'] as num).toDouble(),
                            balance: (s['balance'] as num).toDouble(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '₹${settlementData!['total']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0072FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Per Person:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '₹${settlementData!['share']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0072FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementTile({
    required String name,
    required double paid,
    required double balance,
  }) {
    final bool isBalanced = balance.abs() < 0.01;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF0072FF),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.6,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Paid: ₹${paid.toStringAsFixed(2)}\n',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
              TextSpan(
                text: 'Balance: ₹${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isBalanced ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
