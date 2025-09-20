import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.secondary,
                  size: 20,
                ),
                hintText: "Search messages...",
                hintStyle: TextStyle(color: AppColors.secondary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: onSearch,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(Iconsax.filter, color: AppColors.primary, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
