import 'package:flutter/material.dart';

class TravelActivitiesScreen extends StatelessWidget {
  const TravelActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Activities')),
      body: const Center(child: Text('Browse activities, tours, and plans')),
    );
  }
}
