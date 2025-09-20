import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Financial News")),
      body: Center(child: Text("Stay updated with financial news.")),
    );
  }
}
