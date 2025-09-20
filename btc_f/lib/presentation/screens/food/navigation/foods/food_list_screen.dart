import 'package:btc_f/logic/food/food_bloc.dart';
import 'package:btc_f/logic/food/food_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'food_search_bar.dart';
import 'food_section.dart';
import 'restaurant_section.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  String query = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Main Course',
    'Starters',
    'Desserts',
    'Drinks',
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermissionAndLoadFoods();
  }

  Future<void> _requestLocationPermissionAndLoadFoods() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enable location services.')),
      );
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      BlocProvider.of<FoodBloc>(context).add(LoadFoods());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Location permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: const Text('Delicious Foods 🍽️'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FoodSearchBar(
              query: query,
              selectedCategory: selectedCategory,
              categories: categories,
              onQueryChanged: (val) => setState(() => query = val),
              onCategoryChanged: (cat) {
                setState(() => selectedCategory = cat);
                if (cat == 'All') {
                  BlocProvider.of<FoodBloc>(context).add(LoadFoods());
                } else {
                  BlocProvider.of<FoodBloc>(
                    context,
                  ).add(LoadFoodsByCategory(cat));
                }
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FoodSection(
                query: query,
                selectedCategory: selectedCategory,
              ),
            ),
          ],
        ),     
      ),
    );
  }
}
