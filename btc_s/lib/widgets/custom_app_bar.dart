import 'package:btc_s/utils/assets.dart';
import 'package:btc_s/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final VoidCallback? onNotificationTap;

  const CustomAppBar({
    Key? key,
    required this.onMenuTap,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        leading: IconButton(
          icon: AppIcon(imagePath: AppImages.menu, width: 20, height: 20),
          onPressed: onMenuTap,
        ),
        title: Text(
          'Trade Outfit',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onNotificationTap ?? () {},
              child: AppIcon(
                imagePath: AppImages.notification,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
