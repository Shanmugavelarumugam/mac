import 'package:flutter/material.dart';
import 'add_trip_screen.dart';
import 'add_transaction_screen.dart';
import 'settlement_screen.dart';
import 'package:btc/services/trip_service.dart';
import 'package:btc/models/trip.dart';

class TripScreen extends StatefulWidget {
  final int userId;

  const TripScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final TripService service = TripService();
  List<Trip> trips = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print("🔄 TripScreen initialized for userId: ${widget.userId}");
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    print("📡 Fetching trips for userId: ${widget.userId}");
    try {
      final fetchedTrips = await service.getTripsByUserId(widget.userId);
      print("✅ Trips fetched successfully. Count: ${fetchedTrips.length}");
      for (var trip in fetchedTrips) {
        print("   - Trip ID: ${trip.id}, Place: ${trip.place}");
      }
      setState(() {
        trips = fetchedTrips;
        isLoading = false;
        errorMessage = null; // clear error
      });
    } catch (e) {
      final msg = e.toString();
      if (msg.contains("No trips found")) {
        print("ℹ No trips for this user — showing empty state.");
        setState(() {
          trips = []; // just empty, not an error
          isLoading = false;
          errorMessage = null;
        });
      } else {
        print("❌ Failed to load trips: $e");
        setState(() {
          errorMessage = 'Failed to load trips: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    // Use the first trip ID or null if no trips
    final int? currentTripId = trips.isNotEmpty ? trips[0].id : null;
    print("📌 CurrentTripId in UI: $currentTripId");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Trip Manager',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TripButton(
              title: 'Create Trip',
              icon: Icons.add_location_alt,
              onTap: () async {
                print("🛠 'Create Trip' button tapped.");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTripScreen(userId: widget.userId),
                  ),
                );
                print("🔄 Returning from Create Trip. Refreshing trip list...");
                fetchTrips();
              },
            ),
            const SizedBox(height: 20),
            TripButton(
              title: 'Add Transaction',
              icon: Icons.attach_money,
              onTap: () {
                if (currentTripId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please create a trip first')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AddTransactionScreen(
                            tripId: currentTripId,
                            userId: widget.userId,
                          ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TripButton(
              title: 'View Settlement',
              icon: Icons.receipt_long,
              onTap: () {
                if (currentTripId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please create a trip first')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettlementScreen(tripId: currentTripId),
                    ),
                  );
                }
              },
            ),

            if (currentTripId == null) ...[
              const SizedBox(height: 40),
              const Text(
                'No trips found. Please create a trip first.',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TripButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const TripButton({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white.withOpacity(0.85) : Colors.white38,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isEnabled ? Colors.teal : Colors.grey, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
