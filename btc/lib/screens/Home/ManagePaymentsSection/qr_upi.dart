import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class QRAndUPIScreen extends StatelessWidget {
  const QRAndUPIScreen({super.key});
  static const customColor = Color(0xFF009688);
  static const darkTextColor = Color(0xFF004D40); // Dark text
  static const customGreen = Color.fromARGB(255, 159, 190, 187);

  final String upiId = '9876543210@ybl';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: darkTextColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.help_outline,
                        color: darkTextColor,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Help tapped')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              
                const SizedBox(height: 16),
                Text(
                  'UPI ID: 9876543210@abc',
                  style: const TextStyle(
                    fontFamily: 'Poppins', // Set font to Poppins
                    letterSpacing: 0.1,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                /// Scan QR Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Navigate to scanner screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open QR Scanner')),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR to Pay'),
                ),

                const SizedBox(height: 20),

                /// Share UPI Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    side: const BorderSide(color: Color(0xFF009688)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Share.share('Pay me via UPI ID: $upiId');
                  },
                  icon: const Icon(Icons.share, color: Color(0xFF009688)),
                  label: const Text(
                    'Share UPI ID',
                    style: TextStyle(
                      color: Color(0xFF009688),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
