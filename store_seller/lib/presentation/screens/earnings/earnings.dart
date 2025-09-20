import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedFilter = 0; // 0: Daily, 1: Weekly, 2: Monthly
  int _selectedTab = 0; // 0: Dashboard, 1: Withdraw, 2: History

  // Sample data
  final List<Map<String, dynamic>> _transactions = [
    {
      'date': '2023-10-15',
      'amount': 2500.00,
      'type': 'Bank Transfer',
      'status': 'Completed',
      'id': 'TX123456789',
    },
    {
      'date': '2023-10-10',
      'amount': 1500.00,
      'type': 'UPI',
      'status': 'Completed',
      'id': 'TX987654321',
    },
    {
      'date': '2023-10-05',
      'amount': 3200.00,
      'type': 'Bank Transfer',
      'status': 'Processing',
      'id': 'TX456789123',
    },
    {
      'date': '2023-10-01',
      'amount': 1800.00,
      'type': 'UPI',
      'status': 'Failed',
      'id': 'TX789123456',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Earnings & Payments",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildDashboard(isSmallScreen),
          _buildWithdrawScreen(isSmallScreen),
          _buildTransactionHistory(isSmallScreen),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDashboard(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Filter
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _buildTimeFilterButton('Daily', 0, isSmallScreen),
                _buildTimeFilterButton('Weekly', 1, isSmallScreen),
                _buildTimeFilterButton('Monthly', 2, isSmallScreen),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Cards
          GridView.count(
            crossAxisCount: isSmallScreen ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isSmallScreen ? 1.4 : 1.1,
            children: [
              _buildStatCard(
                "Total Revenue",
                "₹12,458.00",
                Icons.currency_rupee_rounded,
                const Color(0xFF6366F1),
              ),
              _buildStatCard(
                "Available Balance",
                "₹8,245.00",
                Icons.account_balance_wallet_rounded,
                const Color(0xFF10B981),
              ),
              _buildStatCard(
                "Commission Cut",
                "₹1,245.00",
                Icons.percent_rounded,
                const Color(0xFFF59E0B),
              ),
              _buildStatCard(
                "Pending Payouts",
                "₹3,245.00",
                Icons.pending_actions_rounded,
                const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Earnings Chart
          _buildEarningsChart(),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          isSmallScreen
              ? Column(
                  children: [
                    _buildActionButton(
                      "Withdraw Now",
                      Icons.account_balance_rounded,
                      const Color(0xFF6366F1),
                      () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      "View History",
                      Icons.history_rounded,
                      const Color(0xFF10B981),
                      () {
                        setState(() {
                          _selectedTab = 2;
                        });
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        "Withdraw Now",
                        Icons.account_balance_rounded,
                        const Color(0xFF6366F1),
                        () {
                          setState(() {
                            _selectedTab = 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        "View History",
                        Icons.history_rounded,
                        const Color(0xFF10B981),
                        () {
                          setState(() {
                            _selectedTab = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimeFilterButton(String text, int index, bool isSmallScreen) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 8 : 10,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 12 : 14,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Earnings Trend",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: CustomPaint(painter: _LineChartPainter()),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mon", style: TextStyle(color: Color(0xFF64748B))),
              Text("Tue", style: TextStyle(color: Color(0xFF64748B))),
              Text("Wed", style: TextStyle(color: Color(0xFF64748B))),
              Text("Thu", style: TextStyle(color: Color(0xFF64748B))),
              Text("Fri", style: TextStyle(color: Color(0xFF64748B))),
              Text("Sat", style: TextStyle(color: Color(0xFF64748B))),
              Text("Sun", style: TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawScreen(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Withdraw Funds",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Transfer your earnings to your bank account or UPI ID",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Available Balance Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Available Balance",
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  "₹8,245.00",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Next settlement date:",
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                    Text(
                      "Oct 20, 2023",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Withdrawal Form
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Withdrawal Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFormField(
                  "Withdrawal Amount",
                  "Enter amount",
                  TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildPaymentMethodSelector(),
                const SizedBox(height: 20),
                _buildFormField(
                  "Remarks (Optional)",
                  "e.g. Monthly withdrawal",
                  TextInputType.text,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showWithdrawalConfirmation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Request Withdrawal",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String hint,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF6366F1),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Method",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      color: Color(0xFF6366F1),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Bank Transfer",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      color: Color(0xFF64748B),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "UPI",
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionHistory(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transaction History",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "View all your withdrawal requests and settlements",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Filter and Export
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Status",
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.expand_more_rounded,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Transactions List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    Color statusColor;
    switch (transaction['status']) {
      case 'Completed':
        statusColor = const Color(0xFF10B981);
        break;
      case 'Processing':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'Failed':
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusColor = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction['date'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaction['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['type'],
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction['id'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Text(
                "₹${transaction['amount'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Withdraw',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }

  void _showWithdrawalConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Confirm Withdrawal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to proceed with this withdrawal request?",
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Withdrawal request submitted successfully!",
                            ),
                            backgroundColor: Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the earnings chart
class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x306366F1), Color(0x006366F1)],
          ).createShader(
            Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          )
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width, size.height * 0.5),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
