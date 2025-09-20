import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

Widget shimmerLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder:
            (_, __) => Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
      ),
    ),
  );
}

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({super.key});

 Future<List<dynamic>> _fetchRestaurants(String endpoint) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          debugPrint("Location permission denied");
          return [];
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final response = await Dio().get(
        getRestaurantByLocationApi(endpoint),

        queryParameters: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );
      return response.data;
    } catch (e) {
      debugPrint('Fetch error [$endpoint]: $e');
      return [];
    }
  }


  Widget _restaurantCard(dynamic res) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              res['profile_image'] ?? '',
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.restaurant,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  res['name'] ?? 'Unnamed',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  res['address'] ?? 'No address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '⭐ ${res['rating']?.toStringAsFixed(1) ?? '0.0'}',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(String title, String endpoint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<dynamic>>(
          future: _fetchRestaurants(endpoint),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerLoader();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('😕 No restaurants found near you.'),
                ),
              );
            }

            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder:
                    (_, index) => _restaurantCard(snapshot.data![index]),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRestaurantList('Nearby Restaurants', 'nearby'),
        _buildRestaurantList('Top Rated Nearby', 'top-rated-nearby'),
      ],
    );
  }
}
