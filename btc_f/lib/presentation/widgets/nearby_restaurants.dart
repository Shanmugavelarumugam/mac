import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class NearbyRestaurantsScreen extends StatefulWidget {
  const NearbyRestaurantsScreen({super.key});

  @override
  State<NearbyRestaurantsScreen> createState() =>
      _NearbyRestaurantsScreenState();
}

class _NearbyRestaurantsScreenState extends State<NearbyRestaurantsScreen> {
  List<dynamic> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNearbyRestaurants();
  }

  Future<void> fetchNearbyRestaurants() async {
    setState(() => isLoading = true);

    try {
      // ✅ 1. Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Please enable location services.")),
        );
        setState(() => isLoading = false);
        return;
      }

      // ✅ 2. Request permission
      final status = await Permission.locationWhenInUse.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Location permission denied")),
        );
        if (status.isPermanentlyDenied) {
          await openAppSettings(); // Prompt settings for manual permission
        }
        setState(() => isLoading = false);
        return;
      }

      // ✅ 3. Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ 4. Call backend API
    final response = await Dio().get(
        getNearbyRestaurantsApi(position.latitude, position.longitude),
      );


      setState(() {
        restaurants = response.data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching restaurants: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to fetch restaurants")),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Restaurants"),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : restaurants.isEmpty
              ? const Center(child: Text("No restaurants nearby"))
              : ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final res = restaurants[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: Colors.deepPurple,
                      ),
                      title: Text(res['name'] ?? 'Unnamed'),
                      subtitle: Text(res['address'] ?? 'No address'),
                      trailing: Text("⭐ ${res['rating'] ?? 'N/A'}"),
                    ),
                  );
                },
              ),
    );
  }
}
